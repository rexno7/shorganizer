require 'open-uri'

class ShowsController < ApplicationController

  def index
    @shows = Show.all.sort { |x,y| x.name <=> y.name }
    @upcoming_episodes = Episode.upcoming(Date.today).order(:air_date, :air_time).first(10)
    episode_result = Episode.week_view(Episode.view_start,Episode.view_end).order(:air_date, :air_time)
    @episode_hash = {}
    (Episode.view_start..Episode.view_end).each { |day| @episode_hash[day] = [] }
    episode_result.each do |ep|
      @episode_hash[ep.air_date].push(ep)
    end
  end
  
  def new
    @show = Show.new
  end
  
  def create
    @show = Show.new(show_params)    
    if populate_episodes(@show)
      redirect_to @show
    else
      render 'new'
    end
  end
  
  def invalidate
    show = Show.find(params[:id])    
    if invalidate_episodes(show)
      redirect_to show_episodes_path(show)
    else
      render 'new'
    end
  end
  
  def invalidate_all
    Show.all.each do |show|
      invalidate_episodes(show)
    end
  end
  
  def show
    @show = Show.find(params[:id])
  end
  
  def edit
    @show = Show.find(params[:id])
  end
  
  def update
    @show = Show.find(params[:id])
    if @show.update(show_params)
      redirect_to :back
    else
      render 'edit'
    end
  end
  
  def destroy
    @show = Show.find(params[:id])
    @show.destroy
    redirect_to shows_path
  end
  
  private
    def show_params
      params.require(:show).permit(:name, :watch_url, :scrape_url, :genre,
                                   :episodes_attributes => [:id, :title, :no, :air_date, :air_time,
                                                            :season, :channel, :watched, :show])
    end
    
    # Scrapes a Wiki page with episode information
    def scrape_wiki(url)
      # Download Wiki Page
      page = Nokogiri::HTML(open(url))
      
      # Find tables with 'mw-content-ltr' class
      tables = page.xpath("//*/div/div/div[@class='mw-content-ltr']/table")

      tables_with_eps = Array.new
      headers_pos = Array.new

      # Search for 'Title', 'No' and 'Original air date' column headers
      # and save their location if the table has an 'Original air date' column
      tables.each do |table|
        i = 0
        is_eps_table = false
        headers = Hash.new
        table.xpath("./tr[1]/th").each do |th|
          if /(T|t)itle/ =~ th.text
            headers[:title] = i
          elsif /(N|n)o\./ =~ th.text
            unless /(N|n)o\. in (S|s)eries/ =~ th.text
              headers[:no] = i
            end
          elsif /(O|o)riginal (A|a)ir\s?(D|d)ate/ =~ th.text
            is_eps_table = true
            headers[:oad] = i
          end
          i += 1
        end
        if is_eps_table
          tables_with_eps << table
          headers_pos << headers
        end
      end
      
      # Extract the season name, episode number, ep title, and original air
      # date from each table and store in a hash of season hashes (containing
      # episode info
      seasons = Hash.new
      (0...tables_with_eps.size).each do |i|
        season_tmp = tables_with_eps[i].xpath("preceding-sibling::*[self::h6 or self::h5 or self::h4 or self::h3 or self::h2 or self::h1][1]/span[@class='mw-headline']")
        if season_tmp.empty?
          season_tmp = tables_with_eps[i].xpath("preceding-sibling::h2[1]/span[@class='mw-headline']")
        end
        season_name = season_tmp.text
        rows = tables_with_eps[i].css("tr.vevent")
        season = Hash.new
        rows.each do |row|
          columns = row.xpath("child::*")
          /(<.*?>)*"?(.*?)"?</.match(columns[headers_pos[i][:no]].to_s)
          no = $2
          if columns[headers_pos[i][:title]].xpath("child::a").empty?
            /"*([^"]+)"*/.match(columns[headers_pos[i][:title]].text)
            title = $1
          else
            /(.*?)$/.match(columns[headers_pos[i][:title]].xpath("child::a").text)
            title = $1
          end
          /(<.*?>)*"?(.*?)"?</.match(columns[headers_pos[i][:oad]].to_s)
          oad = $2
          season[no] = { :title => title, :oad => oad }
        end
        seasons[season_name] = season
      end

      return seasons
    end

    def invalidate_episodes(show)
      # Scrape URL for Episodes and prevent save if crash occurs
      ActiveRecord::Base.transaction do
        
        show.episodes.destroy_all
      # Save show and scraped episodes
      # Use ActiveRecord::Base.transaction to commit only once at the end
      
        if show.save
          seasons = scrape_wiki(show.scrape_url)
          seasons.keys.each do |season|
            seasons[season].keys.each do |no|
              ep = Episode.new(:title => seasons[season][no][:title], :no => no, 
                          :air_date => seasons[season][no][:oad], :air_time => nil, 
                          :season => season, :channel => nil, :watched => false, 
                          :show => show)
              ep.save
            end
          end
        else
          return false
        end
      end
      return true
    end
end
