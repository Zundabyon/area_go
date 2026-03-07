class CatchRecordsController < ApplicationController
  before_action :set_catch_record, only: [ :show, :edit, :update, :destroy ]

  def index
    @catch_records = current_user.catch_records
                       .includes(:facility, :lure)
                       .recent
    @catch_records = @catch_records.at_facility(params[:facility_id]) if params[:facility_id].present?
  end

  def show; end

  def new
    @catch_record = current_user.catch_records.new(caught_at: Time.current)
    if params[:fishing_session_id].present?
      @fishing_session = current_user.fishing_sessions.find_by(id: params[:fishing_session_id])
      @catch_record.fishing_session_id = @fishing_session&.id
      @catch_record.facility_id        = @fishing_session&.facility_id
    end
    @facilities = Facility.order(:name)
    @lures      = current_user.lures.order(:name)
  end

  def create
    @catch_record = current_user.catch_records.new(catch_record_params)
    if @catch_record.save
      redirect_to @catch_record, notice: "釣果を記録しました"
    else
      @facilities = Facility.order(:name)
      @lures      = current_user.lures.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @facilities = Facility.order(:name)
    @lures      = current_user.lures.order(:name)
  end

  def update
    if @catch_record.update(catch_record_params)
      redirect_to @catch_record, notice: "釣果を更新しました"
    else
      @facilities = Facility.order(:name)
      @lures      = current_user.lures.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @catch_record.destroy
    redirect_to catch_records_path, notice: "釣果を削除しました", status: :see_other
  end

  def map
    @catch_records = current_user.catch_records
                       .with_location
                       .includes(:facility, :lure)
    respond_to do |format|
      format.html
      format.json do
        render json: @catch_records.as_json(
          only: [ :id, :latitude, :longitude, :size_cm, :fish_species, :caught_at ],
          include: {
            facility: { only: [ :name ] },
            lure:     { only: [ :name ] }
          }
        )
      end
    end
  end

  private

  def set_catch_record
    @catch_record = current_user.catch_records.find(params[:id])
  end

  def catch_record_params
    params.require(:catch_record).permit(
      :facility_id, :lure_id, :size_cm, :fish_species,
      :latitude, :longitude, :depth_m, :memo,
      :caught_at, :stocking_time, :fishing_method_data,
      :fishing_session_id, :weather, :wind_strength
    )
  end
end
