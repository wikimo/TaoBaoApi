require File.join(File.dirname(__FILE__), 'lib', 'TaoBaoApi')

# url  = 'http://item.taobao.com/item.htm?id=16434110195'
# url = 'http://detail.tmall.com/item.htm?id=35513218520'
# url = 'http://item.taobao.com/item.htm?spm=a1z09.5.0.0.x2gUPA&id=16718391999'
# url = 'http://item.taobao.com/item.htm?id=20132398689'
# url ='http://detail.tmall.com/item.htm?id=9153380600'
url ='http://detail.tmall.com/item.htm?id=17350703554&spm=a1z09.5.0.0.PCBxNl'
# url = 'http://item.taobao.com/item.htm?spm=0.0.0.0.g5BwfC&id=18769075753'
good = TaoBaoApi::Good.new url

info  = good.get_info

p info