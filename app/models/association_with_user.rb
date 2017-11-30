class AssociationWithUser < ApplicationRecord

  validates_uniqueness_of :user_one_id, scope: [:user_two_id]

  belongs_to :user_one, :class_name => 'User'
  belongs_to :user_two, :class_name => 'User'

  validates :user_one, presence: true
  validates :user_two, presence: true
  validate :user_one_cant_be_user_two
  #validate :inverted_tuples_are_not_valid
end

def user_one_cant_be_user_two
  if self.user_one_id == self.user_two_id
    errors.add(:user_one_id, "User one cannot be the same as user two")
  end
end

def inverted_tuples_are_not_valid
  @possible_duplicates = AssociationWithUser.where(:user_one_id => self.user_two_id).all
  @possible_duplicates = @possible_duplicates.where(:user_two_id => self.user_one_id).all

  if @possible_duplicates.count > 0
    errors.add(:user_one_id, "exists in another inverted tuple")
    errors.add(:user_two_id, "exists in another inverted tuple")
  end
end
