module PDFUtil
  def self.to_string(file)
    res_content = ''
    parsed_resume = PDF::Reader.new(resume.path)

    parsed_resume.pages.each do |p|
      res_content += p.text
    end

    res_content
  end
end