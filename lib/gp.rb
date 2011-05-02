dir = File.join File.dirname(__FILE__), 'gp'
$:.unshift File.expand_path File.dirname(__FILE__)

%w{
  environment
  node
  constant
  variable
  function
  algorithm
  population
  builder
}.map { |file| File.join dir, file }.each do |file|
  require file
end
