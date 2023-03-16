let remainder x y = if (x * y) > 10 then (x * y) mod 10 else 0
  
let tostring l = List.map string_of_int
  
let y = [1, 2, 3]
  
let rec mulByDigit i l =
  match List.rev l with
  | [] -> []
  | h::t -> [remainder tostring y] @ (mulByDigit i t)
//│ remainder: int -> int -> int
//│ tostring: anything -> list[int] -> list[string]
//│ y: list[(int, int, int,)]
//│ mulByDigit: anything -> list[?] -> list[int]
