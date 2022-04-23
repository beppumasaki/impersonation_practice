class CreateCollaborations < ActiveRecord::Migration[6.1]
  def change
    create_table :collaborations do |t|
      t.string :title
      t.text :body
      t.string :collaboration_voice, null: false
      t.integer :state, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :result, null: false, foreign_key: true

      t.timestamps
    end
  end
end
