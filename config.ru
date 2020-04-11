# frozen_string_literal: true

require 'sciolyff'
require 'cgi'

run lambda { |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new(nil, 200, { 'Access-Control-Allow-Origin' => '*' })

  body = req.body.read
  # Ignore params in body because there are too many, leading to RangeError
  type = CGI.parse(req.query_string)['type']&.first

  validator = SciolyFF::Validator.new

  res.body =
    if body.empty?
      { message: 'Please POST in SciolyFF (JSON or YAML)' }
    elsif validator.valid? body
      { html: SciolyFF::Interpreter.new(body).to_html }
    else
      res.status = 400
      { log: validator.last_log.split("\n") }
    end

  res.content_type =
    if type == 'html'
      res.body = [res.body.values.join("\n")]
      'text/html'
    else
      res.body = [res.body.to_json]
      'application/json'
    end

  res.finish
}
