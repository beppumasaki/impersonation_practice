class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
