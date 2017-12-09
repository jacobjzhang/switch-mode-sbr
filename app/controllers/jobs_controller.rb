require 'net/http'

# JobsController is documented here.
class JobsController < ApplicationController
  def search
    title = params[:title]
    url = URI.parse("http://api.indeed.com/ads/apisearch?v=2&publisher=883066880941130&q=#{title}&l=new%20york%2C+ny&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us&format=json")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    render :json => res.body
  end
end
