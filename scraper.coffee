Xray    = require('x-ray')
x       = Xray()
cheerio = require('cheerio')
Promise = require('bluebird')
fs      = Promise.promisifyAll require 'fs'
request = Promise.promisifyAll require 'request'
_       = require('lodash')

clubid  = undefined

fs.readFileAsync('./list.txt', encoding: 'UTF-8')
.then (urls) ->
  arr = _.select urls.split('\n'), (url) ->
    url.match /http:\/\/cafe.naver.com\/.*/g
  arr
.each (url) ->
  ids = []
  request.getAsync(url)
  .then (res) ->
    $ = cheerio.load(res.body)
    str = $('.thm a').attr('href')
    cafeId = /[^=]+\=(.*)/.exec(str)
    clubid = cafeId[1]
    unless cafeId
      console.log cafeId
      return
    "http://cafe.naver.com/ArticleList.nhn?search.clubid=#{cafeId[1]}&search.boardtype=L"
  .then(request.getAsync)
  .then (res) ->
    $ = cheerio.load(res.body)
    str = $("table.Nnavi td.on a").attr('href')
    totalCount = parseInt(/totalCount\=(\d+)/.exec(str)[1])
    urls = []
    for i in [1..totalCount]
      urls.push "http://cafe.naver.com/ArticleList.nhn?search.boardtype=L&search.questionTab=A&search.clubid=#{clubid}&search.totalCount=#{totalCount}&search.page=#{i}"
    urls
  .each (uri) ->
    Promise.delay(1000)
    .then ->
      request.getAsync(uri)
    .then (res) ->
      $ = cheerio.load(res.body)
      $("div.pers_nick_area a[href='#']").each (i, data) ->
        console.log "'#{url}'," + $(this).attr('onclick').split(",")[1]



#, {concurrency: 1}
.then ->
  process.exit(1)
