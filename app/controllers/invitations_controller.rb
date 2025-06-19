class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_creator!

  def new
    @users = User.where.not(id: @event.invited_users.pluck(:id) + [@event.creator_id])
  end

  def create
    user = User.find(params[:user_id])
    invitation = @event.invitations.new(user: user)

    if invitation.save
      redirect_to event_path(@event), notice: "#{user.email} has been invited."
    else
      redirect_to new_event_invitation_path(@event), alert: "Could not invite user."
    end
  end

  def destroy
    invitation = @event.invitations.find(params[:id])
    invitation.destroy
    redirect_to event_path(@event), notice: "Invitation removed."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_creator!
    redirect_to events_path, alert: "Not authorized." unless @event.creator == current_user
  end
end
