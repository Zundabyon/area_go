class DashboardController < ApplicationController
  def index
    @recent_fishing_sessions = current_user.fishing_sessions
                                 .includes(:facility, :catch_records)
                                 .recent
                                 .limit(5)
    @lure_count    = current_user.lures.count
    @session_count = current_user.fishing_sessions.count
    @catch_count   = current_user.catch_records.count
    @top_facility  = current_user.catch_records
                       .joins(:facility)
                       .group(:facility_id, "facilities.name")
                       .order("count_all DESC")
                       .limit(1)
                       .count
                       .first
  end
end
