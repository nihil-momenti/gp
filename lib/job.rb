require 'socket'

require_relative 'environment'
require_relative 'part'

class Job
  @queue = "jobs"

  def initialize job_id
    @job_id = job_id
    @pop = $environment.build
  end

  def log msg
    File.open("gp.#{@job_id}.log", 'a') do |file|
      file.write <<-END
        ==== [#{Socket.gethostname}]
             [#{Process.pid.to_s.rjust(5)}] [#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}]
             #{msg}

      END
    end
  end

  def perform
    @pop = @pop.succ
    log <<-END
           Average score: #{@pop.average_score}
           Highest score: #{@pop.lowest_score[1]}
           Best algorithm: #{@pop.lowest_score[0]}
    END
    self
  end

  def save
    $redis.set "jobs:#{@job_id}", Marshal::dump(self)
  end

  def self.[] job_id
    Marshal.load $redis.get("jobs:#{job_id}")
  end

  def self.perform job_id
    Job[job_id].perform.save
    Resque.enqueue Job, job_id
  end
end
