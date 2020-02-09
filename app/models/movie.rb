class Movie < ActiveRecord::Base

    def self.get_ratings
        @rating = ['G','PG','PG-13','R']
        return @rating
    end

end
