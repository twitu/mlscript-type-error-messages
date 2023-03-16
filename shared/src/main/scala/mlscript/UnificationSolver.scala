package mlscript

import mlscript.Message.MessageContext
import mlscript.utils._
import mlscript.utils.shorthands._

import scala.collection.mutable.{Set => MutSet, Map => MutMap}

trait UnificationSolver extends TyperDatatypes {
  self: Typer =>

  val errorCache: MutMap[(ST, ST), Unification] = MutMap()
  val cache: MutSet[(ST, ST)] = MutSet()
  var unifyMode: Bool = false

  // Unify all type variables crated by accessing them from the hook
  def unifyTypes()(implicit ctx: Ctx, raise: Raise): Unit = {
    errorCache.clear()
    cache.clear()

    // register all bounds as unifications
    TypeVariable.createdTypeVars.foreach(tv => {
      println(s"$tv is ${tv.prov.desc} and it's bounds are")
      tv.lowerBounds.foreach(lb => {
        val reason = LB(lb, tv, lb.typeUseLocations.reverse)
        println(s"U $tv <: $lb with ${reason.provs.length} provs")
        tv.new_unification += ((lb, reason))
        println(s"U ${tv} += ${(lb, reason)}")
      })
      tv.upperBounds.foreach(ub => {
        val reason = UB(tv, ub, ub.typeUseLocations)
        println(s"U $tv :> $ub with ${reason.provs.length} provs")
        tv.new_unification += ((ub, reason))
        println(s"U ${tv} += ${(ub, reason)}")
      })
    })

    TypeVariable.createdTypeVars.foreach(tv => {
      for {
        (tv1, ur1) <- tv.new_unification
        (tv2, ur2) <- tv.new_unification
        if tv1 != tv2
      } {
        unifyTypes(tv1, tv2, ur1 :: ur2 :: Nil, MutSet())
      }
    })

    errorCache.values
      .toSortedSet(Ordering.by(u => u.a.toString ++ u.b.toString))
        .foreach(reportUnificationError)
    errorCache.clear()
    cache.clear()
  }

  // reason already has reason for a and b to be unified
  // this unification unifies types and create errors if they fail
  def unifyTypes(a: ST, b: ST, reason: Ls[UnificationReason], cache: MutSet[(ST, ST)])
                (implicit ctx: Ctx, raise: Raise): Unit =
    trace(s"U ${a} = ${b} because ${reason.mkString(", ")}") {
      val st1 = a.unwrapProvs
      val st2 = b.unwrapProvs

      def createUnification(desc: Str = ""): Unification = Unification(a, b, reason, desc)

      // check if unification reason as through flow
      // however allow through flow of length 2 because
      // it can be a collision error
      if (reason.length > 2 && createUnification().throughFlow) return

      // unification doesn't have an ordering
      if (cache((st1, st2)) || cache(st2, st1)) {
        println(s"U Cached ${st1} = ${st2}")
        return
      }

      cache += ((a, b))
      cache += ((b, a))

      (st1, st2) match {
        case (tr1: TypeRef, tr2: TypeRef)
          if tr1.defn === tr2.defn &&
            tr1.targs.length === tr2.targs.length &&
            tr1.targs.zip(tr2.targs).forall {
              case (arg1: TypeVariable, arg2) => true
              case (arg1, arg2: TypeVariable) => true
              case (arg1, arg2) => arg1 === arg2
            }
        => ()
        case (tup1: TupleType, tup2: TupleType)
          if tup1.fields.length === tup2.fields.length &&
            tup1.fields.zip(tup2.fields).forall {
              case (N -> FieldType(N, fld1: TypeVariable), _) => true
              case (_, N -> FieldType(N, fld2: TypeVariable)) => true
              case (fld1, fld2) => fld1 === fld2
            }
        => ()
        // cannot check functional equality
        case (FunctionType(arg1, res1), FunctionType(arg2, res2)) => ()
        case (tv1: TypeVariable, tv2: TypeVariable) if tv1 === tv2 =>
          () // TODO report error for recursive type
        case (tv: TypeVariable, st) =>
          if (tv.new_unification.nonEmpty) println(s"U   ${st} with")
          tv.new_unification.foreach {
            case ((prev, prevReason)) =>
              println(s"    ${tv} = ${prev} for ${prevReason}")
              unifyTypes(prev, st, prevReason :: reason, cache)
          }
        case (st, tv: TypeVariable) =>
          if (tv.new_unification.nonEmpty) println(s"U   ${st} with")
          tv.new_unification.foreach {
            case ((prev, prevReason)) =>
              println(s"    ${tv} = ${prev} for ${prevReason}")
              unifyTypes(prev, st, prevReason :: reason.reverse, cache)
          }
        case (_, _) =>
          // report error
          registerUnificationError(createUnification())
      }
    }()

  def showUnificationDebugInfo(): Unit = {
    TypeVariable.createdTypeVars.foreach(tv => {
      println(s"unified ${tv} with:")
      tv.new_unification.foreach { case (st, reason) => println(s"  ${st}: ${reason}") }
    })
  }

  def reportUnificationDebugInfo()(implicit ctx: Ctx, raise: Raise): Unit = {
    TypeVariable.createdTypeVars.foreach(tv => {
      tv.new_unification.foreach { case (st, reason) =>
        val head = msg"${tv.expPos} is unified with ${st.expPos} because ${reason.toString})" -> N
        val locs = reason.getProvs.map {
          case nested: NestedTypeProvenance => msg"<nested> ${nested.nestingInfo.toString} len: ${nested.chain.length.toString}" -> N
          case tp => msg"${tp.desc}" -> tp.loco
        }
        raise(WarningReport(head :: locs))
      }
    })
  }

  def toSequenceString(u: Unification)(implicit ctx: Ctx, showTV: Set[TV]): Message = u.unificationChain match {
    case Nil => msg""
    case head :: tail => val first = head match {
      case (LB(st, tv, _), true) => msg"(${st.expOcamlTy()}) ---> (${tv.expOcamlTy()}) "
      case (LB(st, tv, _), false) => msg"(${tv.expOcamlTy()}) <--- (${st.expOcamlTy()}) "
      case (UB(tv, st, _), false) => msg"(${st.expOcamlTy()}) <--- (${tv.expOcamlTy()}) "
      case (UB(tv, st, _), true) => msg"(${tv.expOcamlTy()}) ---> (${st.expOcamlTy()}) "
    }

      tail.foldLeft(first) {
        case (prev, (LB(st, tv, _), true)) => prev + msg"---> (${tv.expOcamlTy()}) "
        case (prev, (LB(st, tv, _), false)) => prev + msg"<--- (${st.expOcamlTy()}) "
        case (prev, (UB(tv, st, _), false)) => prev + msg"<--- (${tv.expOcamlTy()}) "
        case (prev, (UB(tv, st, _), true)) => prev + msg"---> (${st.expOcamlTy()}) "
      }
  }

  def toSequenceTypes(u: Unification): Ls[ST] = u.unificationChain match {
    case Nil => Nil
    case head :: tail => val first = head match {
      case (LB(st, tv, _), true) => st :: tv :: Nil
      case (LB(st, tv, _), false) => tv :: st :: Nil
      case (UB(tv, st, _), false) => st :: tv :: Nil
      case (UB(tv, st, _), true) => tv :: st :: Nil
    }

      tail.foldLeft(first) {
        case (prev, (LB(st, tv, _), true)) => prev ::: tv :: Nil
        case (prev, (LB(st, tv, _), false)) => prev ::: st :: Nil
        case (prev, (UB(tv, st, _), false)) => prev ::: tv :: Nil
        case (prev, (UB(tv, st, _), true)) => prev ::: st :: Nil
      }
  }

  def collisionErrorMessage(u: Unification)(implicit ctx: Ctx): Ls[Message -> Opt[Loc]] = {
    implicit val showTV: Set[TV] = Set()

    val firstthismsg = (st: ST, prov: TP) => prov match {
      case TypeProvenance(loco, desc, _, false) => msg"`${st.expOcamlTy()}` comes from" -> loco
      case TypeProvenance(loco, _, _, true) => msg"`${st.expOcamlTy()}` comes from" -> loco
    }
    val firstsomsg = (st: ST, prov: TP) => prov match {
      case TypeProvenance(loco, desc, _, false) => msg"" -> loco
      case TypeProvenance(loco, _, _, true) => msg"" -> loco
    }
    val sndbutmsg = (st: ST, prov: TP) => prov match {
      case TypeProvenance(loco, desc, _, false) => msg"" -> loco
      case TypeProvenance(loco, _, _, true) => msg"" -> loco
    }
    val sndbecausemsg = (st: ST, prov: TP) => prov match {
      case TypeProvenance(loco, desc, _, false) => msg"" -> loco
      case TypeProvenance(loco, _, _, true) => msg"" -> loco
    }
    val commonmsg = (a: ST, b: ST, prov: TP, firstLoc: Bool) => {
      val prefix = if (firstLoc) "" else "so "
      prov match {
        case TypeProvenance(loco, desc, _, false) => msg"`${a.expOcamlTy()}` comes from" -> loco
        case TypeProvenance(loco, _, _, true) => msg"`${a.expOcamlTy()}` comes from" -> loco
      }
    }

    def makeMessageFirstType(st: ST, provs: Ls[TP]) = firstthismsg(st, provs.head) :: provs.tail.map(firstsomsg(st, _))
    def makeMessageSecondType(st: ST, provs: Ls[TP]) = provs.map(sndbecausemsg(st, _))

    // TODO respect contravariant type flow
    val (lprov, rprov) = (u.a.uniqueTypeUseLocations, u.b.uniqueTypeUseLocations)

    // take elements from second list only including the last common element
    // a: 3, 4, 2, 1
    // b: 3, 4, 5, 6
    // result: 4, 5, 6
    val common = lprov.toSet.intersect(rprov.toSet)

    // for a: 3, 4, 2, 1
    // show 2, 1
    val fstmsg = lprov.span(common) match {
      case (Nil, provs) => makeMessageFirstType(u.a, provs.reverse)
      case (_ :+ last, Nil) => commonmsg(u.a, u.b, last, true) :: Nil
      case (_ :+ last, provs) => makeMessageFirstType(u.a, provs.reverse) ::: commonmsg(u.a, u.b, last, false) :: Nil
    }

    val sndmsg = rprov.span(common) match {
      case (Nil, provs) => msg"TODO No common prov" -> N :: makeMessageSecondType(u.b, provs)
      case (_, provs) => makeMessageSecondType(u.b, provs)
    }

    fstmsg ::: sndmsg
  }

  def reportUnificationError(u: Unification)(implicit raise: Raise, ctx: Ctx): Unit = {
    println(s"UERR REPORT ${u.toString}")
    implicit val showTV: Set[TV] = u.unificationSequenceTVars
    val msgdoesnotmatch = (a: ST, b: ST) => msg"Type `${a.expOcamlTy()(ctx, Set())}` does not match `${b.expOcamlTy()(ctx, Set())}`"
    u.unificationChain match {
      case Nil => ()
      case _ :: Nil =>
        raise(UnificationReport(msgdoesnotmatch(u.a, u.b) -> N :: collisionErrorMessage(u), false))
      case chain@(head :: next :: _) =>
        val messages = createErrorMessage(head, next, true) ::: chain.sliding(2).collect {
          case Seq(fst, snd) => createErrorMessage(fst, snd)
        }.toList.flatten

        raise(UnificationReport(
          msgdoesnotmatch(u.a, u.b) -> N ::
            msg"    " + toSequenceString(u) -> N :: messages
          , true))
    }
  }

  def registerUnificationError(u: Unification): Unit = {
    val (a, b, level, length) = (u.a, u.b, u.unificationLevel, u.reason.length)

    errorCache.get((a, b)).fold {
      println(s"UERR CACHE [$level] [$length] ${u.toString}")
      errorCache += (((a, b), u))
      errorCache += (((b, a), u))
      ()
    } {
      case cachedU if level < cachedU.unificationLevel =>
        errorCache += (((a, b), u))
        errorCache += (((b, a), u))
        println(s"UERR UPDATE [$level] ${u.toString}")
      case cachedU if level == cachedU.unificationLevel && length < cachedU.reason.length =>
        errorCache += (((a, b), u))
        errorCache += (((b, a), u))
        println(s"UERR UPDATE [$level] [$length] ${u.toString}")
      case _ =>
        println(s"UERR IGNORE ${u.toString}")
    }
  }

  def createErrorMessage(firstUR: UnificationReason -> Bool, secondUR: UnificationReason -> Bool, showFirst: Bool = false)
                        (implicit ctx: Ctx, showTV: Set[TV]): Ls[Message -> Opt[Loc]] = {
    val diagistypeof = (st: ST, tp: TP, marker: Bool) => if (marker) {
      st match {
        case tv: TV => msg"(${tv.expOcamlTy()}) is assumed for" -> tp.loco
        case _ => msg"(${st.expOcamlTy()}) comes from" -> tp.loco
      }
      } else {
        msg"" -> tp.loco
      }
    val diagishere = (st: ST, tp: TP) => msg"(${st.expOcamlTy()}) comes from" -> tp.loco
    val msgistypeof = (st: ST, tp: TP, marker: Bool) => if (tp.isType) {
      msg"(${st.expOcamlTy()}) comes from"
    } else {
      if (marker) {
        st match {
          case tv: TV => msg"(${tv.expOcamlTy()}) is assumed for"
          case _ => msg"(${st.expOcamlTy()}) comes from"
        }
      } else {
        msg""
      }
    }
    val msgflowintoit = (a: ST, b: ST) => msg". However `${a.expOcamlTy()}` flows into `${b.expOcamlTy()}`"
    val msgitflowinto = (st: ST) => msg" and it flows into `${st.expOcamlTy()}`"

    // take elements from first list upto and include first common element
    // a: 1, 2, 3, 4
    // b: 5, 6, 3, 4
    // result: 1, 2, 3
    def takeUpToFirstCommon(aprovs: Ls[TP], bprovs: Ls[TP]): Ls[TP] = {
      val common = aprovs.toSet.intersect(bprovs.toSet)
      aprovs.span(!common.contains(_)) match {
        // show common location only if it's the first unification
        case ((head, firstCommon :: _)) => head ::: (if (showFirst) firstCommon :: Nil else Nil)
        case ((head, Nil)) => head
      }
    }

    def makeMessagesST(st: ST, ls: Ls[TP]): Ls[Message -> Opt[Loc]] =
      ls.zipWithIndex.map {
        case (tp@TypeProvenance(_, _, _, false), i) => diagistypeof(st, tp, showFirst && i == ls.length - 1)
        case (tp@TypeProvenance(_, _, _, true), i) => diagishere(st, tp)
      }

    // showFirst indicates if the merged location belongs to the type variable or the st
    // when showing first we show location of type variable
    // otherwise the location of type variable is skipped as it must have been shown in previous
    // unification reason message. So the directly the location of st is shown
    def makeMessagesUR(ur: UnificationReason -> Bool, provs: Ls[TP]): Ls[Message -> Opt[Loc]] = {
      // first ur should include the last location which is the common location between the two urs
      // so the last message should include the type b as the main type

      // true direction flow (showFirst = true)
      // lb: st 0 -> st 1 -> st into tv 2 -> tv 3
      // ub: tv 0 -> tv 1 -> tv into st 2 -> st 3
      // true direction flow (showFirst = false)
      // lb: st 0 -> st 1 -> st into tv 2 -> tv 3
      // ub: tv 0 -> tv 1 -> tv into st 2 -> st 3
      if (ur._2) {
        val a = ur._1.a.unwrapProvs
        val b = ur._1.b.unwrapProvs
        provs.reverse match {
          case last :: Nil => msgistypeof(a, last, true) + msgitflowinto(b) -> last.loco :: Nil
          case last :: sndLast :: Nil => diagistypeof(b, last, true) :: msgistypeof(a, sndLast, showFirst) -> sndLast.loco :: Nil
          case last :: sndLast :: tail => diagistypeof(b, last, true) :: msgistypeof(a, sndLast, false) -> sndLast.loco :: makeMessagesST(a, tail)
          case Nil => msg"TODO: Exception empty list for ${ur.toString()}" -> N :: Nil
        }
      }.reverse
      // false direction flow (showFirst = true)
      // lb: st 1 -> tv from st 2 -> tv 3 -> tv 4 (rev)
      // ub: tv 1 -> st from tv 2 -> st 3 -> st 4 (rev)
      // false direction flow (showFirst = false)
      // lb: st 1 -> tv however into st 2 -> tv 3 (rev)
      // ub: tv 1 -> st however into tv 2 -> st 3 (rev)
      else {
        val a = ur._1.a.unwrapProvs
        val b = ur._1.b.unwrapProvs
        provs match {
          case fst :: Nil => msgistypeof(a, fst, true) -> fst.loco :: Nil
          case fst :: snd :: Nil => diagistypeof(a, fst, true) :: msgistypeof(b, snd, showFirst) -> snd.loco :: Nil
          case fst :: snd :: tail => diagistypeof(a, fst, true) :: msgistypeof(b, snd, false) -> snd.loco :: makeMessagesST(b, tail)
          case Nil => msg"Exception empty list for ${ur.toString()}" -> N :: Nil
        }
      }.reverse
    }

    // if a is same that means common elements are on left side
    // other wise b is same and common elements are on right side
    val leftSame = firstUR._1.a == secondUR._1.a
    println(s"${firstUR} -> ${secondUR} showFirst: ${showFirst} leftSame: ${leftSame}")

    val aprovs = firstUR._1.getCleanProvs
    val bprovs = secondUR._1.getCleanProvs

    // first should show all locations
    if (showFirst) {
      val provs = if (leftSame) {
        takeUpToFirstCommon(aprovs.reverse, bprovs.reverse).reverse
      } else {
        takeUpToFirstCommon(aprovs, bprovs)
      }
      println(s"show ${provs.length} locations for ${firstUR}")
      makeMessagesUR(firstUR, provs)
    }
    // second should check previous to see if terminal location is common and not show it again
    else {
      val provs = if (leftSame) {
        takeUpToFirstCommon(bprovs.reverse, aprovs.reverse).reverse
      } else {
        takeUpToFirstCommon(bprovs, aprovs)
      }
      println(s"show ${provs.length} locations for ${secondUR}")
      makeMessagesUR(secondUR, provs)
    }
  }
}
