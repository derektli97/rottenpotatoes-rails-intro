class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    #hilite title, rating, and release date
    if params[:sort] == "title"
      @hilite = "title"
    elsif params[:sort] == "release_date"
      @hilite = "release_date"
    elsif params[:sort] == "rating"
      @hilite = "rating"
    end

    #sorting our movies
    @hilite = params[:sort_by]
    sort = @hilite
    @movies = Movie.all.order(params[:sort_by])

    #ratings 
    @all_ratings = Movie.get_ratings

    #selected rating
    @select_ratings = (params[:ratings].keys if params.key?(:ratings)) || @all_ratings
    @movies = Movie.all.order(sort).where(rating: @select_ratings)


  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
