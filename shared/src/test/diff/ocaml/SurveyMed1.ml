let wrap x = x :: []
let test z cond = if cond then wrap z else wrap true
let rec check cond = test (if cond then 1 else check (not cond)) cond
//│ [ERROR] Type `_ list` does not match `int`
//│    
//│         (_ list) ---> (?a) <--- (int) 
//│    
//│ (_ list) comes from
//│    l.1:  let wrap x = x :: []
//│                       ^^^^^^^
//│ 
//│    l.2:  let test z cond = if cond then wrap z else wrap true
//│                                                     ^^^^^^^^^
//│ 
//│    l.2:  let test z cond = if cond then wrap z else wrap true
//│                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                                                         ^^^^^^^^^^^^^^^^
//│ (?a) is assumed for
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ (int) comes from
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                                               ^
//│ [ERROR] Type `int` does not match `_ list`
//│    
//│         (int) ---> (?a) <--- (_ list) 
//│    
//│ (int) comes from
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                                                  ^
//│ (?a) is assumed for
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                                                         ^^^^^^^^^^^^^^^^
//│ 
//│    l.3:  let rec check cond = test (if cond then 1 else check (not cond)) cond
//│                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:  let test z cond = if cond then wrap z else wrap true
//│                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//│ 
//│    l.2:  let test z cond = if cond then wrap z else wrap true
//│                                         ^^^^^^
//│ (_ list) comes from
//│    l.1:  let wrap x = x :: []
//│                    ^^^^^^^

