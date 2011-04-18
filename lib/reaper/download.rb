require "mechanize"
require "require_all"
require_rel "providers"

class Download

  attr_reader :anime, :type, :ep, :download_url

  include Animecrazy::Download
  include Animea::Download

  def initialize anime, ep = nil, link_regex = nil, downloader = nil
    @anime = anime
    @ep = ep
    @link_regex = link_regex
    @downloader = downloader
    @type = case ep
            when Array, Range
              :multi
            else
              :single
            end
  end

  def reap
    case @type
    when :multi
      @ep.each do |ep|
        self.stage ep
        if @download_url
          self.download
        else
          puts "No download url found"
        end
      end
    when :single
      self.stage @ep
      if @download_url
        self.download
      else
        puts "No download url found"
      end
    else
      raise "Bad download type"
    end
  end

  def stage ep
    providers = (self.class.included_modules - Object.ancestors).map{|p| p.to_s.split("::").first}
    providers.each do |provider|
      begin
        self.send("stage_from_#{provider.to_s.downcase}", ep) unless self.download_url
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
        puts "FAIL #{provider}"
      end
    end
  end

  def download
    if @downloader
      puts "Hand link(s) to downloader"
      puts "This could be handled similar to providers"
    else
     puts @download_url
    end
  end

  def regex_or_user_input dls
    if @link_regex
      regex_links = dls.select{|link| link.text =~ @link_regex}
      case regex_links.size
      when 0
        return user_input dls
      when 1
        return regex_links.first
      else
        return user_input regex_links
      end
    else
      user_input dls
    end
  end

  def user_input dls
    dls.each_with_index do |link, index|
      puts index.to_s + "\t" + link.text.strip
    end
    puts "Enter n to go to next provider if any."
    puts "Enter number of download link to use: "
    choice = STDIN.gets
    return if choice.strip.downcase == "n"
    dls[choice.to_i]
  end

end
