require_relative 'job'

class Part
  @queue = "parts"

  def self.perform job_id, start
    job = Job[job_id]
  end
end
