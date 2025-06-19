class Event < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  has_many :attendances, foreign_key: "attended_event_id", dependent: :destroy
  has_many :attendees, through: :attendances, source: :attendee

  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user

  scope :past, -> { where("date < ?", Time.current).order(date: :desc) }
  scope :upcoming, -> { where("date >= ?", Time.current).order(date: :asc) }

  # Check if a user is allowed to view or attend a private event
  def accessible_by?(user)
    return true unless private?
    return false if user.nil?
    user == creator || invited_users.include?(user)
  end
end
