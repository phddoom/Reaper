require "clamp"
require "mechanize"

class IndexCommand < Clamp::Command

  parameter "[QUERY]", "Search the index using the given string."

  parameter "[TYPE]", "Filter search by type of anime (anime,ova,movie)"

  def execute
    agent = Mechanize.new
    agent.user_agent_alias = "Linux Firefox"
    page = agent.get(SITE + "anime-index/")
    uls = page.search(".truindexlist")
    uls.each do |ul|
      lis = ul.search("li")
      lis.each do |li|
        puts li.text if (!query || li.text.include?(query)) && (!type || li.text.include?(type))
      end
    end
  end
end
