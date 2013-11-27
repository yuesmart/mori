#encoding: utf-8
require 'mori'

class Proxy
  include Mori

  #http://www.cnproxy.com/proxy1.html
  def get_proxy_from_cnproxy  		
    v="3";m="4";a="2";l="9";q="0";b="5";i="7";w="6";r="8";c="1"

    1.upto(10).each do |i|
      doc = Hpricot get("http://www.cnproxy.com/proxy#{i}.html")
      proxy_list = (doc/"#proxylisttb")
      (proxy_list/"tr > td:nth(0)").each do |td|
        ip  = text td
        ip  = $1 if ip =~ /(.*?)document/ 
        port = ''
        if td.inner_html =~ /<script type="text\/javascript">document\.write\(":"(.*?)\)<\/script>/
          $1.split('+').each do |pa|
            port << eval(pa)  unless pa.blank?
          end
        end
          
        save_proxy ip,port

      end
    end
  end
    
  #http://freeproxylist.org/cn/free-proxy-list.htm
  def get_proxy_from_free_proxy_list
    IO.readlines('./local/proxy.txt').each do |p|
      p = trim(p)
      unless p.blank?
        ip,port = p.split ':'
        save_proxy ip,port
      end
    end
    
  end
    
    #
  def get_proxy_from_proxy360
    doc = Hpricot get("http://www.proxy360.cn/Region/China")
    (doc/".proxylistitem").each do |item|
      spans = item/"span.tbBottomLine"
      ip = t spans[0]
      port = t spans[1]
      # log "#{ip}：#{port}"
      save_proxy ip,port
    end
  end
    
    #http://cn-proxy.com/
  def get_proxy_from_cn_proxy
    doc = Hpricot get("http://cn-proxy.com/")
    proxy_list = doc/"table.sortable"
    (proxy_list/"tbody/tr").each do |tr| 
        tds = tr/"td"
        ip = t tds[0]
        port = t tds[1]
        
        save_proxy ip,port
    end
  end
    
    #
  def get_proxy_from_56ads
    doc = Hpricot get("http://www.56ads.com/proxyip/",false,'get')
    proxy_list = doc/"div.listbox"
    (proxy_list/"li").each do |li|
      _url,_text = la li/"a.title"
      _url = "http://www.56ads.com#{_url}"
      proxy_doc = Hpricot get(_url,false,'get')
      div = (proxy_doc/"div/p")
    end
      
  end
    
  def save_proxy ip,port
    if port.to_i >0
      ip =  trim ip
      port = trim port
      p "#{ip}:#{port}"
      ps = ProxyServer.find_by ip: ip,port: port
      if ps.nil?
        ProxyServer.create! ip: ip,port: port
      else
        ps.update_attributes! count: ps.count+1
      end
    end
  end
    
  def update_proxy
    get_proxy_from_cnproxy
    get_proxy_from_free_proxy_list
    get_proxy_from_proxy360
    get_proxy_from_cn_proxy
  end
end