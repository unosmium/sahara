# frozen_string_literal: true

require 'sciolyff'

run lambda { |env|
  # may be nominally encoded as ASCII-8BIT, use force_encoding('UTF-8') if you
  # need to mix this string with other (standard) UTF-8 strings
  body = Rack::Request.new(env).body.read

  validator = SciolyFF::Validator.new
  content = {}

  if body.empty?
    content[:message] = 'Please POST in SciolyFF (JSON or YAML)'
  elsif validator.valid? body
    content[:html] = SciolyFF::Interpreter.new(body).to_html
  else
    content[:log] = validator.last_log.split("\n")
  end
  [200, { 'Content-Type' => 'application/json' }, [content.to_json]]
}
