require 'resque'
require 'nokogiri'
require 'open-uri'
require 'rake_text'

class StoreReqJob < ActiveJob::Base
  queue_as :default

  def perform(jobs)
    classifier = Classifier.load_classifier
    jobs.each do |job|
      description = scrape_description(job)
      tags = get_tags(description)
      category = classifier.classify description

      JobReq.new(
        title: job['jobtitle'],
        company: job['company'],
        date: job['date'],
        description: description,
        category: category,
        url: job['url'],
        tags: tags,
      ).save!
    end

    Classifier.train
  end

  def qualifications; end

  def scrape_description(job)
    url = job['url']
    doc = Nokogiri::HTML(open(url))
    doc.css('#job_summary').text
  end

  def get_tags(text)
    rake = RakeText.new
    rake.analyse text, RakeText.SMART, true
  end
end