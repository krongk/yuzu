require 'nokogiri'
require 'open-uri'

namespace :forager do
  namespace :wuba do

    #link: http://qy.58.com/9874515439110/
    # opt = {region_id: 1, city_id: 2, district_id: 2}
    def extract_shop(link, opt = {})
      source = 'wuba'
      source_url = link
      title = nil
      detail_address = nil
      contact_name = nil
      mobile_phone_url = nil
      email_url = nil
      website = nil
      content = nil
      picture_urls = [] #can not fetch pictures

      page = Nokogiri::HTML(open(link))
      title = page.css('h1').text
      detail_address = page.css('td.adress span').text if page.css('td.adress span')

      trs = page.css('div.basicMsg table tr')
      if trs.size == 5
        contact_name = trs[2].css('td')[0].text
        mobile_phone_url = trs[2].css('td').at_css('img')['src'] if trs[2].css('td').at_css('img')
        email_link = trs[3].css('td').at_css('img')['src'] if trs[3].css('td').at_css('img')
        website = trs[3].css('td').at_css('a')['href'] if trs[3].css('td').at_css('a')
      end
      content = page.css('div.compIntro').text

      shop = Shop.find_or_initialize_by(title: title, source: source, source_url: source_url)
      shop.city_id = opt[:region_id] if shop.city_id.blank?
      shop.city_id = opt[:city_id] if shop.city_id.blank?
      shop.city_id = opt[:district_id] if shop.city_id.blank?
      shop.detail_address = detail_address if shop.detail_address.blank?
      shop.contact_name = contact_name if shop.contact_name.blank?
      shop.mobile_phone_url = mobile_phone_url if shop.mobile_phone_url.blank?
      shop.email_url = email_url if shop.email_url.blank?
      shop.website = website if shop.website.blank?
      shop.content = content if shop.content.blank?
      shop.save
      shop
    end

    # http://ya.58.com/zpanmo/17794521644161x.shtml
    def extract_job(shop_id, link)
      title = nil
      cate_id = nil
      salary = nil
      content = nil
      region_id = nil
      city_id = nil
      district_id = nil
      detail_address = nil

      page = Nokogiri::HTML(open(link))
      title = page.css('h1').text
      trs = page.css('li.condition')
      if trs.size == 3
        #get cate: 按摩师 (招10人)
        txt = page.css('li.condition')[1].css('div').after('span').text
        txt = txt.sub(/\(.*\)/, '').strip
        cate_id = ApplicationHelper::JOB_CATES.index(txt)
        #
      end

      salary = page.css('span.salaNum').text if page.css('span.salaNum')

    end

    #=========================task start =======================
    desc "Forager 58.com job from: http://{city}.58.com/zpanmo/"
    task job: :environment do
      begin
        page = Nokogiri::HTML(open("http://ms.58.com/zpanmo/")) 
        page.css('div#infolist dl').each do |dl|
          links = dl.css("a").map{|s| s['href'] }
          next unless links.size == 2
          shop = extract_shop(links.pop, city_id: 2)
          next if shop.nil?
          extract_job(shop.id, links.pop)
        end
      rescue => ex
      end
    end

    desc "TODO"
    task resume: :environment do
    end

    desc "TODO"
    task service: :environment do
    end

  end
end