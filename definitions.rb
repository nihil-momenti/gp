require './lib/gp'

module Assignment
  Functions = {
    :+       => { :type => :number, :args => [:number, :number],
                  :code => '"(#{args[0]}) + (#{args[1]})"' },
    :-       => { :type => :number, :args => [:number, :number],
                  :code => '"(#{args[0]}) - (#{args[1]})"' },
    :*       => { :type => :number, :args => [:number, :number],
                  :code => '"(#{args[0]}) * (#{args[1]})"' },
    :/       => { :type => :number, :args => [:number, :number],
                  :code => '"if (#{args[1]}) != 0 then (#{args[0]}) / (#{args[1]}) else 1 end"' },
    :and     => { :type => :boolean, :args => [:boolean, :boolean],
                  :code => '"(#{args[0]}) or (#{args[1]})"' },
    :or      => { :type => :boolean, :args => [:boolean, :boolean],
                  :code => '"(#{args[0]}) or (#{args[1]})"' },
    :not     => { :type => :boolean, :args => [:boolean],
                  :code => '"not (#{args[0]})"' },
    :if_num  => { :type => :number,  :args => [:boolean, :number, :number],
                  :code => '"if (#{args[0]}) then (#{args[1]}) else (#{args[2]}) end"' },
    :if_bool => { :type => :boolean, :args => [:boolean, :boolean, :boolean],
                  :code => '"if (#{args[0]}) then (#{args[1]}) else (#{args[2]}) end"' }
  }.map { |key, val| GP::Function.new key, val }

  Variables = {
    :x => :number,
    :y => :number
  }

  Constants = {
    :number  => proc { rand },
    :boolean => proc { rand > 0.5 }
  }
end
