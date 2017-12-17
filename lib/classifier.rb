# encoding: utf-8
require 'classifier-reborn'

module Classifier
  def self.train
    titles = JobReq.select(:title).group(:title).map { |j| j.title.try(:downcase) }
    classifier = ClassifierReborn::Bayes.new titles

    JobReq.all.each do |req|
      if req.title && req.description
        begin
          classifier.train req.title.try(:downcase), req.description
        rescue
          p req
        end
      end
    end

    classifier_snapshot = Marshal.dump classifier
    classifier_snapshot = classifier_snapshot.force_encoding("UTF-8")

    File.open("classifier.dat", "w") {|f| f.write(classifier_snapshot) }

  end

  def self.assign
  end

  def self.load_classifier
    data = File.read("classifier.dat")
    trained_classifier = Marshal.load data.force_encoding("ASCII-8BIT")
  end

end