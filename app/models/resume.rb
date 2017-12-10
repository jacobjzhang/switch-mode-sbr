class Resume < ApplicationRecord
  belongs_to :user
  serialize :title_tags, Array
end
