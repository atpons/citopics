# -*- coding: utf-8 -*-
require "sinatra"

get "/" do
  file = File.lstat("rss.xml").mtime
  @ls = file
  erb :index
end

get "/rss.xml" do
content_type :xml
send_file "rss.xml"
end
