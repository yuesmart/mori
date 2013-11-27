#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'scraper/ranwen'
require 'scraper/qidian'

namespace :scraper do
  namespace :qidian do
    desc "parse qidian book"
    task :book => :environment do
      Qidian.new.parse_book
    end
    
    desc "parse qidian book info"
    task :info => :environment do
      Qidian.new.parse_info
    end
  end
  
  namespace :ranwen do
    desc "parse book"
    task :book => :environment do
      Ranwen.new.parse_book
    end
  
    desc "parse chapter"
    task :chapter => :environment do
      Ranwen.new.parse_chapter
    end
  
    desc "parse content"
    task :content => :environment do
      page = ENV['page']
      max_page = ENV['max_page']
      Ranwen.new.parse_content nil,page,max_page
    end
  
    desc "update book"
    task :update => :environment do
      Ranwen.new.parse_update
    end

    desc "parse chapter associate"
    task :associate => :environment do
      Ranwen.new.parse_chapter_associate
    end
  end
end