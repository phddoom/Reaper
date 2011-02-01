module Animea

  SITE = "http://www.animea.net/"

  module IndexCommand

    def get_index_from_animea query = nil, type = nil
      agent = Mechanize.new
      animea_index = []
      agent.user_agent_alias = "Linux Firefox"
      page = agent.get(SITE + "series")
      while page
        animea_index << page.search(".complete_anime, .incomplete_anime").map{|a| a.text.strip}
        next_page = page.link_with(:text => "Next")
        if next_page
          page = next_page.click
        else
          page = nil
        end
      end
      animea_index
    end

  end
end
