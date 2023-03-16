let increment result condition =
 if condition then
   match result with
    | Left n -> n + 1
    | Right msg -> "ERROR: " ^ msg
 else result
 
(* (^): string -> string -> string is a string concatenation operator *)
//│ increment: (either[int, string] & 'a) -> bool -> (int | string | 'a)
