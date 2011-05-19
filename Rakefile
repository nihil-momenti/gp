require 'bundler/setup'
require 'resque/tasks'

$: << File.join(File.dirname(__FILE__), 'lib')

task 'resque:setup' do
  require 'environment'
end

namespace :gp do
  task :start do
    require 'environment'
    job_id = $redis.incr "jobs:counter"
    $environment.build.pop.each do |algo|
      $redis.rpush "jobs:#{job_id}:old_pop", Marshal.dump(algo)
    end
    [Resque.workers.size, 1].max.times do
      Resque.enqueue Part, job_id
    end
    Resque.enqueue Job, job_id
  end

  namespace :workers do
    task :setup do
      ENV['COUNT'] = `grep -c "processor" /proc/cpuinfo`.strip
      ENV['QUEUE'] = 'parts,jobs'
    end

    task :start => :setup do
      puts "Spawning #{ENV['COUNT']} forks"
      Rake::Task['resque:workers'].invoke
    end
  end
end

task :default => 'gp:start'
