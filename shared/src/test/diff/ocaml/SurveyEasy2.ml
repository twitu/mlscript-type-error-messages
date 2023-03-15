let destructEither x = match x with
 | Left l -> l + 1
 | Right r -> r && true
//│ [ERROR] Type `bool` does not match `int`
//│    
//│         (bool) ---> (?a) <--- (int) 
//│    
//│ (bool) comes from
//│    builtin:  let (&&): bool -> bool -> bool
//│                                        ^^^^
//│ 
//│    l.3:   | Right r -> r && true
//│                        ^^^^^^^^^^
//│ (?a) is assumed for
//│    l.1:  let destructEither x = match x with
//│                                 ^^^^^^^^^^^^
//│           | Left l -> l + 1 ...
//│           ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:   | Left l -> l + 1
//│                       ^^^^^
//│ (int) comes from
//│    builtin:  let (+): int -> int -> int
//│                                  ^^^
