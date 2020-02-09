class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  ## ------------------------------ working on ------------------------------
  def index

    #set rating
    @all_ratings = Movie.get_ratings

    if params[:sort_by] != nil
      @select_ratings = session[:sort] = params[:sort_by]
    end

    if params[:ratings] != nil
      session[:ratings] = params[:ratings]
      @select_ratings = params[:ratings].keys
    else
      @select_ratings= @all_ratings
    end

    #hilite headers
    if session[:sort] == "title"
      @hilite = "title"
    elsif session[:sort] == "release_date"
      @hilite = "release_date"
    elsif session[:sort] == "rating"
      @hilite = "rating"
    end

    @movies = Movie.where(rating:@select_ratings).order(session[:sort])
   
    if ( session[:sort] != nil  && params[:sort_by] == nil)
      if (params[:ratings] == nil && session[:ratings] != nil)
        redirect_to movies_path(sort_by: session[:sort], ratings:session[:ratings])
        flash.keep
      end
    end
  

  end

  ## =========================== working end ====================================


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
