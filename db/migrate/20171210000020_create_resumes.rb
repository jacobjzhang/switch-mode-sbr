class CreateResumes < ActiveRecord::Migration[5.1]
  def change
    create_table :resumes do |t|
      t.string :file
      t.string :title_tags

      t.timestamps
    end
  end
end
