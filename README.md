citopics
========
Tokyo Metropolitan College of Industrial Technology の Topics ( http://www.metro-cit.ac.jp/topics/index.html ) から1つずつ情報を取得し、RSS化して保存します。
また、Sinatraによる RSS 提供サーバ風のものも付いています。

使い方
-----
### ###
    $ ruby get.rb
あとは自動的に rss ディレクトリ内に RSS が日時順に保存されます。    
また、カレントディレクトリにも rss.xml で最新の RSS にシンボリックリンクが貼られているはずです。

仕様
----
### ###
+ open-uri による HTML の取得
+ タイトル,URL,日付を nokogiri でパース
+ rss/maker による RSS 化
+ シンボリックリンクを追加
+ logger によるログ記録 (logs内に保存)

サーバについて
-----
### ###
+ ``server.rb``を使うと、 Sinatra で RSS を配信 (更新日時の表示) をしてくれます。
+ ```/``` にアクセスされると更新日時とかが出ます。 ```/rss.xml``` にアクセスされると最新のRSSを吐きます。
