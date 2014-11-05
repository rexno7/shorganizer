class EpisodesController < ApplicationController

  def index
    @show = Show.find(params[:show_id])
    @episodes = @show.episodes.all
  end

  def create
    @show = Show.find(params[:show_id])
    @episode = @show.episodes.create(episode_params)
  end
  
  def destroy
    @show = Show.find(params[:show_id])
    @episode = @show.episodes.find(params[:id])
    @episode.destroy
  end
  
  private
    def episode_params
      params.require(:episode).permit(:title, :no, :air_date, :air_time,
        :season, :channel, :watched, :show)
    end
end
