class Localizations
  attr_reader :languages

  def initialize(data)
    data = data.map do |a|
      a.map do |el| el.strip end
    end
    @languages = data[0]
    hash = Hash[data.transpose.map do |a| [ a[0], a[1..-1] ] end]
    keys = hash.delete("keys")
    @translations = Hash[hash.map do |k, v|
      [k, Hash[keys.zip(v)]]
    end]
  end

  def for_lang(lang)
    if @languages.include? lang
      @translations[lang]
    else
      @translations["en"]
    end
  end
end