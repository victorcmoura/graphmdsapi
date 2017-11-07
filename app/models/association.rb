class Association < ApplicationRecord
  belongs_to :user
  belongs_to :repository

  validates :user, presence: true
  validates :repository, presence: true

  validates_uniqueness_of :user_id, scope: [:repository_id]
end
