require "TaoBaoApi/version"
require 'nokogiri'
require 'faraday'
# require 'faraday-cookie_jar'
require 'faraday_middleware'

module TaoBaoApi

  class Good
    def initialize(url)
      @url = url_filter(url)

      if @url.include? 'tmall'
        init_url = 'http://www.tmall.com'
      else
        init_url = 'http://www.taobao.com/'
      end

      @conn = Faraday.new(:url => init_url) do |f|
        f.use FaradayMiddleware::FollowRedirects , limit: 10

        f.request  :url_encoded
        f.adapter  :net_http
        f.headers[:referer] = init_url
        f.headers[:user_agent] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:26.0) Gecko/20100101 Firefox/26.0'
        # f.response :logger
        # f.use :cookie_jar
      end
    end

    def get_info
      return 'good_url_nil' if @url.nil?

      response = @conn.get @url

      doc = Nokogiri::HTML(response.body) 
      doc.encoding = 'utf-8'

      begin
        title = title_filter(doc.css('title').first.text)
      rescue NoMethodError
        return 'good_not_exists'
      end

      images = []
      if @url.include? 'taobao'
        price = price_filter(doc.css('em.tb-rmb-num').first.text)
        img_src = 'data-src'
      elsif @url.include? 'tmall'
        price = price_filter(doc.css('.J_originalPrice').first.text.strip)
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
        :url => @url}
    end

  private
    #小图转大图链接
    def image_filter(img_url)
      img_url  = "#{img_url.split('.jpg').first}.jpg"

      if img_url.include? '60x60'
        img_url = img_url.gsub('60x60','460x460')
      end

      img_url
    end

    def url_filter(url)
      if url.include?'s.click.taobao.com'
        refer = open(url).base_uri.to_s.split('URL:').first
        open(URI.unescape(refer.split('tu=')[1]),"Referer" => refer).base_uri.to_s.split('&ali_trackid=')[0]
      else
        url = url.split('/item.htm?').first + '/item.htm?id=' + url.split('id=').last.split('&').first
      end
    end

    #去除标题空格
    def title_filter(title)
      title = title.split('-').first.strip.gsub(' ','') if !title.nil?
    end

    #格式化16.0 - 18.0 类似这样的价格区间
    def price_filter price
      price = price.split('-').first.strip if !price.nil? && price.include?('-')
    end

  end
end