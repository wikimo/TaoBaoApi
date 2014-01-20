require "TaoBaoApi/version"
require 'nokogiri'  
require 'open-uri'

module TaoBaoApi
  class Good
    def get_info url
      return 'good_url_nil' if url.nil?

      url = url_filter(url)
      doc = Nokogiri::HTML(open(url)) 
      doc.encoding = 'utf-8'
  
      begin
        title = doc.css('title').first.text.split('-').first.strip
      rescue NoMethodError
        return 'good_not_exists'
      end

      images = []
      if url.include? 'taobao'
        price = doc.css('em.tb-rmb-num').first.text
        img_src = 'data-src'
      elsif url.include? 'tmall'
        price = doc.css('.J_originalPrice').first.text.strip
        img_src = 'src'
      else
        return 'good_url_is_not_taobao'
      end

      doc.css('#J_UlThumb').first.css('img').each do |img|
        img = img.attr(img_src)
        images << image_filter(img)
      end

      {:title => title,
        :price => price,
        :images => images,
        :url => url}
    end

  private
    def image_filter(imgUrl)
      "#{imgUrl.split('.jpg').first}.jpg"
    end

    def url_filter(url)
      if url.include?'s.click.taobao.com'
        refer = open(url).base_uri.to_s.split('URL:').first
        open(URI.unescape(refer.split('tu=')[1]),"Referer" => refer).base_uri.to_s.split('&ali_trackid=')[0]
      else
        url = url.split('/item.htm?').first + '/item.htm?id=' + url.split('id=').last.split('&').first
      end
    end

  end
end