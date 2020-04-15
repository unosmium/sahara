# frozen_string_literal: true

require 'sciolyff'
require 'cgi'

run lambda { |env|
  req = Rack::Request.new(env)

  if req.path_info.match? %r{\A/playground(.html)?\z}
    return [200,
            { 'Content-Type' => 'text/html' },
            File.open('playground.html')]
  end

  res = Rack::Response.new(nil, 400, { 'Access-Control-Allow-Origin' => '*' })

  body = req.body.read
  # Ignore params in body because there are too many, leading to RangeError
  params = CGI.parse(req.query_string)
  type = params['type']&.first
  hide_raw = params['hide_raw']&.first
  color = params['color']&.first

  validator = SciolyFF::Validator.new

  res.body =
    if body.empty?
      { message: 'Please POST in SciolyFF (JSON or YAML)' }
    elsif validator.valid? body
      res.status = 200
      { html: SciolyFF::Interpreter.new(body).to_html(
        hide_raw: (hide_raw == 'true'), color: color
      ) }
    else
      { log: validator.last_log }
    end

  res.content_type =
    if type == 'html'
      str = res.body.values.first
      unless res.body[:html]
        str = '<meta charset="utf-8"/>'\
              "<pre style=\"font-size: 16px;\">#{str}</pre>"
      end
      res.body = [str]
      'text/html'
    else
      res.body[:log] = res.body[:log].split("\n") if res.body[:log]
      res.body = [res.body.to_json]
      'application/json'
    end

  res.finish
}
