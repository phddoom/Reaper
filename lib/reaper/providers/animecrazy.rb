module Animecrazy

  SITE = "http://www.animecrazy.net/"

  module IndexCommand

    def get_index_from_animecrazy query = nil, type = nil
      agent = Mechanize.new
      animecrazy_index = []
      agent.user_agent_alias = "Linux Firefox"
      page = agent.get(SITE + "anime-index/")
      uls = page.search(".truindexlist")
      uls.each do |ul|
        lis = ul.search("li")
        lis.each do |li|
          animecrazy_index << li.text if (!query || li.text.include?(query)) && (!type || li.text.include?(type))
        end
      end
      animecrazy_index
    end

  end

  module Anime
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
end
