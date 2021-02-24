class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true

  validate :accepted
  validate :checkedout

  def checkedout
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Can't review until checked out")
    end
  end

  def accepted
    if reservation && reservation.status != 'accepted' 
      errors.add(:reservation, "Must have accepted res to review")
    end
  end
end
