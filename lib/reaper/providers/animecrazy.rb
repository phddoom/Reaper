module Animecrazy

  SITE = "http://www.animecrazy.net/"

  module Download

    def stage_from_animecrazy ep
      agent = Mechanize.new
      url = SITE + "/#{@anime.name_url + "-episode"}-#{ep}/"
      episode_page = agent.get url
      download_links = episode_page.links_with(:text => /download/i)
      download_links.delete_if{|link| link.text =~ /broken|\+/i}
      download_link = regex_or_user_input download_links
      download_link.attributes[:onclick] =~ /download\/(\d*)/
      download_service_url = "http://www.animecrazy.net/mirrordownload/" + $1
      download_page = agent.get download_service_url
      @download_url = download_page.uri
    end

  end

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
