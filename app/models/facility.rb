class Facility < ApplicationRecord
  has_many :catch_records, dependent: :destroy

  validates :name, presence: true
  validates :latitude,  numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true

  scope :by_prefecture, ->(pref) { where(prefecture: pref) }
  scope :verified, -> { where(is_verified: true) }
end
