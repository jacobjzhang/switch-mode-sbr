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

    nps = get_nouns(@res_content)
    titles = get_titles(nps)
  end

  def get_nouns(res_content)
    # content = section res_content
    # content.apply :chunk, :tokenize, :category
    tgr = EngTagger.new
    tagged = tgr.add_tags(res_content)
    nps = tgr.get_noun_phrases(tagged)
  end

  def get_titles(nouns)
    final_titles = []
    matcher = FuzzyMatch.new(Constants::titles)

    nouns.each do |title|
      matched_title = matcher.find(title)
      final_titles.push(matched_title)
    end

    final_titles = final_titles.uniq

    byebug
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
