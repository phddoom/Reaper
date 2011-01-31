require "clamp"

class DownloadCommand < Clamp::Command

  data_filename = ENV["XDG_DATA_HOME"] + "/"+ "reaper.yml"
  has_data_file = File.exists? data_filename

  parameter "[ANIME]", "Name of Anime to download" do |name|
    if has_data_file
      data = YAML.load_file(data_filename)
      if data.has_key?(name)
        data[name]
      else
        data[name] = Anime.new name
        File.open(data_filename, "w") do |f|
          YAML.dump(data,f)
        end
        data[name]
      end
    else
      data = {}
      data[name] = Anime.new name
      File.open(data_filename, "w") do |f|
        YAML.dump(data,f)
      end
      data[name]
    end
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

  parameter "[DOWNLOADER]", "Specify downloader to send links to"

  def execute
    download = Download.new anime, episodes, regex, downloader
    download.reap
  end
end
