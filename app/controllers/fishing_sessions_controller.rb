class FishingSessionsController < ApplicationController
  before_action :set_fishing_session, only: [ :show, :edit, :update, :destroy ]

  def index
    @fishing_sessions = current_user.fishing_sessions
                          .includes(:facility, :catch_records)
                          .recent
  end

  def show
    @catch_records = @fishing_session.catch_records.includes(:lure).recent
  end

  def new
    @fishing_session = current_user.fishing_sessions.new(fished_on: Date.today)
    @facilities = Facility.order(:name)
  end

  def create
    @fishing_session = current_user.fishing_sessions.new(fishing_session_params)
    if @fishing_session.save
      redirect_to @fishing_session, notice: "釣行を記録しました"
    else
      @facilities = Facility.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @facilities = Facility.order(:name)
  end

  def update
    if @fishing_session.update(fishing_session_params)
      redirect_to @fishing_session, notice: "釣行を更新しました"
    else
      @facilities = Facility.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fishing_session.destroy
    redirect_to fishing_sessions_path, notice: "釣行を削除しました", status: :see_other
  end

  private

  def set_fishing_session
    @fishing_session = current_user.fishing_sessions.find(params[:id])
  end

  def fishing_session_params
    params.require(:fishing_session).permit(:fished_on, :facility_id, :weather_am, :weather_pm, :water_condition, :pond_number, :memo)
  end
end
