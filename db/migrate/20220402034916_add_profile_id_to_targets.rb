class AddProfileIdToTargets < ActiveRecord::Migration[6.1]
  def change
    add_column :targets, :profile_id, :string
  end
end
