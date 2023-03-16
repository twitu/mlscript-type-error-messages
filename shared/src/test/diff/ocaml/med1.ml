let wrap x = x :: []
let test z cond = if cond then wrap z else wrap true
let rec check cond = test (if cond then 1 else check (not cond)) cond
//│ wrap: 'a -> list['a]
//│ test: 'a -> bool -> list[bool | 'a]
//│ check: bool -> 'a
//│   where
//│     'a :> list[int | 'a | bool]

