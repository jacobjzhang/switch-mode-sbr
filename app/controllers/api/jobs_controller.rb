require 'net/http'

# JobsController is documented here.
class Api::JobsController < Api::BaseController
  def search
    title = params[:title]

    qurl = query_url(title)

    jobs = request_jobs(qurl)
  end

  def analyze
    nouns = Analyzer.get_nouns(description)
    matches = Analyzer.get_similar(nouns.uniq, Constants::titles, 0.8)
  end

  private

  def request_jobs(qurl)
    url = URI.parse(qurl)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    results = JSON.parse(res.body)['results']

    StoreReqJob.set(queue: 'store_req').perform_later(results)

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
