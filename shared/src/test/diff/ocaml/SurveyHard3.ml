let rec clone x n = if n <= 0 then [] else x :: (clone x (n - 1))
   
let padZero l1 l2 =
  let numZeros = (List.length l1) - (List.length l2) in
  let absNumZeros = abs numZeros in
  if numZeros = 0
  then (l1, l2)
  else
    (let listZeros = clone 0 absNumZeros in
     if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
  
let rec removeZero l =
  match l with | [] -> [] | 0::t -> removeZero t | h::t -> l
  
let bigAdd l1 l2 =
  let add (l1,l2) =
    let f a x =
      let (carry,currentSum) = a in
      if x = []
      then (0, (carry :: currentSum))
      else
        (let (toSum1,toSum2) = x in
         let intermediateValue = (toSum1 + toSum2) + carry in
         let valueToAddToArray = intermediateValue mod 10 in
         let carry = intermediateValue / 10 in
         (carry, (valueToAddToArray :: currentSum))) in
    let base = (0, []) in
    let args = List.rev (List.combine l1 l2) in
    let (_,res) = List.fold_left f base args in res in
  removeZero (add (padZero l1 l2))
 
(* (@): 'a list -> 'a list -> 'a list is a list concatenation operator *)
(* List.length: 'a list -> int *)
(* List.fold_left: ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a *)
(* List.combine: 'a list -> 'b list -> ('a * 'b) list zips two lists together *)
(* List.rev: 'a list -> 'a list reverses a list *)
//│ [ERROR] Type `_ * _ list` does not match `_ list * _`
//│    
//│         (_ * _ list) ---> (?a) <--- (_ list * _) 
//│    
//│ (_ * _ list) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                     ^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ list * _) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                                              ^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ * _` does not match `_ list * _`
//│    
//│         (_ * _) ---> (?a) <--- (_ list * _) 
//│    
//│ (_ * _) comes from
//│    l.7:    then (l1, l2)
//│                 ^^^^^^^^
//│ (?a) is assumed for
//│    l.6:    if numZeros = 0
//│            ^^^^^^^^^^^^^^^
//│            then (l1, l2) ...
//│            ^^^^^^^^^^^^^^^^^
//│ 
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ list * _) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                                              ^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ * _ list` does not match `_ list * _`
//│    
//│         (_ * _ list) ---> (?a) <--- (_ list * _) 
//│    
//│ (_ * _ list) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                     ^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ list * _) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                                              ^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `int * _ list` does not match `int * _ list`
//│    
//│         (int * _ list) ---> (?a) <--- (int * _ list) 
//│    
//│ (int * _ list) comes from
//│    l.27:      let base = (0, []) in
//│                          ^^^^^^^
//│ (?a) is assumed for
//│    l.29:      let (_,res) = List.fold_left f base args in res in
//│                                              ^^^^
//│ 
//│    l.18:        let (carry,currentSum) = a in
//│                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│                if x = [] ...
//│                ^^^^^^^^^^^^^
//│ 
//│    l.19:        if x = []
//│                 ^^^^^^^^^
//│                then (0, (carry :: currentSum)) ...
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (int * _ list) comes from
//│    l.20:        then (0, (carry :: currentSum))
//│                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ list * _` does not match `_ * _`
//│    
//│         (_ list * _) ---> (?a) <--- (_ * _) 
//│    
//│ (_ list * _) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                                                 ^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.6:    if numZeros = 0
//│            ^^^^^^^^^^^^^^^
//│            then (l1, l2) ...
//│            ^^^^^^^^^^^^^^^^^
//│ (_ * _) comes from
//│    l.7:    then (l1, l2)
//│              ^^^^^^^^
//│ [ERROR] Type `_ * _ list` does not match `_ * _`
//│    
//│         (_ * _ list) ---> (?a) <--- (_ * _) 
//│    
//│ (_ * _ list) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                     ^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.6:    if numZeros = 0
//│            ^^^^^^^^^^^^^^^
//│            then (l1, l2) ...
//│            ^^^^^^^^^^^^^^^^^
//│ (_ * _) comes from
//│    l.7:    then (l1, l2)
//│              ^^^^^^^^
//│ [ERROR] Type `_ * _ list` does not match `_ * _`
//│    
//│         (_ * _ list) ---> (?a) <--- (_ * _) 
//│    
//│ (_ * _ list) comes from
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                                     ^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.10:       if numZeros > 0 then (l1, (listZeros @ l2)) else ((listZeros @ l1), l2))
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.6:    if numZeros = 0
//│            ^^^^^^^^^^^^^^^
//│            then (l1, l2) ...
//│            ^^^^^^^^^^^^^^^^^
//│ (_ * _) comes from
//│    l.7:    then (l1, l2)
//│              ^^^^^^^^
//│ [ERROR] Type `int * _ list` does not match `int * _ list`
//│    
//│         (int * _ list) ---> (?a) <--- (int * _ list) 
//│    
//│ (int * _ list) comes from
//│    l.26:           (carry, (valueToAddToArray :: currentSum))) in
//│                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.22:          (let (toSum1,toSum2) = x in
//│                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│                   let intermediateValue = (toSum1 + toSum2) + carry in ...
//│                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.19:        if x = []
//│                 ^^^^^^^^^
//│                then (0, (carry :: currentSum)) ...
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.18:        let (carry,currentSum) = a in
//│                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│                if x = [] ...
//│                ^^^^^^^^^^^^^
//│ 
//│    l.29:      let (_,res) = List.fold_left f base args in res in
//│                                              ^^^^
//│ (int * _ list) comes from
//│    l.27:      let base = (0, []) in
//│                       ^^^^^^^
//│ [ERROR] Type `int * _ list` does not match `int * _ list`
//│    
//│         (int * _ list) ---> (?a) <--- (int * _ list) 
//│    
//│ (int * _ list) comes from
//│    l.26:           (carry, (valueToAddToArray :: currentSum))) in
//│                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.22:          (let (toSum1,toSum2) = x in
//│                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│                   let intermediateValue = (toSum1 + toSum2) + carry in ...
//│                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.19:        if x = []
//│                 ^^^^^^^^^
//│                then (0, (carry :: currentSum)) ...
//│                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (int * _ list) comes from
//│    l.20:        then (0, (carry :: currentSum))
//│                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ list` does not match `_ * _`
//│    
//│         (_ list) ---> (?a) <--- (?b) ---> (_ * _) 
//│    
//│ (_ list) comes from and it flows into `?a`
//│    l.19:        if x = []
//│                        ^^
//│ 
//│    l.19:        if x = []
//│                    ^
//│ (?b) is assumed for
//│    l.17:      let f a x =
//│                       ^
//│ 
//│    l.22:          (let (toSum1,toSum2) = x in
//│                                          ^
//│ (_ * _) comes from
//│    l.22:          (let (toSum1,toSum2) = x in
//│                     ^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ list` does not match `_ * _`
//│    
//│         (_ list) ---> (?a) <--- (_ * _) 
//│    
//│ (_ list) comes from and it flows into `?a`
//│    l.19:        if x = []
//│                        ^^
//│ 
//│    l.19:        if x = []
//│                    ^
//│ 
//│    l.17:      let f a x =
//│                       ^
//│ (_ * _) comes from
//│    builtin:  let List.combine: 'a list -> 'b list -> ('a * 'b) list
//│                                                    ^^^^^^^
