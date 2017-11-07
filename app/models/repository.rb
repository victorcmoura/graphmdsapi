class Repository < ApplicationRecord
  has_many :associations, dependent: :destroy
  validates :name, uniqueness: true, presence: true
end
