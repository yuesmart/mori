module ApplicationHelper  
  def error
    flash[:error]
  end

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
  
  
  def active_css_for_action action
     " class=active "  if action==params[:action]
  end
  
  def active? s1,s2
     " class=active "  if s1.to_s == s2.to_s
  end
  def active_css *m
    " class=active " if m.include?(controller_name.downcase.singularize)
  end

  def active_css2 *m
    " class=active " if m.include?(controller_name.downcase.singularize)
  end
  
end
