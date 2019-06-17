class Center < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

end

def centers_db
    PokeApi.get(location: {offset: rand(1..781)}).results.select {|city| city.name.include?("city")}.map {|city| city.name.capitalize}
end

def add_centers_to_db
    centers_db.each {|center| Center.create(center: center)}
end

def random_type

end