require "TaoBaoApi/version"
require 'nokogiri'  
require 'open-uri'

module TaoBaoApi
  class	Good
  	def get_info url
  		return nil if !url

		doc = Nokogiri::HTML(open(url)) 
		doc.encoding = 'utf-8'

		title = title_fiter(doc.css('.tb-detail-hd').first.text.strip)

		if url.include? 'taobao'
			price = doc.css('em.tb-rmb-num').first.text
			img = doc.css('#J_ImgBooth').first.attr('data-src')
		elsif url.include? 'tmall'
			price = doc.css('.J_originalPrice').first.text.strip
			img = doc.css('#J_ImgBooth').first.attr('src')
		else
			return 'undefined'
		end

		{:title => title,
			:price => price,
			:img => img}
  	end

  	private
	  def title_fiter(title)
		filter_char = ["\n","\r","\t",' ']

		filter_char.each do |s|
			title = title.gsub(s,'')
		end

		title
	  end
  end	
end
