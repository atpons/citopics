# -*- coding: utf-8 -*-
require "sinatra"

b = []

#open("rss.log") {|file|
#  a = file.readlines[0]
#  z = a.to_s
#  b.push(z)
#  }

get "/" do
  file = File.lstat("rss.xml").mtime
  @ls = file
  erb :index
end

get "/rss.xml" do
content_type :xml
send_file "rss.xml"
end
