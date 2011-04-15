dir = File.join File.dirname(__FILE__), 'gp'

%w{
  function
  algorithm
  population
}.map { |file| File.join dir, file }.each do |file|
  require file
end
