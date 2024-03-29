citopics
========

Tokyo Metropolitan College of Industrial Technology の Topics ( http://www.metro-cit.ac.jp/ ) から1つずつ情報を取得し、RSS化して保存します。
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
+ rss/maker による RSS 化 (最大 7 件)
+ シンボリックリンクを追加
+ logger によるログ記録 (logs内に保存)

生成後の RSS について
-----
### ###
+ RSS 2.0 形式で生成されます。
 + 記事タイトル: トピックタイトル
 + 記事内容: カテゴリ名
 + 記事URL : トピックリンク先
 + 記事日時 : トピック追加日時 + 00:00:00

サーバについて
-----
### ###
+ ``server.rb``を使うと、 Sinatra で RSS を配信 (更新日時の表示) をしてくれます。
+ ```/``` にアクセスされると更新日時とかが出ます。 ```/rss.xml``` にアクセスされると最新のRSSを吐きます。

注意事項
-----
### ###
+ Web サイト側の仕様変更により、以前最大 20 件だった取得件数が最大 7 件となりました。

LICENSE
-----
### ###
+ License file is "LICENSE".
