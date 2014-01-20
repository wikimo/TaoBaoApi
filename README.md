# TaoBaoApi

通过淘宝或天猫商品链接获取商品信息，商品信息包括标题、价格、图片。

## 环境说明
ruby 1.9.3  2.0.0未测试，可能会有问题

## 安装方法

在 Gemfile 文件中加入以下代码:

    gem "TaoBaoApi"

然后执行:

    $ bundle

或者你可以通过 gem installl 直接安装:

    $ gem install TaoBaoApi

## 使用方法

```ruby

require 'TaoBaoApi'

good = TaoBaoApi::Good.new

info  = good.get_info 'http://item.taobao.com/item.htm?id=16434110195'

p info #hash format,{:title => xxx, :price => xxx, :img => xxx, :url => url}

```
测试文件见test.rb