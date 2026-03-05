class LuresController < ApplicationController
  before_action :set_lure, only: [ :show, :edit, :update, :destroy, :catch_records ]

  def index
    @lures = current_user.lures.order(:name)
    @lures = @lures.where(lure_type: params[:type]) if params[:type].present?
  end

  def show; end

  def new
    @lure = current_user.lures.new(buoyancy: 3, color_front: "#ffffff", color_back: "#ffffff")
  end

  def create
    @lure = current_user.lures.new(lure_params)
    if @lure.save
      redirect_to @lure, notice: "ルアーを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @lure.update(lure_params)
      redirect_to @lure, notice: "ルアーを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lure.destroy
    redirect_to lures_path, notice: "ルアーを削除しました", status: :see_other
  end

  def catch_records
    @catch_records = @lure.catch_records.includes(:facility).recent
  end

  private

  def set_lure
    @lure = current_user.lures.find(params[:id])
  end

  def lure_params
    params.require(:lure).permit(:name, :lure_type, :color_front, :color_back, :weight, :buoyancy)
  end
end
