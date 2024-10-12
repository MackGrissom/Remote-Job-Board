class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :company
      t.string :location
      t.string :job_type
      t.decimal :salary
      t.string :apply_link

      t.timestamps
    end
  end
end
