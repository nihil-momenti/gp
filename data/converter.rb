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

cover_types = [
  :spruce,
  :lodgepole_pine,
  :ponderosa_pine,
  :willow,
  :aspen,
  :douglas_fir,
  :krummholz
]

data = File.open("covtype.data") do |file|
  file.each_line.map do |line|
    e,a,s,h,v,r,am,noon,pm,f,*re,c = *line.split(',')
    soil = soil_types[re.pop(40).map(&:to_i).index(1)]
    area = area_types[re.pop(4).map(&:to_i).index(1)]
    cover = cover_types[c.to_i-1]
    cover == nil ? p(c) : 0
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
      :area_type => area,
      :soil_type => soil,
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

training = []
validation = []
test = []

counts = Hash[cover_types.map { |type| [type, 0] }]

data.each do |datum|
  case counts[datum[:cover_type]]
  when 0...1620
    training << datum
  when 1620...2160
    validation << datum
  else
    test << datum
  end
  counts[datum[:cover_type]] += 1 rescue (puts datum; raise)
end

File.open("validation.set.rb", 'w') do |file|
  file.write <<-END
  module Assignment
    module Data
      Validation = Marshal.load(#{Marshal.dump(validation).inspect})
    end
  end
  END
end

File.open("training.set.rb", 'w') do |file|
  file.write <<-END
  module Assignment
    module Data
      Training = Marshal.load(#{Marshal.dump(training).inspect})
    end
  end
  END
end

File.open("test.set.rb", 'w') do |file|
  file.write <<-END
  module Assignment
    module Data
      Test = Marshal.load(#{Marshal.dump(test).inspect})
    end
  end
  END
end
