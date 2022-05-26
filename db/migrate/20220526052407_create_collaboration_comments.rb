class CreateCollaborationComments < ActiveRecord::Migration[6.1]
  def change
    create_table :collaboration_comments do |t|
      t.string :body
      t.references :user, null: false, foreign_key: true
      t.references :collaboration, null: false, foreign_key: true

      t.timestamps
    end
  end
end
