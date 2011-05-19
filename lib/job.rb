require 'socket'

require_relative 'environment'
require_relative 'part'

class Job
  @queue = "jobs"


  def self.perform job_id
    pop = []
    pop_list = "jobs:#{job_id}:new_pop"
    backup_list = "jobs:#{job_id}:backup"

    $redis.del backup_list

    # Wait up to 30 seconds between algos being scored
    # If we miss one it will just be part of the next run
    # Also backup to a backup list, will need manual resuming
    # but at least we don't lose everything if a Job dies
    while (result = $redis.blpop pop_list, 30)
      $redis.rpush backup_list, result.last
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
