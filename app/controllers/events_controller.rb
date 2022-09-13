class EventsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.new
    render plain: render_to_string(partial: 'form_new', layout: false, locals: { event: @event })
  end

  def index
    @events = Event.all
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path
    else
      render :index
    end
  end

  def update
    starttime = params[:start]
    endtime = params[:end]
    event = Event.find(params[:id])
    event.update(start: starttime, end: endtime)
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
  end

  def event_params
    params.require(:event).permit(:start, :end, :title)
  end
end