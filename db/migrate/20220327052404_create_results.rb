class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.string :impersonation_voice, null: false
      t.integer :score, null: false
      t.text :body
      t.references :target, foreign_key: true, null: false

      t.timestamps
    end
  end
end
