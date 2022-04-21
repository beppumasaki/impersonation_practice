class AddStateToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :state, :integer, null: false, default: 0
  end
end
