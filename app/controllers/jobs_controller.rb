require 'net/http'
require 'nokogiri'
require 'open-uri'

# JobsController is documented here.
class JobsController < ApplicationController
  def search
    title = params[:title]

    qurl = query_url(title)

    jobs = request_jobs(qurl)

    first_job = get_first(jobs)

    description = scrape_description(first_job)

    nouns = Analyzer.get_nouns(description)
    matches = Analyzer.get_similar(nouns.uniq, Constants::titles, 0.8)
  end

  def scrape_description(job)
    url = job['url']
    doc = Nokogiri::HTML(open(url))
    doc.css('#job_summary').text
  end

  private

  def request_jobs(qurl)
    url = URI.parse(qurl)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    results = JSON.parse(res.body)['results']

    byebug
    Resque.enqueue(StoreReqJob, results)

    results
  end

  def get_first(arr)
    arr[0]
  end

  def query_url(title)
    ['http://api.indeed.com/ads/',
     'apisearch?',
     'v=2',
     '&publisher=883066880941130',
     "&q=#{title}",
     "&l=new%20york%2C+ny",
     # "&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us",
     "&format=json"].join('')
  end
end
