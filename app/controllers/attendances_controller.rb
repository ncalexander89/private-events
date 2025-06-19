class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def create
    event = Event.find(params[:event_id])
    unless current_user.attended_events.include?(event)
      current_user.attended_events << event
      flash[:notice] = "You are now attending this event."
    else
      flash[:alert] = "You are already attending this event."
    end
    redirect_to event_path(event)
  end

  def destroy
    event = Event.find(params[:event_id])
    attendance = current_user.attendances.find_by(attended_event_id: event.id)
    if attendance
      attendance.destroy
      flash[:notice] = "You are no longer attending this event."
    else
      flash[:alert] = "You were not attending this event."
    end
    redirect_to event_path(event)
  end
end
