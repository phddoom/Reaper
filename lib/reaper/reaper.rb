require "clamp"
require "reaper/anime"
require "reaper/download"
require "reaper/index_command"
require "reaper/info_command"
require "reaper/download_command"

SITE = "http://www.animecrazy.net/"
class Reaper < Clamp::Command

  subcommand "index", "List names of anime", IndexCommand

  subcommand "info", "Print information about given anime", InfoCommand

  subcommand "download", "Download Anime", DownloadCommand
end
