dir = File.join File.dirname(__FILE__), 'gp'

%w{
  function
  algorithm
}.map { |file| File.join dir, file }.each do |file|
  require file
end
