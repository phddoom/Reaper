require "clamp"
require "reaper/anime"
require "reaper/download"
require "reaper/index_command"
require "reaper/info_command"

SITE = "http://www.animecrazy.net/"
class Reaper < Clamp::Command

  subcommand "index", "List names of anime", IndexCommand

  subcommand "info", "Print information about given anime", InfoCommand

  subcommand "download", "Download Anime" do
    parameter "[ANIME]", "Name of Anime to download" do |name|
      Anime.new name if name
    end

    parameter "[EPISODES]", "Episodes to download" do |ep|
      if ep.class == String && ep.size > 1 &&!ep.match(/[A-z]|\./)
        ep.split(",").map(&:to_i)
      elsif ep.class == String && ep.size > 1 && ep.match(/\.\./)
        ep = ep.split("..")
        Range.new ep.first.to_i, ep.last.to_i
      elsif ep.size == 1
        ep.to_i
      end
    end

    parameter "[REGEX]", "Regex to select download link" do |regex|
      Regexp.new regex
    end

    def execute
      download = Download.new anime, episodes, regex
      download.reap
    end
  end
end
