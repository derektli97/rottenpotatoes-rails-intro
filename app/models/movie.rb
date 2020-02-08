class Movie < ActiveRecord::Base

    def self.get_ratings
        ['G','PG','PG-13','R']
    end

    def self.ratings
        Movie.select(:rating).distinct.inject([]) { |a, m | a.push m.rating}
    end
end
