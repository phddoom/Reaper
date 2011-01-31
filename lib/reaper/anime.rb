require "mechanize"
require "require_all"
require_rel "providers"

class Anime

  include Animecrazy::Anime

  attr_reader :name, :desc, :number_of_episodes

  def initialize name, number_of_episodes = nil, desc = nil
    @name = name
    @number_of_episodes = number_of_episodes || get_number_of_episodes
    @desc = desc || get_desc
  end

  def name_url
    @name.gsub(" ", "-")
  end

  private

  def get_number_of_episodes
    providers = (self.class.included_modules - Object.ancestors).map{|p| p.to_s.split("::").first}
    eps = 0
    providers.each do |provider|
      eps =self.send("get_number_of_episodes_from_#{provider.to_s.downcase}")
    end
    eps
  end

  def get_desc
    providers = (self.class.included_modules - Object.ancestors).map{|p| p.to_s.split("::").first}
    desc = ""
    providers.each do |provider|
      desc = self.send("get_description_from_#{provider.to_s.downcase}")
    end
    desc
  end

end

