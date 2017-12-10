require 'net/http'
# require 'treat'
require 'engtagger'
# require 'fuzzy_match'
require 'fuzzystringmatch'

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
    byebug
    res = Resume.new(file: resume.path, title_tags: titles)
    res.save!
  end

  def get_nouns(res_content)
    # content = section res_content
    # content.apply :chunk, :tokenize, :category
    tgr = EngTagger.new
    tagged = tgr.add_tags(res_content)
    nps = tgr.get_noun_phrases(tagged)
    nps.keys
  end

  def get_titles(nouns)
    final_titles = []
    #matcher = FuzzyMatch.new(Constants::titles, :must_match_at_least_one_word => true)
    jarow = FuzzyStringMatch::JaroWinkler.create( :native )

    nouns.uniq.each do |noun|
      Constants::titles.each do |title|
        dist = jarow.getDistance(noun.downcase, title.downcase)
        if dist > 0.8
          final_titles.push(title)
        end
      end
    end

    final_titles = final_titles.uniq
    @titles = final_titles
  end
end
