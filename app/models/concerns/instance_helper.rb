module InstanceHelper
  def openings(start_date, end_date)
    listings.find_all do |listing|
      listing.has_availability?(start_date.to_date, end_date.to_date)
    end
  end

  def total_resevations
    listings.reduce(0) {|sum, listing| sum + listing.reservations.count}
  end

  def res_to_listing_ratio
    listings.count > 0 ? (total_resevations / listings.size.to_f) : 0
  end
end
