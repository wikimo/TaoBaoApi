require "TaoBaoApi/version"
require 'nokogiri'
require 'faraday'
require 'faraday_middleware'
require 'json'
require 'open-uri'

module TaoBaoApi

  class Good
    def initialize(url)
      @url_info = filter_url(url)

      @conn = Faraday.new(:url => @init_url) do |f|
        f.use FaradayMiddleware::FollowRedirects , limit: 10

        f.request  :url_encoded
        f.adapter  :net_http
        f.headers[:referer] = @init_url
        f.headers[:user_agent] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:26.0) Gecko/20100101 Firefox/26.0'
        # f.response :logger
        # f.use :cookie_jar
      end if @url_info
    end

    #得到产品信息
    def get_info
      return 'good.url.error' if !@url_info

      response = @conn.get @url_info[:url]

      doc = Nokogiri::HTML(response.body) 
      doc.encoding = 'utf-8'

      #处理标题
      begin
        title = title_filter(doc.css('title').first.text)
      rescue NoMethodError
        return 'good.not.exists'
      end

      #处理价格
      price_info = get_price(@url_info[:id])
      if price_info
        price = price_info[:price]
        promo_price = price_info[:promo_price]
      else
        if @url_info[:url].include? 'tmall'
          price = price_filter(doc.css('.J_originalPrice').first.text.strip)
          promo_price = 0
        else 
          price = price_filter(doc.css('em.tb-rmb-num').first.text)
          promo_price = 0
        end 
      end
      
      #处理图片
      images = []
      doc.css('#J_UlThumb').first.css('img').each do |img|
        img = img.attr('data-src').to_s == '' ? img.attr('src') : img.attr('data-src')
        images << image_filter(img)
      end

      {:title => title,
        :price => price,
        :promo_price => promo_price,
        :images => images,
        :url => @url_info[:url]}
    end

  private
    #小图转大图链接
    def image_filter(img_url)
      img_url  = "#{img_url.split('.jpg').first}.jpg"     
      img_url = img_url.gsub('60x60','460x460') if img_url.include? '60x60'
 
      img_url
    end

    #过滤url得到产品hash
    def filter_url(url)
      ids = /id=(\d+)/.match(url)
      return false if ids.to_a.size == 0

      id = ids.to_a.last
      if url.include? 'tmall'
        url = "http://detail.tmall.com/item.htm?id=#{id}"
        @init_url = 'http://www.tmall.com'
      else
        url = "http://item.taobao.com/item.htm?id=#{id}"
        @init_url = 'http://www.taobao.com'
      end

      {:url => url,:id => id}
    end

    #去除标题空格
    def title_filter(title)
      title = title.split('-').first.strip.gsub(' ','') if !title.nil?
    end

    #促销价获取失败的情况下调用此方法
    def price_filter price
      price = price.split('-').first.strip if !price.nil? && price.include?('-')
    end

    #可获取促销价
    def get_price id
      response = open("http://a.m.tmall.com/ajax/sku.do?item_id=#{id}").read

      begin
        good_json =JSON.parse response
        price_info = good_json['availSKUs'].first.last

        return {:price => price_info['price'].to_s,
          :promo_price =>price_info['promoPrice'].to_s}
      rescue JSON::ParserError
        'get.price.error'
      end  

      false
    end

  end
end