class AddChunksToResumes < ActiveRecord::Migration[5.1]
  def change
    add_column :resumes, :nouns, :string
  end
end
