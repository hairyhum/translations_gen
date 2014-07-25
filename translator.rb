require 'csv'
require 'fileutils'
require './localizations.rb'
require 'mustache'

class Translator
  def self.do_translate
    localizations = get_localozations
    FileUtils::rm_rf("./out")
    FileUtils::cp_r("./templates", "./out")
    Dir::glob("./out/**/*") do |file_name|
      if File.directory? file_name
        :ok
      else
        # puts file_name
        lang = template_lang(file_name, localizations)
        localization = localizations.for_lang(lang)
        localize_file(file_name, localization)
      end
    end
  end

  def self.template_lang(file_name, localizations)
    langs = localizations.languages
    langs.select do |lang|
      Regexp.new(lang) =~ file_name
    end.first
  end

  def self.get_localozations
    csv = CSV.read("./localizations.csv")
    Localizations.new(csv)
  end
  def self.localize_file(file_name, localization)
    content = File.read(file_name)
    out = Mustache.render(content, localization)
    File.write(file_name, out)
  end
end

Translator.do_translate