# AmbientIot

AmbientIotは Ambient ( https://ambidata.io ) にアクセスするためのGemライブラリーです。  
Ambientはアップロードされたデータをグラフとして表示してくれるサービスでAmbientData Inc. が提供しています。  

AmbientIotは [ambient-python-lib](https://github.com/AmbientDataInc/ambient-python-lib)を基にRuby用に作ったものです。

## インストール

Gemfileに下の行を追加します。

```ruby
gem 'ambient_iot'
```

そして bundle コマンドを実行します。

    $ bundle

またはgemコマンドでインストールします。

    $ gem install ambient_iot

## 使い方

始めにAmbientのアカウントを取得する必要があります。  
続いてチャンネルを作成します。  
チャンネルを作成するとチャンネルID、ライトキー、リードキーが得られます。

### データを送信する場合:

Ambientのデータはd1からd8のキーでデータ系列を表現します。  
データを与える場合Hashデータとして渡します。

    require 'ambient_iot'

    channel_id = 1234               # チャンネル IDをセットします。
    write_key = "abc.."             # チャンネルのライトキーをセットします。
    client = AmbientIot::Client.new channel_id, write_key:write_key # クライアント生成

    client << { d1:1, d2:2, d3:3}   # データを追加します。
    client.write                    # データを送信します

時刻はデータ追加時に自動で設定されます。  
時刻を追加したくない場合は append_timestamp にfalseを設定します。  

    client.append_timestamp = false

この場合はAmbientサイト上で時刻が設定されます。


### 送信済みの最新のデータを取得する場合:

    require 'ambient_iot'

    channel_id = 1234               # チャンネル IDをセットします。
    read_key = "abc.."              # チャンネルのリードキーをセットします。
    client = AmbientIot::Client.new channel_id, read_key:read_key # クライアント生成

    client.read                     # 送信済みのデータを読み込みます
    # => [
    #      {:d1=>1, :d2=>2, :d3=>3, :created=>2018-04-27 23:13:18 +0900},
    #        .
    #      {:d1=>2, :d2=>1, :created=>2018-04-24 00:00:00 +0900}
    #    ]

    # 特定の日付のデータを取得する場合
    client.read date:Time.new(2018, 4, 26)

    # 特定の範囲のデータを取得する場合
    client.read start:Time.new(2018, 4, 20), end:Time.new(2018, 4, 26)

    # データ数を指定する場合
    client.read n:1, step:5

### チャンネル情報を取得する場合

    require 'ambient_iot'

    channel_id = 1234               # チャンネル IDをセットします。
    read_key = "abc.."              # チャンネルのリードキーをセットします。
    client = AmbientIot::Client.new channel_id, read_key:read_key # クライアント生成

    client.info                     ＃ 情報取得
    # => {:ch=>"1234", :user=>"1234", :created=>2018-04-23 22:59:06 +0900, :modified=>2018-04-27 23:23:59 +0900, :lastpost=>2018-04-27 23:13:25 +0900, :charts=>1, :chName=>"室温", :chDesc=>"部屋の温度", :d1=>{:name=>"データ1", :color=>"1"}, :d2=>{:name=>"データ2", :color=>"2"}, :d3=>{:name=>"", :color=>"3"}, :d4=>{:name=>"", :color=>"4"}, :d5=>{:name=>"", :color=>"5"}, :d6=>{:name=>"", :color=>"6"}, :d7=>{:name=>"", :color=>"7"}, :d8=>{:name=>"", :color=>"8"}, :public=>false, :showlocation=>false, :photoid=>"", :phototitle=>"", :dataperday=>1}


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ito-soft-design/ambient_iot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AmbientIot project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ito-soft-design/ambient_iot/blob/master/CODE_OF_CONDUCT.md).
