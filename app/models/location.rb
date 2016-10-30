class Location < ActiveRecord::Base
  # def <=>(other_location)
  #   if (:latitude == other_location.latitude)
  #     :longitude <=> other_location.longitude
  #   else
  #     :latitude <=> other_location.latitude
  #   end
  # end

  public
  def self.get_snpi(location, all_locations, radius)
    (all_locations.find_all {|l| inside?(location,l,radius)}).collect
  end

  def self.get_convex_hull(all_locations)
    convex_hull(all_locations)
  end

  def self.get_perimeter(all_locations)
    perimeter(all_locations)
  end

  def self.get_farthest_distance(location, all_locations)
    farthest_distance(location, all_locations).name
  end

  def self.get_visited_locations(route, radius)
    @route = JSON.parse(route)
    @locations = Location.all
    @visited_locations = {}

    @route['route'].each do |location|
      @location = Location.new(:latitude => location['latitude'], :longitude => location['longitude'])
      @visited_locations[:location] = (@locations.find_all {|l| inside?(@location,l,radius)})
    end

    @visited_locations[:location]
  end


  private
#get_farest_distance
  def self.farthest_distance(location, all_locations)
    max = distance(location,all_locations.first)
    farthest_location = all_locations.first
    all_locations.drop(1).each  do |l|
      distance = distance(location, l)
      if distance > max
        max = distance
        farthest_location = l
      end
    end
    farthest_location
  end
#get_farest_distance

#get_perimeter
  def self.perimeter(all_locations)
    perimeter = 0
    (0..all_locations.length - 1).each do |i|
      if(i == all_locations.length - 1)
        perimeter += distance(all_locations[i], all_locations[0])
      else
        perimeter += distance(all_locations[i], all_locations[i + 1])
      end
    end
    perimeter
  end

#get_perimeter


#find near locations
  def self.to_radians(value)
    value * Math::PI / 180
  end
  def self.distance(location_a, location_b)
    earth_radius = 6371
    latitude_delta = to_radians(location_b.latitude - location_a.latitude)
    longitude_delta = to_radians(location_b.longitude - location_a.longitude)

    a = Math.sin(latitude_delta/2) * Math.sin(latitude_delta/2) +
        Math.sin(longitude_delta/2) * Math.sin(longitude_delta/2) * Math.cos(to_radians(location_a.latitude)) * Math.cos(to_radians(location_b.latitude))
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = earth_radius * c

  end

  def self.inside?(location_a, location_b, radius)
    distance(location_a,location_b) < radius.to_f
  end

#find near locations

#get convex hull

  def self.convex_hull(all_locations)
    all_locations = (all_locations.sort {|a,b| a.latitude == b.latitude ? a.longitude <=> b.longitude : a.latitude <=> b.latitude}).uniq
    return all_locations if all_locations.length <= 3
    lower = Array.new
    all_locations.each{|l|
      while lower.length > 1 and cross(lower[-2], lower[-1], l) <= 0 do lower.pop end
      lower.push(l)
    }
    upper = Array.new
    all_locations.reverse_each{|l|
      while upper.length > 1 and cross(upper[-2], upper[-1], l) <= 0 do upper.pop end
      upper.push(l)
    }
    return lower[0...-1] + upper[0...-1]
  end

  def self.cross(o, a, b)
    (a.longitude - o.longitude) * (b.latitude - o.latitude) - (a.latitude - o.latitude) * (b.longitude - o.longitude)
  end
  #get convex hull
end