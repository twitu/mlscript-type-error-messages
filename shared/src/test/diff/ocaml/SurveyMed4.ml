let rec assoc (d,k,l) =
  match l with
  | [] -> d
  | h::t -> let (f,s) = h in if k = f then s h else assoc d k t
//│ [ERROR] Type `_ -> _` does not match `_ * _ * _`
//│    
//│         (_ -> _) <--- (?a) ---> (?a * _ * _) 
//│    
//│ (_ -> _) comes from
//│    l.4:    | h::t -> let (f,s) = h in if k = f then s h else assoc d k t
//│                                                              ^^^^^^^
//│ 
//│    l.2:    match l with
//│            ^^^^^^^^^^^^
//│            | [] -> d ...
//│            ^^^^^^^^^^^^^
//│ 
//│    l.3:    | [] -> d
//│                    ^
//│ (?a) is assumed for
//│    l.1:  let rec assoc (d,k,l) =
//│                         ^
//│ 
//│    l.4:    | h::t -> let (f,s) = h in if k = f then s h else assoc d k t
//│                                                                    ^
//│ (?a * _ * _) comes from
//│    l.1:  let rec assoc (d,k,l) =
//│                     ^^^^^^^
