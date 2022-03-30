class CreateTargets < ActiveRecord::Migration[6.1]
  def change
    create_table :targets do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
