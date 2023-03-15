let increment result = match result with
 | Left n -> n + 1
 | Right msg -> "ERROR: " ^ msg
 
(* (^): string -> string -> string is a string concatenation operator *)
//│ [ERROR] Type `string` does not match `int`
//│    
//│         (string) ---> (?a) <--- (int) 
//│    
//│ (string) comes from
//│    builtin:  let (^): string -> string -> string
//│                                           ^^^^^^
//│ 
//│    l.3:   | Right msg -> "ERROR: " ^ msg
//│                          ^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.1:  let increment result = match result with
//│                                 ^^^^^^^^^^^^^^^^^
//│           | Left n -> n + 1 ...
//│           ^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:   | Left n -> n + 1
//│                       ^^^^^
//│ (int) comes from
//│    builtin:  let (+): int -> int -> int
//│                                  ^^^

