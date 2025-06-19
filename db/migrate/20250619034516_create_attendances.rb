class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.integer :attendee_id
      t.integer :attended_event_id

      t.timestamps
    end

    add_index :attendances, [:attendee_id, :attended_event_id], unique: true
  end
end
