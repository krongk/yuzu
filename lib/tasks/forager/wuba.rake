require 'nokogiri'
require 'open-uri'

namespace :forager do
  namespace :wuba do

    #link: http://qy.58.com/9874515439110/
    # opt = {region_id: 1, city_id: 2, district_id: 2}
    def extract_shop(link, opt = {})
      #puts "extract_shop: #{link}"
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
      title = page.css('h1').text if page.css('h1')
      detail_address = page.css('td.adress span').text if page.css('td.adress span')

      trs = page.css('div.basicMsg table tr')
      if trs.size == 5
        contact_name = trs[2].css('td')[0].text if trs[2].css('td')[0]
        mobile_phone_url = trs[2].css('td').at_css('img')['src'] if trs[2].css('td').at_css('img')
        email_link = trs[3].css('td').at_css('img')['src'] if trs[3].css('td').at_css('img')
        website = trs[3].css('td').at_css('a')['href'] if trs[3].css('td').at_css('a')
      end
      content = page.css('div.compIntro').text if page.css('div.compIntro')

      shop = Shop.find_or_initialize_by(title: title.to_s.strip, source: source, source_url: source_url)
      shop.city_id = opt[:region_id] if shop.city_id.blank?
      shop.city_id = opt[:city_id] if shop.city_id.blank?
      shop.city_id = opt[:district_id] if shop.city_id.blank?
      shop.detail_address = detail_address if shop.detail_address.blank?
      shop.contact_name = contact_name.to_s.strip if shop.contact_name.blank?
      shop.mobile_phone_url = mobile_phone_url if shop.mobile_phone_url.blank?
      shop.email_url = email_url if shop.email_url.blank?
      shop.website = website.to_s.strip if shop.website.blank?
      shop.content = content.to_s.strip if shop.content.blank?
      #tmp
      if shop.user_id.nil?
        user = User.get_tmp_user(name: title.to_s.strip)
        shop.user_id = user.id
        shop.mobile_phone = user.mobile_phone
        shop.email = user.email
      end
      shop.save!
      shop.reload
    end

    # http://ya.58.com/zpanmo/17794521644161x.shtml
    def extract_job(user_id, link)
      #puts "extract_job: #{link}"
      return if user_id.nil?
      title = nil
      cate_id = nil
      salary = nil
      content = nil
      region_id = nil
      city_id = nil
      district_id = nil
      detail_address = nil

      page = Nokogiri::HTML(open(link))
      title = page.css('h1').text if page.css('h1')
      trs = page.css('li.condition')
      if trs.size > 2
        #get cate: 按摩师 (招10人)
        txt = page.css('li.condition')[1].css('div').after('span')
        txt = txt.text.sub(/\(.*\)/, '').to_s.strip if txt
        cate_id = ApplicationHelper::JOB_CATES.index(txt) if txt
        #
        addr = trs.find{|tr| tr.css("span.area")}
        spans = addr.css("span")
        if spans.size == 3
          detail_address = spans[1].text
          city_tag = spans[2].css("a")[0]
          city_txt = city_tag.text if city_tag
          city = City.find_by(name: city_txt)
          if city
            city_id = city.id
            region_id = city.region_id
          end

          district_tag = spans[2].css("a")[-1]
          district_txt = district_tag.text if district_tag
          district = District.where(["name regexp ?", district_txt]).first if district_txt
          if district
            district_id = district.id
            city_id = district.city_id if city_id.nil?
          end
        else
          raise 'address line has not 3 spans'
        end
      else
        raise 'trs has not >2 tr'
      end

      salary = page.css('span.salaNum').text if page.css('span.salaNum')
      content = page.css('div.posMsg').text if page.css('div.posMsg')

      job = Job.new
      job.user_id = user_id
      job.cate_id = cate_id
      job.cate_id = 1 if job.cate_id.nil?
      job.title = title.to_s.strip
      job.salary = salary.to_s.strip
      job.content = content.to_s.strip
      job.region_id = region_id
      job.city_id = city_id
      job.district_id = district_id
      #tmp
      job.mobile_phone = "18000000000"
      job.email = "forager@zuyu114.com"
      job.save!
    end

    #=========================task start =======================
    desc "Forager 58.com job from: http://cd.58.com/zpanmo/"
    task job: :environment do
      error_count = 0
      Forager::WubaRunKey.where(is_processed: 'n').find_each do |run_key|
        flag = 'f'
        begin
          #保健按摩招聘
          link = "http://#{run_key.short_title}.58.com/zpanmo/"
          puts "----------#{link}---------------"
          page = Nokogiri::HTML(open(link)) 
          lists = page.css('div#infolist dl')
          if lists.size == 0
            puts "can not get the correct page"
            exit
          end
          lists.each do |dl|
            links = dl.css("a").map{|s| s['href'] }.compact
            #next unless links.size == 2
            shop = extract_shop(links.pop, city_id: City.find_by(name: run_key.title).try(:id))
            #next if shop.nil?
            extract_job(shop.user_id, links.pop)
            sleep( rand(300) )
          end
          flag = 'y'
        rescue => ex
          puts ex.message
          error_count += 1
          exit if error_count > 10
        end
        puts "processed run key : #{run_key.short_title} -> #{flag}"
        run_key.is_processed = flag
        run_key.save
      end
    end

    desc "TODO"
    task resume: :environment do
    end

    desc "TODO"
    task service: :environment do
    end

    desc "get run keys from: http://www.58.com/changecity.aspx"
    task genrate_run_keys: :environment do
      link = "http://www.58.com/changecity.aspx"
      page = Nokogiri::HTML(open(link))
      page.css("dl dd a").each do |a|
        Forager::WubaRunKey.find_or_create_by(typo: 'job', title: a.text, short_title: a['href'].sub(/.*\/\/(.*)\.58\.com\//, '\1') )
        puts a['href']
      end
    end

    desc "reset all run keys set is_processed = 'n'"
    task reset_run_keys: :environment do
      unless Forager::WubaRunKey.where(is_processed: 'n').any?
        Forager::WubaRunKey.update_all(is_processed: 'n')
        puts "reseted all"
      else
        puts "has not processed records"
      end
    end

  end
end