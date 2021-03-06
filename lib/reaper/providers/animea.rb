module Animea

  SITE = "http://www.animea.net/"

  module Download
    def stage_from_animea ep
      agent = Mechanize.new
      @anime.send(:get_animea_series_page)
      links_page = @anime.animea_series_page.link_with(:text => /#{ep }/).click
      download_link = regex_or_user_input links_page.links_with(:text => /\.com/)
      @download_url = download_link.uri.to_s
    end
  end

  module Anime

    attr_reader :animea_series_page

    private

    def get_animea_series_page
      agent = Mechanize.new
      url = URI.escape("http://www.animea.net/search.html?q=#{@name.downcase.gsub(" ", "+")}")
      page = agent.get url
      url = page.search(".content .cleantable tr a").first.attributes["href"].value
      @animea_series_page = agent.get url
    end

    def get_number_of_episodes_from_animea
      @animea_series_page ||= get_animea_series_page
      eps = @animea_series_page.search(".relatedinformation_box ol :first-child strong").text.to_i
      if eps == 0 || eps.nil?
        eps = @animea_series_page.links_with(:text => /episode \d*/).last.text.split.last.to_i
      end
      eps
    end

    def get_description_from_animea
      @animea_series_page ||= get_animea_series_page
      @animea_series_page.search(".content p").text
    end

  end

  module IndexCommand

    def get_index_from_animea query = nil, type = nil
      agent = Mechanize.new
      animea_index = []
      agent.user_agent_alias = "Linux Firefox"
      page = agent.get(SITE + "series")
      page.encoding = "UTF-8"
      while page
        animea_index += page.search(".complete_anime, .incomplete_anime").map{|a| a.text.strip}
        next_page = page.link_with(:text => "Next")
        if next_page
          page = next_page.click
          page.encoding = "UTF-8"
        else
          page = nil
        end
      end
      eval "animea_index.map! do |a|
        a.encode!('us-ascii', invalid: :replace, undef: :replace, replace: '')
        a.encode!('utf-8')
      end" if RUBY_VERSION == "1.9.2"
      animea_index.select do |anime|
        anime.downcase.include? query.downcase if query
      end if query || type
    end
  end
end
