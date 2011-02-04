require "clamp"
require "mechanize"
require "require_all"
require_rel "providers"

class IndexCommand < Clamp::Command

  extend Animecrazy::IndexCommand
  extend Animea::IndexCommand

  parameter "[QUERY]", "Search the index using the given string."

  parameter "[TYPE]", "Filter search by type of anime (anime,ova,movie)"

  def execute
    animecrazy_index = IndexCommand.get_index_from_animecrazy query, type
    animea_index = IndexCommand.get_index_from_animea query, type
    puts animea_index.map{|a| "Animea: " + a}
    puts animecrazy_index.map{|a| "Animecrazy: " + a}
  end
end
