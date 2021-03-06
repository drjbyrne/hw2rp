class MoviesController < ApplicationController

#  def initialize
#    debugger
#    end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     self.ratings
     session[:sort] = params[:sort] if params[:sort]
     session[:ratings] = params[:ratings] if params[:ratings]
     redir=true unless params[:sort] || params[:ratings]
     if redir && session[:ratings]
       params[:sort] = session[:sort]
       params[:ratings] = session[:ratings]
       flash.keep
       redirect_to movies_path(params.slice(:sort,:ratings))
       end
    @sel_ratings = session[:ratings] ? session[:ratings].keys : @all_ratings
     if session[:sort]
       @movies = Movie.where(:rating => @sel_ratings).order(session[:sort])
       else
       @movies = Movie.where(:rating => @sel_ratings).all
       end
  end

  def ratings
    @all_ratings = Movie.select("DISTINCT rating").map(&:rating)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
