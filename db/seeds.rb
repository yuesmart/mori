#encoding: utf-8

Source.create name: '燃文小说网',code: 'ranwen',url: 'http://www.ranwen.net'
rules = {
  #书籍列表
  list: {
    url: 'http://all.qidian.com/book/bookstore.aspx?PageIndex=:page',
    pattern: 'div.twoleft',
    book: {
      pattern: 'div.sw2,div.sw1',
      segments: {
        title: {
          pattern: 'div.swb/span.swbt/a',
          type: 'href'
        },
        last_chapter: {
          pattern:'div.swb/a.hui2',
          type: 'href'
        },
        word_count: 'div.swc',
        author: {
          pattern: 'div.swd/a',
          type: 'href',
          save_url: false
        },
        last_updated_at: 'div.swe'
      },
    },
      
    paging: {
        path: 'div.storelistbottom',
        current_page: 'a.f_s',
        pages: 'a.f_a'
    }
  },
  
  #书籍明细，如图片，公告，评论等
  info: {
    
  },
  #书籍章节列表
  chapter: {
    
  },
  #书籍正文信息
  content: {
    
  }
}
Source.create name: '起点中文网',code: 'qidian',url: 'http://qidian.com',rules: rules.to_yaml