require "mechanize"

class Download

  attr_reader :anime, :type, :ep

  include Animecrazy::Download

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
        self.download
      end
    when :single
      self.stage @ep
      self.download
    else
      raise "Bad download type"
    end
  end

  def stage ep
    providers = (self.class.included_modules - Object.ancestors).map{|p| p.to_s.split("::").first}
    providers.each do |provider|
      self.send("stage_from_#{provider.to_s.downcase}", ep)
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
    unless @link_regex.nil?
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
    puts "Enter number of download link to use: "
    choice = STDIN.gets
    dls[choice.to_i]
  end

end
