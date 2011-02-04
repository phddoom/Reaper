require "clamp"
require "yaml"

class InfoCommand < Clamp::Command

  data_filename = ENV["XDG_DATA_HOME"] + "/"+ "reaper.yml"
  has_data_file = File.exists? data_filename

  parameter "ANIME", "Name of anime to retrieve info about" do |name|
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

  def execute
    puts "Name: #{anime.name}"
    puts "# of eps: #{anime.number_of_episodes.to_s}"
    puts "Desc: \n\t#{anime.desc.join("\n\t")}"
  end

end
