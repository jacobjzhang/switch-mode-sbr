class AddDetailsToJobReqs < ActiveRecord::Migration[5.1]
  def change
    add_column :job_reqs, :category, :string
    add_column :job_reqs, :url, :string
    add_column :job_reqs, :tags, :string
  end
end
