---
constants:
  Number:
    (rand)
  Boolean:
    (rand > 0.5)
  SoilType:
    ([:cathedral_family, :vanet, :haploborolis, :ratake, :vanet, :vanet_wetmore, :gothic, :supervisor, :troutvilly, :bullwark_catamount_outcrop, :bullwark_catamount_land, :legault, :catamount, :pachic_argiborolis, :unspecified, :cryaquolis, :gateview, :rogert, :typic_cryaquolis, :typic_cryaquepts, :typic_cryaquolls, :leighcan_bouldery, :leighcan_typic, :leighcan_stony, :leighcan_warm_stony, :granile, :leighcan_warm, :leighcan, :como, :como_rock, :leighcan_catamount, :catamount, :leighcan_rock, :cryothents, :cryumbrepts, :bross, :rock, :leighcan_moran, :moran_cryothents_leighcan, :moran_cryothents_rock].choice)
  AreaType:
    ([:rawah, :neota, :comanche, :cache].choice)
  CoverType:
    ([:spruce, :lodgepole_pine, :ponderosa_pine, :willow, :aspen, :douglas_fir, :krummholz].choice)


variables:
  elevation: Number
  aspect: Number
  slope: Number
  water_horiz_dist: Number
  water_vert_dist: Number
  road_horiz_dist: Number
  hillshade_9am: Number
  hillshade_noon: Number
  hillshade_3pm: Number
  fire_horiz_dist: Number
  area_type: AreaType
  soil_type: SoilType
  cover_type: CoverType


functions: |
  PLUS: Number, Number -> Number
   => ({0} + {1})
  
  MINUS: Number, Number -> Number
   => ({0} - {1})
  
  TIMES: Number, Number -> Number
   => ({0} * {1})
  
  DIVIDE: Number, Number -> Number
   => (if {1} != 0 then ({0} / {1}) else 0 end)

  LESS_THAN: Number, Number -> Boolean
   => ({0} < {1})
  
  AND: Boolean, Boolean -> Boolean
   => ({0} and {1})
  
  OR: Boolean, Boolean -> Boolean
   => ({0} or {1})
  
  NOT: Boolean -> Boolean
   => (not {0})

  EQUAL: <X>, <X> -> <X>
   => ({0} == {1})
  
  IF_NUM: Boolean, <X>, <X> -> <X>
   => (if {0} then {1} else {2} end)
