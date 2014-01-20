require File.join(File.dirname(__FILE__), 'lib', 'TaoBaoApi')

good = TaoBaoApi::Good.new

url  = 'http://detail.tmall.com/item.htm?id=35576507007'
info  = good.get_info url

p info
