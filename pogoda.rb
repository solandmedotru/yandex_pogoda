require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

# <city id="27581" region="11156" head="0" type="2" country="Россия" part="Чувашия" resort="0" climate="">Чебоксары</city>
# Формат ссылки export.yandex.ru/weather-ng/forecasts/27581.xml

puts "Введите ID города и нажмите Enter. По умолчанию будет 27581 (Чебоксары, Россия)."

def city
  city_id = gets.chomp.to_i
  if city_id == 0
    27581
    else city_id
  end
end



uri = URI.parse("http://export.yandex.ru/weather-ng/forecasts/#{city}.xml")

response = Net::HTTP.get_response(uri)

doc = REXML::Document.new(response.body)

city_name = doc.root.attributes['exactname']
time = Time.now
observation_time = doc.root.elements['fact/observation_time'].text
temperature = doc.root.elements['fact/temperature'].text
pogoda = doc.root.elements['fact/weather_type'].text
wind = doc.root.elements['fact/wind_speed'].text

puts "Сейчас #{time.strftime("%d/%m/%Y %k:%M")}, погода в городе #{city_name}"
puts "#{temperature} градус(ов), #{pogoda}, ветер #{wind} м/с по данным на #{observation_time}"
puts
doc.root.elements.each('day') do |element|
  puts 'Прогноз на'
  puts DateTime.parse(element.attributes['date']).strftime("%d/%m/%Y")
  puts "----------------------"

  element.elements.each('day_part') do |element|
    print element.attributes['type']
    print ": "
    puts "#{element.elements['temperature-data/avg'].text} градус(ов), #{element.elements['weather_type'].text}, ветер #{element.elements['wind_speed'].text} м/с"
  end
  puts "----------------------"
  puts
end
