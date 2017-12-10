require 'net/http'
# require 'treat'
include Treat::Core::DSL

# ResumesController is documented here.
class ResumesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @saved_titles ||= current_user.resumes.last.title_tags
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

    nps = Analyzer.get_nouns(@res_content)
    titles = get_titles(nps)
    res = Resume.new(
      file: resume.path,
      chunks: nps,
      title_tags: titles,
      user_id: current_user.id
    )
    res.save!
  end

  def show
    @resume = Resume.find(params[:id])
  end

  protected

  def get_titles(nouns)
    final_titles = Analyzer.get_similar(nouns.uniq, Constants::titles, 0.8)

    final_titles = final_titles.uniq
    @titles = final_titles
  end
end
