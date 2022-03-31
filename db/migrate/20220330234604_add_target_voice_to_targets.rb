class AddTargetVoiceToTargets < ActiveRecord::Migration[6.1]
  def change
    add_column :targets, :target_voice, :string
  end
end
