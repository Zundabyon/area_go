class DashboardController < ApplicationController
  def index
    @recent_catch_records = current_user.catch_records
                              .includes(:facility, :lure)
                              .recent
                              .limit(5)
    @lure_count   = current_user.lures.count
    @catch_count  = current_user.catch_records.count
    @top_facility = current_user.catch_records
                      .joins(:facility)
                      .group(:facility_id, "facilities.name")
                      .order("count_all DESC")
                      .limit(1)
                      .count
                      .first
  end
end
