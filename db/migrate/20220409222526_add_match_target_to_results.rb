class AddMatchTargetToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :match_target, :string
  end
end
