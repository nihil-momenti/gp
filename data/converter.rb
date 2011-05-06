require 'ap'
require 'yaml'

soil_types = [
  :cathedral_family,
  :vanet,
  :haploborolis,
  :ratake,
  :vanet,
  :vanet_wetmore,
  :gothic,
  :supervisor,
  :troutvilly,
  :bullwark_catamount_outcrop,
  :bullwark_catamount_land,
  :legault,
  :catamount,
  :pachic_argiborolis,
  :unspecified,
  :cryaquolis,
  :gateview,
  :rogert,
  :typic_cryaquolis,
  :typic_cryaquepts,
  :typic_cryaquolls,
  :leighcan_bouldery,
  :leighcan_typic,
  :leighcan_stony,
  :leighcan_warm_stony,
  :granile,
  :leighcan_warm,
  :leighcan,
  :como,
  :como_rock,
  :leighcan_catamount,
  :catamount,
  :leighcan_rock,
  :cryothents,
  :cryumbrepts,
  :bross,
  :rock,
  :leighcan_moran,
  :moran_cryothents_leighcan,
  :moran_cryothents_rock
]

area_types = [
  :rawah,
  :neota,
  :comanche,
  :cache
]

data = File.open('covtype.data') do |file|
  file.each_line.map do |line|
    e,a,s,h,v,r,am,noon,pm,f,*rest,cover = *line.split(',')
    soil = soil_types[rest.pop(40).map(&:to_i).index(1)]
    area = area_types[rest.pop(4).map(&:to_i).index(1)]
    cover = [:spruce, :lodgepole_pine, :ponderosa_pine, :willow, :aspen, :douglas_fir, :krummholz][cover.to_i+1]
    {
      :elevation => e.to_f,
      :aspect => a.to_f,
      :slope => s.to_f,
      :water_horiz_dist => h.to_f,
      :water_vert_dist => v.to_f,
      :road_horiz_dist => r.to_f,
      :hillshade_9am => am.to_f,
      :hillshade_noon => noon.to_f,
      :hillshade_3pm => pm.to_f,
      :fire_horiz_dist => f.to_f,
      :area_type => soil,
      :soil_type => area,
      :cover_type => cover
    }
  end
end

maxes = Hash.new(0)
data.each do |datum|
  datum.keys.first(10).each do |key|
    maxes[key] = [maxes[key], datum[key]].max
  end
end

data.each do |datum|
  datum.keys.first(10).each do |key|
    datum[key] = datum[key] / maxes[key]
  end
end

File.open('data.generated.yaml', 'w') do |file|
  file.write(data.to_yaml)
end
