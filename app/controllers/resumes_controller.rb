require 'net/http'
# require 'treat'
require 'engtagger'
require 'fuzzy_match'

include Treat::Core::DSL

# ResumesController is documented here.
class ResumesController < ApplicationController
  def new
    p 'Hey'
  end

  def create
    # render plain: params[:resume].inspect
    profile = params[:profile]
    resume = profile[:resume]

    parsed_resume = PDF::Reader.new(resume.path)

    @res_content = ''
    parsed_resume.pages.each do |p|
      @res_content += p.text
    end

    parse_resume(@res_content)
  end

  def parse_resume(resume_content)
    byebug
    parsed_res = Presume.new(resume_content, 'guy')
    make_indeed_query(keywords)
  end

  def make_indeed_query
    url = URI.parse("http://api.indeed.com/ads/apisearch?v=2&publisher=883066880941130&q=java&l=austin%2C+tx&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us&format=json")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body
  end
end
