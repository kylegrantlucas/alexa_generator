require "alexa_test/version"
require 'sinatra/base'
require 'alexa_objects'

module Siantra
  module Test
    def self.registered(app)
      app.post '/alexa_test' do
      end
    end
  end

  register Test
end
