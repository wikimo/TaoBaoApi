require 'TaoBaoApi'

good = TaoBaoApi::Good.new

info  = good.get_info 'http://item.taobao.com/item.htm?id=16434110195'

p info
