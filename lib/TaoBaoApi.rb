require "TaoBaoApi/version"
require 'nokogiri'  
require 'open-uri'

module TaoBaoApi
	class  Good
		def get_info url
			return 'good_url_nil' if url.nil?

		  doc = Nokogiri::HTML(open(url)) 
		  doc.encoding = 'utf-8'

		  begin
			  title = doc.css('.tb-detail-hd').first.text
		  rescue NoMethodError
			  return 'good_not_exists'
		  end

		  title = title_fiter(title.strip)

		  if url.include? 'taobao'
			  price = doc.css('em.tb-rmb-num').first.text
			  img = doc.css('#J_ImgBooth').first.attr('data-src')
		  elsif url.include? 'tmall'
			  price = doc.css('.J_originalPrice').first.text.strip
			  img = doc.css('#J_ImgBooth').first.attr('src')
		  else
			  return 'good_url_is_not_taobao'
		  end

		  {:title => title,
			  :price => price,
			  :img => img}
  	end

  	private
	    def title_fiter(title)
		    title = title.split("\r\n")[0]

		    filter_char = ["\n","\r","\t",' ']
		    filter_char.each do |s|
			    title = title.gsub(s,'')
		    end

		    title
	    end
  end
end