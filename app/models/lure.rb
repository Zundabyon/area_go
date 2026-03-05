class Lure < ApplicationRecord
  belongs_to :user
  has_many :catch_records, dependent: :nullify

  enum :lure_type, { spoon: 0, crankbait: 1, minnow: 2, other: 3 }

  BUOYANCY_LABELS = {
    1 => "フローティング",
    2 => "スローフローティング",
    3 => "サスペンド",
    4 => "スローシンキング",
    5 => "シンキング"
  }.freeze

  LURE_TYPE_LABELS = {
    "spoon"    => "スプーン",
    "crankbait" => "クランクベイト",
    "minnow"   => "ミノー",
    "other"    => "その他"
  }.freeze

  validates :name,     presence: true
  validates :lure_type, presence: true
  validates :buoyancy,  inclusion: { in: 1..5 }
  validates :color_front, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "は有効なカラーコードを入力してください" }
  validates :color_back,  format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "は有効なカラーコードを入力してください" }

  def buoyancy_label
    BUOYANCY_LABELS[buoyancy]
  end

  def lure_type_label
    LURE_TYPE_LABELS[lure_type]
  end
end
