class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lures,            dependent: :destroy
  has_many :catch_records,    dependent: :destroy
  has_many :fishing_sessions, dependent: :destroy

  validates :username, presence: true, length: { minimum: 2, maximum: 30 }
end
