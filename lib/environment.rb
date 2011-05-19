require 'redis'
require 'redis-namespace'
require 'resque'
require 'logger'

require_relative 'job'
require_relative 'part'
require_relative 'gp'
require_relative '../data/training.set.rb'

unless $log
  $log = Object.new
  class << $log
    def log job_id, msg
      File.open("gp.#{job_id}.log", 'a') do |file|
        file.write <<-END
==== [#{Socket.gethostname}]
     [#{Process.pid.to_s.rjust(5)}] [#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}]
#{msg}

        END
      end
    end
  end
end

unless $environment
  GP::Builder.load do
    parse_file 'data/definitions.gp'

    pop_size 1000
    min_depth 2
    max_depth 16
    step_size 2
    return_type :CoverType

    fitness_function proc { |algo|
      begin
        Assignment::Data::Training.map do |example|
          algo.call(example) == example[:cover_type] ? 0 : 1
        end.reduce(&:+) + 0.1 * algo.root.avg_height
      rescue
        $log.log job_id, "Error: #{$!}"
        100000
      end
    }
  end
end
  

unless $redis
  redis = Redis.new(:host => 'linux.cosc.canterbury.ac.nz', :port => 6379)
  $redis = Redis::Namespace.new(:gp, :redis => redis)
  Resque.redis = redis
  Resque.redis.namespace = 'resque:gp'
end
