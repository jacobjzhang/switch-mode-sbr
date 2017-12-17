require 'net/http'
include Treat::Core::DSL

# ResumesController is documented here.
class Api::ResumesController < Api::BaseController
  def index
    respond_with Resume.all, status: 200
  end

  def new
    @saved_titles ||= current_user.resumes.last.title_tags
  end

  def create
    resume = params[:file]

    begin
      @res_content = PDFUtil.to_string(resume)
    rescue
      puts "No resume file found."
    end

    nps = Analyzer.get_nouns(@res_content)
    titles = get_titles(nps)
    res = Resume.new(
      file: resume.path,
      nouns: nps,
      title_tags: titles,
      user_id: current_user.id
    )
    res.save!
  end

  def show
    respond_with Resume.find(params[:id]), status: 200
  end

  protected

  def get_titles(nouns)
    final_titles = Analyzer.get_similar(nouns.uniq, Constants::titles, 0.8)

    final_titles = final_titles.uniq
    @titles = final_titles
  end
end
