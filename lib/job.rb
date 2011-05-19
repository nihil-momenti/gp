require 'socket'

require_relative 'environment'
require_relative 'part'

class Job
  @queue = "jobs"

  def self.log job_id, msg
    File.open("gp.#{job_id}.log", 'a') do |file|
      file.write <<-END
        ==== [#{Socket.gethostname}]
             [#{Process.pid.to_s.rjust(5)}] [#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}]
             #{msg}
      END
    end
  end


  def self.perform job_id
    pop = []
    while pop.size < $environment.pop_size 
      key, algo = $redis.blpop "jobs:#{job_id}:new_pop", 0
      pop << Marshal.load(algo)
    end

    pop = GP::Population.new(pop)

    log job_id, <<-END
       Average score: #{pop.average_score}
       Highest score: #{pop.lowest_score.last}
       Best algorithm: #{pop.lowest_score.first}
    END

    pop.succ.pop.each do |algo|
      $redis.rpush "jobs:#{job_id}:old_pop", Marshal.dump(algo)
    end

    Resque.enqueue Job, job_id
    [Resque.workers.size, 1].max.times do
      Resque.enqueue Part, job_id
    end
  end
end
