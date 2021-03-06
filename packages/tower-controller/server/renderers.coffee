Tower.Controller.addRenderers
  text: (text, options, callback) ->
    text = JSON.stringify(text) unless typeof(text) == 'string'
    @headers['Content-Type'] ||= require('mime').lookup('text')
    callback null, text if callback
    text

  # This supports JSONP, just append `http://api.example.com/users.json?callback=?` to to your url and
  # jQuery will generate a function name for you that it will automatically
  # handle and parse your JSON from, such as `function1234567({your: 'data'})`.
  # You need JSONP to do `GET` requests across domains (even subdomains).
  json: (json, options, callback) ->
    unless typeof(json) == 'string'
      if @params.pretty && @params.pretty.toString() == 'true'
        json = JSON.stringify(json, null, 2)
      else
        json = JSON.stringify(json)
    json = "#{options.callback}(#{json})" if options.callback
    @headers['Content-Type'] ||= require('mime').lookup('json')
    callback null, json if callback
    json

  # https://github.com/wdavidw/node-csv-parser
  # csv: (csv, options, callback) ->

  # https://github.com/devongovett/pdfkit
  # pdf: (data, options, callback) ->
