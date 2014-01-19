require "TaoBaoApi/version"
require 'nokogiri'  
require 'open-uri'

module TaoBaoApi
  class Good
    def get_info url
      return 'good_url_nil' if url.nil?

      url = url_clean(url)

      doc = Nokogiri::HTML(open(url)) 
      doc.encoding = 'utf-8'

      begin
        title = doc.css('title').first.text
      rescue NoMethodError
        return 'good_not_exists'
      end

      title = title_filter(title)

      images = Array.new()

      if url.include? 'taobao'
        price = doc.css('em.tb-rmb-num').first.text
        doc.css('#J_UlThumb').first.css('img').each do |img|
          img = img.attr('data-src')
          images.push(image_filter(img))
        end
      elsif url.include? 'tmall'
        price = doc.css('.J_originalPrice').first.text.strip
        doc.css('#J_UlThumb').first.css('img').each do |img|
          img = img.attr('src')
          images.push(image_filter(img))
        end
      else
        return 'good_url_is_not_taobao'
      end

      {:title => title,
        :price => price,
        :img => images,
        :url => url}
    end

  private
    def title_filter(title)
      title = title.split("\r\n")[0]
      title = title.split("-")[0]

      filter_char = ["\n","\r","\t"]
      filter_char.each do |s|
        title = title.gsub(s,'')
      end

      title
    end

    def image_filter(imgUrl)
      imgUrl = imgUrl.split('.jpg')[0] + '.jpg'
    end

    def url_clean(url)
      if url.include?'s.click.taobao.com'
        refer = open(url).base_uri.to_s.split('URL:')[0]
        open(URI.unescape(refer.split('tu=')[1]),"Referer" => refer).base_uri.to_s.split('&ali_trackid=')[0]
      else
        url = url.split('/item.htm?')[0] + '/item.htm?id=' + url.split('id=')[1].split('&')[0]
      end
    end

  end
end