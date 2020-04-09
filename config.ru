# frozen_string_literal: true

require 'sciolyff'

run lambda { |env|
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
