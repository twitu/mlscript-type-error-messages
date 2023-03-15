let boolToBit x = if x then "0" else 1
//│ [ERROR] Type `string` does not match `int`
//│    
//│         (string) ---> (?a) <--- (int) 
//│    
//│ (string) comes from
//│    l.1:  let boolToBit x = if x then "0" else 1
//│                                      ^^^
//│ (?a) is assumed for
//│    l.1:  let boolToBit x = if x then "0" else 1
//│                            ^^^^^^^^^^^^^^^^^^^^
//│ (int) comes from
//│    l.1:  let boolToBit x = if x then "0" else 1
//│                                            ^
