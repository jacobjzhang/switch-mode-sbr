require 'resque'
require 'nokogiri'
require 'open-uri'

class StoreReqJob < ActiveJob::Base
  queue_as :default

  def perform(jobs)
    JobReq.new().save!
    jobs.each do |job|
      description = scrape_description(job)
      JobReq.new(
        title: job['jobtitle'],
        company: job['company'] 
        date: job['date'],
        description: description
      ).save!
    end
  end

  def scrape_description(job)
    url = job['url']
    doc = Nokogiri::HTML(open(url))
    doc.css('#job_summary').text
  end
end