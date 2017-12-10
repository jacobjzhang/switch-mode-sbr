class CreateJobReqs < ActiveRecord::Migration[5.1]
  def change
    create_table :job_reqs do |t|
      t.string :company
      t.date :date
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
