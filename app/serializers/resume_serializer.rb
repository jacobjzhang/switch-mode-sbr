class ResumeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :file, :title_tags, :created_at
end
