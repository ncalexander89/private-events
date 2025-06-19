class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :event_id, uniqueness: { scope: :user_id, message: "has already invited this user" }
end
