require 'resque'

class StoreReqJob < ActiveJob::Base
  @queue = :low

  def self.perform(jobs)
    jobs.each do |job|
      p job
    end
  end
end