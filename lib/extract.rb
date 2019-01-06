require 'nokogiri'
require 'pandoc-ruby'
require 'sanitize'

class LS
  attr_reader :data

  class NotFound < Exception; end

  def initialize(data)
    @data = data
  end

  def doc
    @doc ||= Nokogiri::HTML(data)
  end

  def sanitize_config
    Sanitize::Config.merge(Sanitize::Config::RELAXED,
      :elements        => Sanitize::Config::RELAXED[:elements] - ['span'] + ['img'],
      :remove_contents => false
    )
  end

  def sanitize(html)
    Sanitize.fragment(html, sanitize_config)
  end

  def title
    raw = doc.css('.LStitle').to_html
    input = sanitize(raw)
    PandocRuby.new(input, :from => :html, :to => :mediawiki).convert.strip
  end

  def purpose
    input = doc.css('.LSsubtitle').to_html
    PandocRuby.new(input, :from => :html, :to => :mediawiki).convert
  end

  def preamble
    subtitle_pos = content.children.find_index do |child|
      child['class'] == "LSsubtitle"
    end

    minspec_pos = content.children.find_index do |child|
      child['class'] == "MinSpecstitle"
    end

    input = content.children[(subtitle_pos+1)...minspec_pos].map do |n|
      n.to_html rescue n.text
    end.join

    PandocRuby.new(input, :from => :html, :to => :mediawiki).convert
  end

  def minspecs
    content_between(minspecs_start, purposes_start)
  end

  def purposes
    content_between(purposes_start, tips_and_traps_start)
  end

  def tips_and_traps
    content_between(tips_and_traps_start, riffs_and_variations_start)
  end

  def riffs_and_variations
    content_between(riffs_and_variations_start, examples_start)
  end

  def examples
    content_between(examples_start, attribution_start)
  end

  def attribution
    content_between(attribution_start, collateral_material_start || -1)
  end

  def collateral_material
    collateral_material_start ? content_between(collateral_material_start, -1) : ""
  end

  def mediawiki
    [
      "## #{title}",
      purpose,
      preamble,
      minspecs,
      purposes,
      tips_and_traps,
      riffs_and_variations,
      examples,
      attribution,
      collateral_material,
    ].reject(&:empty?).join("\n\n")
  end

private
  # def strip_spans(n)
  #   n.children.map |n|
  # end

  def content_between(from, to, heading_first_para: false)
    input = content.children[from...to].map do |n|
      n.to_html rescue n.text
    end.join

    PandocRuby.new(input, :from => :html, :to => :mediawiki).convert
  end

  def minspecs_start
    content.children.find_index do |child|
      child['class'] == "MinSpecstitle"
    end
  end

  def purposes_start
    content.children.find_index do |child|
      child.text == 'WHY? Purposes'
    end or raise "can't find purposes_start"
  end

  def tips_and_traps_start
    content.children.find_index do |child|
      child['class'] == "MinSpecs" && child.text =~ /Tips and Traps/
    end or raise "can't find tips_and_traps_start"
  end

  def riffs_and_variations_start
    content.children.find_index do |child|
      child['class'] == "MinSpecs" && child.text == 'Riffs and Variations'
    end
  end

  def examples_start
    content.children.find_index do |child|
      child.text == 'Examples'
    end
  end

  def attribution_start
    content.children.find_index do |child|
      child.text =~ /Attribution/
    end
  end

  def collateral_material_start
    content.children.find_index do |child|
      child['class'] == "MinSpecs" && child.text =~ /Collateral Material/
    end
  end

  def content
    @content ||= doc.css('#content')
  end

end

def extract(source_file)
  LS.new(source_file)
end

