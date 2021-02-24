class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  
  def average_review_rating
    reviews.map(&:rating).reduce(:+).to_f / reviews.count
  end

  after_create :set_host
  after_destroy :check_host

  def has_availability?(start_date, end_date)
    reservations.each do |r|
      if start_date < r.checkin && end_date > r.checkin
        return false
      elsif start_date < r.checkout && end_date > r.checkout
        return false
      elsif r.checkin < start_date && r.checkout > start_date
        return false
      elsif r.checkin < end_date && r.checkout > end_date
        return false
      end
    end
    true
  end

  private

  def set_host
    host.update(host: true)
  end

  def check_host
    host.update(host: false) if host.listings.empty?
  end

end
