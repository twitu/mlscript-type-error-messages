let increment result = match result with
 | Left n -> n + 1
 | Right msg -> "ERROR: " ^ msg
 
(* (^): string -> string -> string is a string concatenation operator *)
//│ increment: either[int, string] -> (int | string)

