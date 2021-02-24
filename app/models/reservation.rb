class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :user_not_host

  validate :available_checkin
  validate :available_checkout

  validate :different_check_in_out
  validate :checkin_before_checkout


  def total_price
    listing.price * duration
  end

  def duration
    checkout - checkin
  end

  private

  def user_not_host
    if guest == listing.host
      errors.add(:guest, "guest cannot by host")
    end
  end

  def available_checkin
    listing.reservations.each do |r|
      if checkin && r.checkin < checkin && r.checkout > checkin
        errors.add(:checkin, "unavailable checkin date")
      end
    end
  end

  def available_checkout
    listing.reservations.each do |r|
      if checkout && r.checkin < checkout && r.checkout > checkout
        errors.add(:checkin, "unavailable checkout date")
      end
    end
  end

  def different_check_in_out
    if checkin && checkout && checkin == checkout
      errors.add(:checkout, "Checkin and checkout must be different date")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin > checkout
      errors.add(:checkout, "Checkout must be after checkin")
    end
  end
end
