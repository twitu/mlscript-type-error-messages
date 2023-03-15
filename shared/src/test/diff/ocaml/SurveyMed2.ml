let remainder x y = if (x * y) > 10 then (x * y) mod 10 else 0
  
let tostring l = List.map string_of_int
  
let y = [1, 2, 3]
  
let rec mulByDigit i l =
  match List.rev l with
  | [] -> []
  | h::t -> [remainder tostring y] @ (mulByDigit i t)
//│ [ERROR] Type `_ list` does not match `int`
//│    
//│ `_ list` comes from
//│    l.5:  let y = [1, 2, 3]
//│                  ^^^^^^^^^
//│ so this reference has type `_ list`
//│    l.10:    | h::t -> [remainder tostring y] @ (mulByDigit i t)
//│                                           ^
//│ so this variable has type `_ list`. However it flows into `int`
//│    l.1:  let remainder x y = if (x * y) > 10 then (x * y) mod 10 else 0
//│                          ^
//│ because this reference has type `int`
//│    l.1:  let remainder x y = if (x * y) > 10 then (x * y) mod 10 else 0
//│                                                        ^
//│ because `int` comes from this type expression
//│    builtin:  let ( * ): int -> int -> int
//│                             ^^^
//│ [ERROR] Type `int` does not match `_ -> _ list -> _ list`
//│    
//│ `int` comes from
//│    builtin:  let ( * ): int -> int -> int
//│                         ^^^
//│ so this reference has type `int`
//│    l.1:  let remainder x y = if (x * y) > 10 then (x * y) mod 10 else 0
//│                                                    ^
//│ so this variable has type `int`. However it flows into `_ -> _ list -> _ list`
//│    l.1:  let remainder x y = if (x * y) > 10 then (x * y) mod 10 else 0
//│                        ^
//│ because this reference has type `_ -> _ list -> _ list`
//│    l.10:    | h::t -> [remainder tostring y] @ (mulByDigit i t)
//│                                  ^^^^^^^^
//│ because this function has type `_ -> _ list -> _ list`
//│    l.3:  let tostring l = List.map string_of_int
//│                    ^^^^^^^^^^^^^^^^^^^^^^^^^^
