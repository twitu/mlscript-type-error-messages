let increment result condition =
 if condition then
   match result with
    | Left n -> n + 1
    | Right msg -> "ERROR: " ^ msg
 else result
 
(* (^): string -> string -> string is a string concatenation operator *)
//│ [ERROR] Type `(_, _) either` does not match `int`
//│    
//│         ((_, _) either) <--- (?a) ---> (?b) <--- (int) 
//│    
//│ ((_, _) either) comes from
//│    l.4:      | Left n -> n + 1
//│                ^^^^
//│ 
//│    l.3:     match result with
//│                   ^^^^^^
//│ (?a) is assumed for
//│    l.1:  let increment result condition =
//│                        ^^^^^^
//│ 
//│    l.6:   else result
//│                ^^^^^^
//│ (?b) is assumed for
//│    l.2:   if condition then
//│           ^^^^^^^^^^^^^^^^^
//│             match result with ...
//│             ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:     match result with
//│             ^^^^^^^^^^^^^^^^^
//│              | Left n -> n + 1 ...
//│              ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.4:      | Left n -> n + 1
//│                          ^^^^^
//│ (int) comes from
//│    builtin:  let (+): int -> int -> int
//│                                  ^^^
//│ [ERROR] Type `(_, _) either` does not match `string`
//│    
//│         ((_, _) either) <--- (?a) ---> (?b) <--- (string) 
//│    
//│ ((_, _) either) comes from
//│    l.4:      | Left n -> n + 1
//│                ^^^^
//│ 
//│    l.3:     match result with
//│                   ^^^^^^
//│ (?a) is assumed for
//│    l.1:  let increment result condition =
//│                        ^^^^^^
//│ 
//│    l.6:   else result
//│                ^^^^^^
//│ (?b) is assumed for
//│    l.2:   if condition then
//│           ^^^^^^^^^^^^^^^^^
//│             match result with ...
//│             ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:     match result with
//│             ^^^^^^^^^^^^^^^^^
//│              | Left n -> n + 1 ...
//│              ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.5:      | Right msg -> "ERROR: " ^ msg
//│                             ^^^^^^^^^^^^^^^
//│ (string) comes from
//│    builtin:  let (^): string -> string -> string
//│                                        ^^^^^^
//│ [ERROR] Type `string` does not match `int`
//│    
//│         (string) ---> (?a) <--- (int) 
//│    
//│ (string) comes from
//│    builtin:  let (^): string -> string -> string
//│                                           ^^^^^^
//│ 
//│    l.5:      | Right msg -> "ERROR: " ^ msg
//│                             ^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.3:     match result with
//│             ^^^^^^^^^^^^^^^^^
//│              | Left n -> n + 1 ...
//│              ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.4:      | Left n -> n + 1
//│                          ^^^^^
//│ (int) comes from
//│    builtin:  let (+): int -> int -> int
//│                                  ^^^
