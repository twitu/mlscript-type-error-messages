let wrap x = x :: []
let test z = if true then wrap z else wrap true
let rec t = test (if true then 1 else t)
//│ [ERROR] Type `int` does not match `_ list`
//│    
//│         (int) ---> (?a) <--- (_ list) 
//│    
//│ (int) comes from
//│    l.3:  let rec t = test (if true then 1 else t)
//│                                         ^
//│ (?a) is assumed for
//│    l.3:  let rec t = test (if true then 1 else t)
//│                           ^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:  let rec t = test (if true then 1 else t)
//│                                                ^
//│ 
//│    l.3:  let rec t = test (if true then 1 else t)
//│                  ^
//│ 
//│    l.3:  let rec t = test (if true then 1 else t)
//│                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:  let test z = if true then wrap z else wrap true
//│                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:  let test z = if true then wrap z else wrap true
//│                                                ^^^^^^^^^
//│ (_ list) comes from
//│    l.1:  let wrap x = x :: []
//│                    ^^^^^^^
//│ [ERROR] Type `int` does not match `_ list`
//│    
//│         (int) ---> (?a) <--- (_ list) 
//│    
//│ (int) comes from
//│    l.3:  let rec t = test (if true then 1 else t)
//│                                         ^
//│ (?a) is assumed for
//│    l.3:  let rec t = test (if true then 1 else t)
//│                           ^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:  let rec t = test (if true then 1 else t)
//│                                                ^
//│ 
//│    l.3:  let rec t = test (if true then 1 else t)
//│                  ^
//│ 
//│    l.3:  let rec t = test (if true then 1 else t)
//│                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:  let test z = if true then wrap z else wrap true
//│                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:  let test z = if true then wrap z else wrap true
//│                                    ^^^^^^
//│ (_ list) comes from
//│    l.1:  let wrap x = x :: []
//│                    ^^^^^^^

