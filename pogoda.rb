require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

# <city id="27581" region="11156" head="0" type="2" country="Россия" part="Чувашия" resort="0" climate="">Чебоксары</city>
# Формат ссылки export.yandex.ru/weather-ng/forecasts/27581.xml

uri = URI.parse('http://export.yandex.ru/weather-ng/forecasts/27581.xml')

response = Net::HTTP.get_response(uri)

doc = REXML::Document.new(response.body)

city_name = doc.root.attributes['exactname']
time = DateTime.now
observation_time = doc.root.elements['fact/observation_time'].text
temperature = doc.root.elements['fact/temperature'].text
pogoda = doc.root.elements['fact/weather_type'].text
wind = doc.root.elements['fact/wind_speed'].text

puts "Сейчас #{time.strftime("%d/%m/%Y %k:%M")}, погода в городе #{city_name}"
puts "#{temperature} градус(ов), #{pogoda}, ветер #{wind} м/с по данным на #{observation_time}"

puts 'Прогноз на'

doc.root.elements.each('day') do |element|
  puts element.attributes['date']
  puts "#{element.elements['day_part/temperature-data/avg'].text} градус(ов), #{element.elements['day_part/weather_type'].text}, ветер #{element.elements['day_part/wind_speed'].text} м/с"

end
