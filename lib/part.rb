require_relative 'job'

class Part
  @queue = "parts"

  def self.perform job_id
    while algo=$redis.lpop("jobs:#{job_id}:old_pop")
      algo = Marshal.load algo
      algo.score
      $redis.rpush "jobs:#{job_id}:new_pop", Marshal.dump(algo)
    end
  end
end
