class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.text :bio
      t.text :skills
      t.text :experience
      t.text :education

      t.timestamps
    end
  end
end