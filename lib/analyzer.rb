require 'engtagger'
require 'fuzzystringmatch'

module Analyzer
  def self.get_nouns(res_content)
    # content = section res_content
    # content.apply :chunk, :tokenize, :category
    tgr = EngTagger.new
    tagged = tgr.add_tags(res_content)
    nps = tgr.get_noun_phrases(tagged)
    nps.keys
  end

  def self.get_similar(list1, clist2, threshold)
    jarow = FuzzyStringMatch::JaroWinkler.create( :native )

    similar = []
    list1.uniq.each do |noun|
      clist2.each do |title|
        dist = jarow.getDistance(noun.downcase, title.downcase)
        if dist > 0.8
          similar.push(title)
        end
      end
    end

    similar
  end
end