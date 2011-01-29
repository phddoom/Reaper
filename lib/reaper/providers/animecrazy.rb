module Animecrazy

  SITE = "http://www.animecrazy.net/"

  private

  def name_url
    @name.gsub(" ", "-")
  end


  def get_number_of_episodes_from_animecrazy
    agent = Mechanize.new
    url = SITE + "/#{self.name_url + "-anime"}"
    anime_page = agent.get url
    anime_page.search(".epCount p").first.text =~ /Episodes: (\d*)/
    $1.to_i
  end

  def get_description_from_animecrazy
    agent = Mechanize.new
    url = SITE + "/#{self.name_url + "-anime"}"
    anime_page = agent.get url
    anime_page.search(".desc").text.gsub("Description:", "").strip
  end

end
