let rec clone x n = if n <= 0 then [] else x :: (clone x (n - 1))
  
let addTuple (l1,l2) = l1 + l2
  
let rec removeZero l =
  match l with | [] -> [] | h::t -> if h = 0 then removeZero t else h :: t
  
let padZero l1 l2 =
  if (List.length l1) > (List.length l2)
  then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2))
  else
    if (List.length l1) < (List.length l2)
    then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2)
    else (l1, l2)
  
let bigAdd l1 l2 =
  let add (l1,l2) =
    let f a x = (a + x) mod 10 in
    let base = 0 in
    let args = List.map addTuple (List.combine l1 l2) in
    let (_,res) = List.fold_left f base args in res in
  removeZero (add (padZero l1 l2))
//│ [ERROR] Type `_ * _` does not match `_ list * _`
//│    
//│         (_ * _) ---> (?a) <--- (_ list * _) 
//│    
//│ (_ * _) comes from
//│    l.14:      else (l1, l2)
//│                    ^^^^^^^^
//│ (?a) is assumed for
//│    l.12:      if (List.length l1) < (List.length l2)
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│              then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2) ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ list * _) comes from
//│    l.13:      then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2)
//│                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ * _` does not match `_ list * _`
//│    
//│         (_ * _) ---> (?a) <--- (_ list * _) 
//│    
//│ (_ * _) comes from
//│    l.14:      else (l1, l2)
//│                    ^^^^^^^^
//│ (?a) is assumed for
//│    l.12:      if (List.length l1) < (List.length l2)
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│              then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2) ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ list * _) comes from
//│    l.13:      then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2)
//│                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ list * _` does not match `_ * _ list`
//│    
//│         (_ list * _) ---> (?a) <--- (_ * _ list) 
//│    
//│ (_ list * _) comes from
//│    l.13:      then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2)
//│                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.12:      if (List.length l1) < (List.length l2)
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│              then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2) ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.9:    if (List.length l1) > (List.length l2)
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│            then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2)) ...
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ * _ list) comes from
//│    l.10:    then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2))
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ list * _` does not match `_ * _ list`
//│    
//│         (_ list * _) ---> (?a) <--- (_ * _ list) 
//│    
//│ (_ list * _) comes from
//│    l.13:      then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2)
//│                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.12:      if (List.length l1) < (List.length l2)
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│              then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2) ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.9:    if (List.length l1) > (List.length l2)
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│            then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2)) ...
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ * _ list) comes from
//│    l.10:    then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2))
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ * _` does not match `_ * _ list`
//│    
//│         (_ * _) ---> (?a) <--- (_ * _ list) 
//│    
//│ (_ * _) comes from
//│    l.14:      else (l1, l2)
//│                    ^^^^^^^^
//│ 
//│    l.12:      if (List.length l1) < (List.length l2)
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│              then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2) ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.9:    if (List.length l1) > (List.length l2)
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│            then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2)) ...
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ * _ list) comes from
//│    l.10:    then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2))
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ * _` does not match `_ * _ list`
//│    
//│         (_ * _) ---> (?a) <--- (_ * _ list) 
//│    
//│ (_ * _) comes from
//│    l.14:      else (l1, l2)
//│                    ^^^^^^^^
//│ 
//│    l.12:      if (List.length l1) < (List.length l2)
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│              then (((clone 0 ((List.length l2) - (List.length l1))) @ l1), l2) ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.9:    if (List.length l1) > (List.length l2)
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│            then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2)) ...
//│            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (_ * _ list) comes from
//│    l.10:    then (l1, ((clone 0 ((List.length l1) - (List.length l2))) @ l2))
//│               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ [ERROR] Type `_ * _` does not match `int`
//│    
//│         (_ * _) <--- (?a) ---> (int) 
//│    
//│ (_ * _) comes from
//│    l.21:      let (_,res) = List.fold_left f base args in res in
//│                   ^^^^^^^
//│ (?a) is assumed for
//│    l.21:      let (_,res) = List.fold_left f base args in res in
//│                             ^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.18:      let f a x = (a + x) mod 10 in
//│                     ^
//│ 
//│    l.18:      let f a x = (a + x) mod 10 in
//│                            ^
//│ (int) comes from
//│    builtin:  let (+): int -> int -> int
//│                    ^^^
