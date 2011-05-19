require 'socket'

require_relative 'environment'
require_relative 'part'

class Job
  @queue = "jobs"


  def self.perform job_id
    pop = []
    # Wait up to 30 seconds between algos being scored
    # If we miss one it will just be part of the next run
    while (result = $redis.blpop "jobs:#{job_id}:new_pop", 30)
      pop << Marshal.load(result.last)
    end

    pop = GP::Population.new(pop)

    $log.log job_id, <<-END
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
