#encoding: utf-8

Source.create name: '燃文小说网', code: 'ranwen', url: 'http://www.ranwen.net'


rules = {
    #书籍列表
    book: {
        list: {
            url: 'http://all.qidian.com/book/bookstore.aspx?PageIndex=:page',
            path: 'div.twoleft',
            item: {
                path: 'div.sw2,div.sw1',
                segments: {
                    title: {
                        path: 'div.swb/span.swbt/a',
                        type: 'href'
                    },
                    last_chapter: {
                        path: 'div.swb/a.hui2',
                        type: 'href'
                    },
                    word_count: 'div.swc',
                    author: {
                        path: 'div.swd/a',
                        type: 'href',
                        save_url: false
                    },
                    last_updated_at: 'div.swe',
                    category_id: {
                        path: 'div.swa',
                        pattern: 'SubCategoryId=(\d+)',
                        category: 'regexp'
                    }
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
          path: '#divBookInfo',
          segments: {
            cover: {
              category: 'replace',
              ref_key: 'code',
              pattern: 'http://image.cmfu.com/books/${code}/${code}.jpg'
            },
            title: 'div.title/h1',
            author: 'span[@itemprop="name"]',
            desc: 'span[@itemprop="description"]',
            tags: 'div.labels/a'
          }
        },
        #书籍章节列表
        chapter: {

        },
        #书籍正文信息
        content: {

        }
    }
}

Source.create name: '起点中文网', code: 'qidian', url: 'http://qidian.com', rules: rules.to_yaml