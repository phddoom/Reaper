require "mechanize"
require "require_all"
require_rel "providers"

class Anime

  include Animecrazy::Anime
  include Animea::Anime

  attr_reader :name, :desc, :number_of_episodes

  def initialize name, number_of_episodes = nil, desc = nil
    @name = name
    @desc = desc || get_desc
    @number_of_episodes = number_of_episodes || get_number_of_episodes
  end

  def name_url
    @name.gsub(" ", "-")
  end

  def to_yaml_properties
    %w{ @name @desc @number_of_episodes }
  end

  private

  def get_number_of_episodes
    providers = (self.class.included_modules - Object.ancestors).map{|p| p.to_s.split("::").first}
    eps = 0
    providers.each do |provider|
      begin
        new_eps = self.send("get_number_of_episodes_from_#{provider.to_s.downcase}")
      rescue
        new_eps = 0
      end
      eps = new_eps if new_eps && new_eps > eps
    end
    eps
  end

  def get_desc
    providers = (self.class.included_modules - Object.ancestors).map{|p| p.to_s.split("::").first}
    desc = []
    providers.each do |provider|
      begin
        desc << "#{provider.upcase}: " + self.send("get_description_from_#{provider.to_s.downcase}").gsub(/(\.|\!|\?) /, "#{$1}\n\t\t")
      rescue
      end
    end
    desc
  end

end

