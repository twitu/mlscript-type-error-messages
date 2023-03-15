let destructEither x y = if y then
  match x with
    | Left l -> l && true
    | Right r -> r || false
  else x
//│ [ERROR] Type `(_, _) either` does not match `bool`
//│    
//│         ((_, _) either) <--- (?a) ---> (?b) <--- (bool) 
//│    
//│ ((_, _) either) comes from
//│    l.3:      | Left l -> l && true
//│                ^^^^
//│ 
//│    l.2:    match x with
//│                  ^
//│ (?a) is assumed for
//│    l.1:  let destructEither x y = if y then
//│                             ^
//│ 
//│    l.5:    else x
//│                 ^^
//│ (?b) is assumed for
//│    l.1:  let destructEither x y = if y then
//│                                   ^^^^^^^^^
//│            match x with ...
//│            ^^^^^^^^^^^^^^^^
//│ 
//│    l.2:    match x with
//│            ^^^^^^^^^^^^
//│              | Left l -> l && true ...
//│              ^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.4:      | Right r -> r || false
//│                           ^^^^^^^^^^
//│ (bool) comes from
//│    builtin:  let (||): bool -> bool -> bool
//│                                     ^^^^
