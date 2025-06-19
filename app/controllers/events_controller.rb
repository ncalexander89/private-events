class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_creator!, only: [:edit, :update, :destroy]

  def index
    @upcoming_events = Event.upcoming.select { |e| e.accessible_by?(current_user) }
    @past_events = Event.past.select { |e| e.accessible_by?(current_user) }
  end
  

  def show
    @event = Event.find(params[:id])
    unless @event.accessible_by?(current_user)
      redirect_to events_path, alert: "You are not authorized to view this event."
    end
  end
  
  def new
    @event = Event.new
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_creator!
    redirect_to events_path, alert: "You are not authorized to perform this action." unless @event.creator == current_user
  end

  def event_params
    params.require(:event).permit(:title, :location, :date)
  end
end
