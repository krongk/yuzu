class City < ActiveRecord::Base

  def self.get_id(name)
    City.find_by(name: name).try(:id)
  end

end
