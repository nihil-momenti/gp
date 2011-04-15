constants:
  Number:
    new => (rand)
  Boolean:
    new => (rand > 0.5)


variables:
  x: Number
  y: Number


functions: |
  PLUS: Number, Number -> Number
   => ({0} + {1})
  
  MINUS: Number, Number -> Number
   => ({0} - {1})
  
  TIMES: Number, Number -> Number
   => ({0} * {1})
  
  DIVIDE: Number, Number -> Number
   => (if {1} != 0 then ({0} / {1}) else 0 end)
  
  AND: Boolean, Boolean -> Boolean
   => ({0} and {1})
  
  OR: Boolean, Boolean -> Boolean
   => ({0} or {1})
  
  NOT: Boolean -> Boolean
   => (not {0})
  
  IF_NUM: Boolean, Number, Number -> Number
   => (if {0} then {1} else {2} end)
  
  IF_BOOL: Boolean, Boolean, Boolean -> Boolean
   => (if {0} then {1} else {2} end)
