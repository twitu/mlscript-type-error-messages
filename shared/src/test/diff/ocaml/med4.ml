let rec assoc (d,k,l) =
  match l with
  | [] -> d
  | h::t -> let (f,s) = h in if k = f then s h else assoc d k t
//│ assoc: ('b, 'c, list[(anything, 'a -> ('d & 'e & 'f & 'g),) & 'a],) -> 'e
//│   where
//│     'b <: ('b, 'c, list[(anything, 'a -> ('d & 'e & 'f & 'g),) & 'a],) & 'd & 'e
//│     'd <: 'c -> list['a] -> 'h
//│     'h <: 'd & 'e & 'f & 'g
//│     'e :> 'b | 'f | 'g
//│        <: 'd
//│     'f :> 'g
//│        <: 'd & 'e
//│     'g :> 'h
//│        <: 'd & 'e & 'f
