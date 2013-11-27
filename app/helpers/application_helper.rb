module ApplicationHelper  
  def trim c
    c.gsub!(" ","")
    c = $1 if c =~ /(.*?)（.*）/
    c = $1 if c =~ /(.*?)\(.*\)/
    c = $1 if c =~ /(.*?)（.*\)/
    c = $1 if c =~ /(.*?)\(.*）/
    c = $1 if c =~ /(.*?)【.*】/
    c = $1 if c =~ /(.*?)\[.*\]/
    c
  rescue => e
    c
  end
end
