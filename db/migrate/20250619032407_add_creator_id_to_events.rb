class AddCreatorIdToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :creator_id, :integer
  end
end
