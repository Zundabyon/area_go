class CatchRecord < ApplicationRecord
  belongs_to :user
  belongs_to :facility
  belongs_to :lure, optional: true

  FISH_SPECIES = [
    "ニジマス", "ヤマメ", "イワナ", "ブラウントラウト",
    "ブルックトラウト", "レインボートラウト", "イトウ", "その他"
  ].freeze

  validates :caught_at,    presence: true
  validates :fish_species, presence: true
  validates :size_cm,  numericality: { greater_than: 0 }, allow_nil: true
  validates :depth_m,  numericality: { greater_than: 0 }, allow_nil: true

  before_save :parse_fishing_method_data

  scope :recent, -> { order(caught_at: :desc) }
  scope :at_facility, ->(facility_id) { where(facility_id: facility_id) }
  scope :with_location, -> { where.not(latitude: nil) }

  def fishing_method_chart?
    fishing_method_data.present? && fishing_method_data["strokes"].present?
  end

  private

  def parse_fishing_method_data
    return unless fishing_method_data.is_a?(String) && fishing_method_data.present?
    self.fishing_method_data = JSON.parse(fishing_method_data)
  rescue JSON::ParserError
    self.fishing_method_data = {}
  end
end
