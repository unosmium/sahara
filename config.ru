# frozen_string_literal: true

require 'sciolyff'
require 'cgi'

run lambda { |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new(nil, 400, { 'Access-Control-Allow-Origin' => '*' })

  body = req.body.read
  # Ignore params in body because there are too many, leading to RangeError
  type = CGI.parse(req.query_string)['type']&.first

  validator = SciolyFF::Validator.new

  res.body =
    if body.empty?
      { message: 'Please POST in SciolyFF (JSON or YAML)' }
    elsif validator.valid? body
      res.status = 200
      { html: SciolyFF::Interpreter.new(body).to_html }
    else
      { log: validator.last_log }
    end

  res.content_type =
    if type == 'html'
      str = res.body.values.first
      str = '<meta charset="utf-8"/>' + str unless res.body[:html]
      res.body = [str]
      'text/html'
    else
      res.body[:log] = res.body[:log].split("\n") if res.body[:log]
      res.body = [res.body.to_json]
      'application/json'
    end

  res.finish
}
