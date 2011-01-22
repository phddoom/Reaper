require "mechanize"

class Download
  attr_reader :anime, :type, :ep

  def initialize anime, ep = nil, link_regex = nil
    @anime = anime
    @ep = ep
    @link_regex = link_regex
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
    agent = Mechanize.new
    url = SITE + "/#{@anime.name_url + "-episode"}-#{ep}/"
    episode_page = agent.get url
    download_links = episode_page.links_with(:text => /download/i)
    download_links.delete_if{|link| link.text =~ /broken|\+/i}
    download_link = regex_or_user_input download_links
    download_link.attributes[:onclick] =~ /download\/(\d*)/
    @download_service_url = "http://www.animecrazy.net/mirrordownload/" + $1
  end

  def download
    agent = Mechanize.new do |a|
      a.follow_meta_refresh = true
    end
    download_page = agent.get @download_service_url
    puts download_page.uri
    case download_page.uri.to_s
    when /megaupload/i
      download_from_megaupload download_page, agent
    when /mediafire/i
      download_from_mediafire download_page, agent
    else
      puts "Cannot download from that provider"
    end
  end

  def download_from_megaupload download_page, agent
    megaupload_link = download_page.link_with(:href => /files/)
    puts megaupload_link.href
    puts "Getting Response ..."
    episode = agent.get URI.encode(megaupload_link.href, /\[|\]/)
    puts "Done"
    puts "Saving File to Disk ..."
    episode.save_as ""+ megaupload_link.href.split("/").last
    puts "Done"
    puts "Exiting"
  end

  def download_from_mediafire download_page, agent
    mediafire_link = download_page.uri.to_s + "/autodisable.php/" + download_page.title.to_s.gsub(" ", "+")
    puts mediafire_link
    puts "Getting Response ..."
    episode = agent.get URI.encode(mediafire_link, /\[|\]/)
    puts "Done"
    puts "Saving File to Disk ..."
    episode.save_as "" + mediafire_link.split("/").last
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
