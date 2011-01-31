require "clamp"
require "mechanize"
require "require_all"
require_rel "providers"

class IndexCommand < Clamp::Command

  extend Animecrazy::IndexCommand

  parameter "[QUERY]", "Search the index using the given string."

  parameter "[TYPE]", "Filter search by type of anime (anime,ova,movie)"

  def execute
    index = IndexCommand.get_index_from_animecrazy query, type
    puts index
  end
end
