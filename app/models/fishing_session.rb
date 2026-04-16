class FishingSession < ApplicationRecord
  belongs_to :user
  belongs_to :facility
  has_many :catch_records, dependent: :nullify

  WEATHER_OPTIONS = [ "晴れ", "曇り", "雨", "晴れ&雨", "雪" ].freeze
  WEATHER_ICONS   = { "晴れ" => "☀️", "曇り" => "☁️", "雨" => "🌧️", "晴れ&雨" => "🌦️", "雪" => "❄️" }.freeze

  WATER_CONDITIONS = [
    { value: "クリア",    label: "クリア",    icon: "💧", desc: "透明度が高い" },
    { value: "ステイン",  label: "ステイン",  icon: "🌊", desc: "やや濁り" },
    { value: "マッディ",  label: "マッディ",  icon: "🟤", desc: "強い濁り" }
  ].freeze
  WATER_CONDITION_VALUES = WATER_CONDITIONS.map { |c| c[:value] }.freeze

  validates :fished_on, presence: true

  scope :recent, -> { order(fished_on: :desc) }

  def weather_am_icon
    WEATHER_ICONS[weather_am] || "🎣"
  end

  def weather_pm_icon
    WEATHER_ICONS[weather_pm] || "🎣"
  end

  def weather_icon
    WEATHER_ICONS[weather_am] || WEATHER_ICONS[weather_pm] || "🎣"
  end
end
