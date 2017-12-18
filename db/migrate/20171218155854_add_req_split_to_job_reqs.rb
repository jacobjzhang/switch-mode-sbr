class AddReqSplitToJobReqs < ActiveRecord::Migration[5.1]
  def change
    add_column :job_reqs, :qualifications, :string
    add_column :job_reqs, :responsibilities, :string
  end
end
