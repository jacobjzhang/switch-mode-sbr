class SplitJobReqJob < ApplicationJob
  queue_as :low

  @@split_words = [
    'we are looking for',
    'benefits',
    'is a'
  ]

  def perform(*args)
    JobReq.all.each do |job|
      if job.description
        split_req(job, job.description)
      end
    end
  end

  def split_req(record, description)
    jd = description.downcase
    qual_index = jd.index(/qualifications/)
    resp_index = jd.index(/responsibilities/)

    q = ''
    r = ''
    if qual_index
      q = getQualifications(jd, qual_index)
    elsif resp_index
      r = getResponsibilities(jd, resp_index)
    end

    record.update_attributes(qualifications: q)
    record.update_attributes(responsibilities: r)
  end

  def getQualifications(raw, qual_index)
    qual_start = raw.slice(qual_index, raw.length - 1)

    stop = getIdxOfStop(qual_start)
    qual_start.slice(0, stop)
  end

  def getResponsibilities(raw, resp_index)
    resp_start = raw.slice(resp_index, raw.length - 1)

    stop = getIdxOfStop(resp_start)
    resp_start.slice(0, stop)
  end

  protected

  def getIdxOfStop(substr)
    first_idx = 0
    @@split_words.each do |word|
      first_idx = substr.index(word)
      if first_idx
        break
      end
    end

    first_idx ? first_idx : substr.length
  end

end
