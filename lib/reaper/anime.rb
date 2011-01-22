require "mechanize"

class Anime
  attr_reader :name, :desc, :number_of_episodes

  def initialize name, number_of_episodes = nil, desc = nil
    @name = name
    @number_of_episodes = number_of_episodes || get_number_of_episodes
    @desc = desc || get_desc
  end

  def name_url
    @name.gsub(" ", "-")
  end

  private

  def get_number_of_episodes
    agent = Mechanize.new
    url = SITE + "/#{@name.gsub(" ", "-") + "-anime"}"
    anime_page = agent.get url
    anime_page.search(".epCount p").first.text =~ /Episodes: (\d*)/
    $1.to_i
  end

  def get_desc
    agent = Mechanize.new
    url = SITE + "/#{@name.gsub(" ", "-") + "-anime"}"
    anime_page = agent.get url
    anime_page.search(".desc").text.gsub("Description:", "").strip
  end

end

