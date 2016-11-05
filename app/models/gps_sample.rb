class Gps_sample < ActiveRecord::Base
  public
  
	def self.save_gps_sample(route, user)
		@route = JSON.parse(route)
		@route['route'].each do |location|
		@location = Gps_sample.new(:latitude => location['latitude'], :longitude => location['longitude'], :description => location['timestamp'], :name => nil, :user => user)
      		@location.save
		end
		return true
  	end

	def self.get_locbyuser(user)
		self.where(user: user)
	end

end
