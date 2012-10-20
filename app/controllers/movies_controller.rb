class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings

    redirect = false

    @category = nil
    if params.has_key?(:category)
      @category = params[:category]
    elsif session.has_key?(:category)
      @category = session[:category]
      redirect = true
    end

    @sort = nil
    if params.has_key?(:sort)
      @sort = params[:sort]
    elsif session.has_key?(:sort)
      @sort = session[:sort]
      redirect = true
    end

    @ratings =  {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
    if params.has_key?(:ratings)
      @ratings = params[:ratings]
    elsif session.has_key?(:ratings)
      @ratings = session[:ratings]
      redirect = true
    end

    @movies = Movie.where("rating in (?)", @ratings.keys)
    session[:ratings] = @ratings

    if @category and @sort
      @movies = @movies.find(:all, :order => "#{@category} #{@sort}")
      session[:category] = @category
      session[:sort] = @sort
    end

    if redirect
      flash.keep
      redirect_to movies_path({:category => @category, :sort => @sort, :ratings => @ratings})
    end

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
