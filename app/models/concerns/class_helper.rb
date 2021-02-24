module ClassHelper
  def highest_ratio_res_to_listings
    all.max do |a, b|
      a.res_to_listing_ratio <=> b.res_to_listing_ratio
    end
  end

  def most_res
    all.max do |a, b|
      a.total_resevations <=> b.total_resevations
    end
  end
end