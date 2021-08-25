require 'open-uri'
require 'nokogiri'

page = 0
url = "https://www.hinatazaka46.com/s/official/diary/member/list?ima=0000&page=#{page}&ct=17&cd=member"
@ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"

charset = nil
html = open(url, "user-agent"=>@ua) do |f|
  charset = f.charset
  f.read
end
doc = Nokogiri::HTML.parse(html, nil, charset)
body_element = doc.css('.p-blog-group')
img_urls = []
pagenate = doc.css('.p-pager--count')

while !pagenate.at_css('.c-pager__item--next').nil? do
  page = page + 1
  url = "https://www.hinatazaka46.com/s/official/diary/member/list?ima=0000&page=#{page}&ct=17&cd=member"
  html = open(url, "user-agent"=>@ua) do |f|
    charset = f.charset
    f.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)
  body_element = doc.css('.p-blog-group')
  body_element.css('img').each do |img_element|
    img_urls << img_element.attribute('src')&.value
  end
  pagenate = doc.css('.p-pager--count')
  puts "ページ： #{page}"
  sleep 1
end

puts img_urls

sleep 2
begin
  img_urls.each do |img_url|
  file_name = "/Users/esakikota/Desktop/濱岸ひより/#{img_url.split('/')[-5..-1].join('')}"
    open(file_name, 'wb') do |file|
      file.puts(open(URI.parse(img_url),"user-agent"=>@ua).read)
    end
  end
rescue => exception
  puts exception.message
end
