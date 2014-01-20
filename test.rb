require File.join(File.dirname(__FILE__), 'lib', 'TaoBaoApi')

good = TaoBaoApi::Good.new

info  = good.get_info 'http://item.taobao.com/item.htm?id=36315104957'

p info
