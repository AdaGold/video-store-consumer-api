class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end
    render status: :ok, json: data
  end

  def create
    # raw_movie = params[:movie]
    # movie.title = raw_movie[:title]
    # movie.overview = raw_movie[:overview]
    # movie.release_date = raw_movie[:release_date]
    # movie.image_url = raw_movie[:image_url].slice!('https://image.tmdb.org/t/p/w185')
    # movie.external_id = raw_movie[:external_id]
    # movie.inventory = raw_movie[:inventory]
    #
    # movie = Movie.new(raw_movie)
    movie = Movie.new(movie_params)
    if movie.save
      render json: {
        id: movie.id }, status: :ok
    else
      render json: { errors: movie.errors.messages }, status: :bad_request
    end
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  private

  def movie_params
    # return params.permit(:title, :overview, :release_date, :image_url, :external_id)

    return params.permit(:title, :overview, :release_date, :image_url, :external_id, :inventory)
  end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
