# 小说内容采集
OH，又一个小说站点！是的，你说对了。

## 规则
定义抓取网站的抓取规则，即可抓取信息，如起点图书列表规则如下：

```
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
```

目前才才是list节点

## 截图

* 首页

![S1](https://raw.github.com/yuesmart/mori/master/doc/snip/Snip20131125_1.png) 

* 章节列表

![S2](https://raw.github.com/yuesmart/mori/master/doc/snip/Snip20131125_2.png) 

* 正文

![S3](https://raw.github.com/yuesmart/mori/master/doc/snip/Snip20131125_3.png) 


## Contributing

Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.