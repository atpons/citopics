# -*- coding: utf-8 -*-
require "nokogiri"
require 'open-uri'
require 'nkf'
require 'rss/maker'
require "logger"

puts "[CITopics]"
logdate = Time.now
log = Logger.new("logs/rss.log" , "daily")
log.level = Logger::INFO

log.info("[CITopics]")

num = []
title =[]
addr = []
cat = []


#gethtml
log.progname="gethtml"
log.info("HTML Opening...")
begin
  doc = Nokogiri::HTML(open('http://www.metro-cit.ac.jp', 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)').read)
rescue => r
  log.fatal("HTML Open Error!")
  log.fatal(r)
  puts r
else
  log.info("HTML Opened!")
end



#titlescrap 
log.progname="titlescrap"
log.info("Extract titles from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td/a').children.each do |c|
    title.push(c)
    log.info("Analyzed title : " + c)
  end
rescue => e
  log.fatal("Extract titles error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extract titles from HTML!")
end

#categoryscrap
log.progname="catgoryscrap"
log.info("Extract categories from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td[@class="icon"]/img/@alt').each do |c|
    cat.push(c)
    log.info("Analyzed category : " + c)
  end
rescue => e
  log.fatal("Extract categories error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extract categories from HTML!")
end

#urlscrap
log.progname="urlscrap"
log.info("Extracting URLs from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td/a/@href').each do |d|
    case d
    when /^\.\.\// 
      url = d.to_s.gsub("../", "http://www.metro-cit.ac.jp/")
      log.info("Fixed link. [Type:URL starts with parents directory] [URL: " + url +"]")
    when /^http/
      url = d
      log.info("Not fixed link. [Type:URL starts with http] [URL: " + url +"]")
    when /^https/
      url = d
      log.info("Not fixed link. [Type:URL starts with https] [URL: " + url +"]")
    else
      url = d.to_s.insert(0, "http://www.metro-cit.ac.jp")
      log.info("Fixed link. [Type:URL starts with current directory] [URL: " + url +"]")
    end
    addr.push(url)
  end
rescue => e
  log.fatal("Extracting titles error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extracting URLs from HTML!")
end

#datescrap
log.progname="datescrap"
log.info("Extracting dates from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td[@class="dates"]').children.each do |cld|
    num.push(cld)
  end
rescue => e
  log.fatal("Extracting dates error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extracting dates from HTML!")
end

#dateconv
numcv = []
log.progname="dateconv"
log.info("Converting dates...")
begin
  num.each do |nn|
    n2 = nn.to_s
    b = n2.split(".")
    numcv.push(b)
  end
rescue => r
  log.fatal("Converting dates error!")
  log.fatal(r)
  puts r
else
  log.info("Finished converting dates!")
end

#makerss
log.progname="makerss"
log.info("Making RSS...")
begin
  rss = RSS::Maker.make("2.0") do |rss|
    rss.channel.about = "http://www.metro-cit.ac.jp/"
    rss.channel.title = "TMCIT Topics (Unofficial)"
    rss.channel.description = "自動的に取得したもので、非公式ですので掲載内容について一切の責任を負いません。 Made by citopics"
    rss.channel.link = "http://www.metro-cit.ac.jp/topics/index.html"
    rss.channel.language = "ja"
    rss.items.do_sort = true
    rss.items.max_size = 7
    7.times { |i|
      i = rss.items.new_item
      i.title = title.shift
      i.description =  cat.shift
      i.link = addr.shift
      nums = numcv.shift
      i.date = Time.local(nums.shift.to_i, nums.shift.to_i, nums.shift.to_i, 0, 0, 0)
    }
  end
rescue => r
  log.fatal("Making RSS error!")
  log.fatal(r)
  puts r
else
  log.info("Finished making dates!")
end

#saverss
log.progname="saverss"
log.info("Saving RSS...")
begin
  time = Time.now
  yy = time.year.to_s
  mm = time.month.to_s
  dd = time.day.to_s
  hh = time.hour.to_s
  min = time.min.to_s
  ss = time.sec.to_s
  times = yy + "_" + mm + "_" + dd + "_" + hh + "_" + min + "_" + ss
  FileUtils.cd("rss")
  open(times + ".xml", "w"){|f| f.write rss }
  filename = times + ".xml"
  ln = system("ln -f -s rss/" + filename + " " + "../rss.xml")
  ln2 = system("ln -f -s rss/" + filename + " " + "../public")
rescue => r
  log.fatal("Making RSS error!")
  log.fatal(r)
  puts r
else
  log.info("Finished saving RSS!")
end

#finished
log.progname=""
log.info("Finished all steps.")


log.progname="gethtml"
log.info("HTML Opening...")
begin
  doc = Nokogiri::HTML(open('http://www.metro-cit.ac.jp', 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)').read)
rescue => r
  log.fatal("HTML Open Error!")
  log.fatal(r)
  puts r
else
  log.info("HTML Opened!")
end

#titlescrap 
log.progname="titlescrap"
log.info("Extract titles from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td/a').children.each do |c|
    title.push(c)
    log.info("Analyzed title : " + c)
  end
rescue => e
  log.fatal("Extract titles error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extract titles from HTML!")
end

#urlscrap
log.progname="urlscrap"
log.info("Extracting URLs from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td/a/@href').each do |d|
    case d
    when /^\.\.\// 
      url = d.to_s.gsub("../", "http://www.metro-cit.ac.jp/")
      log.info("Fixed link. [Type:URL starts with parents directory] [URL: " + url +"]")
    when /^http/
      url = d
      log.info("Not fixed link. [Type:URL starts with http] [URL: " + url +"]")
    when /^https/
      url = d
      log.info("Not fixed link. [Type:URL starts with https] [URL: " + url +"]")
    else
      url = d.to_s.insert(0, "http://www.metro-cit.ac.jp")
      log.info("Fixed link. [Type:URL starts with current directory] [URL: " + url +"]")
      agent = Mechanize.new
      agent.get(url)
      puts agent.page.at('//*[@id="main"]/div')
    end
    addr.push(url)
  end
rescue => e
  log.fatal("Extracting titles error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extracting URLs from HTML!")
end

#datescrap
log.progname="datescrap"
log.info("Extracting dates from HTML...")
begin
  doc.xpath('//*[@id="top_main"]/div/div/table/tr/td[@class="dates"]').children.each do |cld|
    num.push(cld)
  end
rescue => e
  log.fatal("Extracting dates error!")
  log.fatal(e)
  puts e
else
  log.info("Finished extracting dates from HTML!")
end

#dateconv
numcv = []
log.progname="dateconv"
log.info("Converting dates...")
begin
  num.each do |nn|
    n2 = nn.to_s
    b = n2.split(".")
    numcv.push(b)
  end
rescue => r
  log.fatal("Converting dates error!")
  log.fatal(r)
  puts r
else
  log.info("Finished converting dates!")
end

#makerss
log.progname="makerss"
log.info("Making RSS...")
begin
  rss = RSS::Maker.make("2.0") do |rss|
    rss.channel.about = "http://www.metro-cit.ac.jp/"
    rss.channel.title = "TMCIT Topics (Unofficial)"
    rss.channel.description = "自動的に取得したもので、非公式ですので掲載内容について一切の責任を負いません。 Made by citopics"
    rss.channel.link = "http://www.metro-cit.ac.jp/topics/index.html"
    rss.channel.language = "ja"
    rss.items.do_sort = true
    rss.items.max_size = 7
    7.times { |i|
      i = rss.items.new_item
      i.title = title.shift
      i.description = 
      i.link = addr.shift
      nums = numcv.shift
      i.date = Time.local(nums.shift.to_i, nums.shift.to_i, nums.shift.to_i, 0, 0, 0)
    }
  end
rescue => r
  log.fatal("Making RSS error!")
  log.fatal(r)
  puts r
else
  log.info("Finished making dates!")
end

#saverss
log.progname="saverss"
log.info("Saving RSS...")
begin
  time = Time.now
  yy = time.year.to_s
  mm = time.month.to_s
  dd = time.day.to_s
  hh = time.hour.to_s
  min = time.min.to_s
  ss = time.sec.to_s
  times = yy + "_" + mm + "_" + dd + "_" + hh + "_" + min + "_" + ss
  FileUtils.cd("rss")
  open(times + ".xml", "w"){|f| f.write rss }
  filename = times + ".xml"
  ln = system("ln -f -s rss/" + filename + " " + "../rss.xml")
  ln2 = system("ln -f -s rss/" + filename + " " + "../public")
rescue => r
  log.fatal("Making RSS error!")
  log.fatal(r)
  puts r
else
  log.info("Finished saving RSS!")
end

#finished
log.progname=""
log.info("Finished all steps.")
