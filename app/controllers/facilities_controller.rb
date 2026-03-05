class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.order(:name)
    @facilities = @facilities.by_prefecture(params[:prefecture]) if params[:prefecture].present?
  end

  def show
    @facility      = Facility.find(params[:id])
    @catch_records = @facility.catch_records
                       .where(user: current_user)
                       .includes(:lure)
                       .recent
                       .limit(20)
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = Facility.find_or_initialize_by(place_id: facility_params[:place_id])
    @facility.assign_attributes(facility_params)
    if @facility.save
      redirect_to @facility, notice: "施設を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    # 登録済み施設のJSONを返す（地図表示用）
    @facilities = Facility.where.not(latitude: nil).order(:name)
    render json: @facilities.as_json(only: [ :id, :name, :latitude, :longitude, :address ])
  end

  private

  def facility_params
    params.require(:facility).permit(
      :name, :address, :latitude, :longitude,
      :place_id, :phone_number, :website_url, :description, :prefecture
    )
  end
end
