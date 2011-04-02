dir = File.join File.dirname(__FILE__), 'gp'

%w{
}.map { |file| File.join dir, file }.each do |file|
  require file
end
