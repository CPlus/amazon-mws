# encoding: utf-8
#require 'rubygems'

if RUBY_VERSION.match("1.9")
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
  end
end

require 'minitest/autorun'
require 'pathname'
require 'yaml'
#require 'fakeweb'
require 'mocha/minitest'

require File.join(File.dirname(__FILE__), '..', 'lib', 'amazon', 'mws')

include Amazon::MWS

def xml_for(name, code)
  file = File.open(Pathname.new(File.dirname(__FILE__)).expand_path.dirname.join("examples/xml/#{name}.xml"),'rb')
  mock_response(code, {:content_type=>'text/xml', :body=>file.read})
end

def mock_response(code, options={})
  body = options[:body]
  content_type = options[:content_type]
  response = Net::HTTPResponse.send(:response_class, code.to_s).new("1.0", code.to_s, "message")
  response.instance_variable_set(:@body, body)
  response.instance_variable_set(:@read, true)
  response.content_type = content_type
  return response
end
