#!/usr/bin/env ruby
#
# Command line interface for privatepaste.com
#

require 'rubygems'
require 'httpclient'
require 'rexml/document'

class Privatepaste
    include REXML

    def initialize(options)
        @options = options
    end

    def paste
        if @options.has_key?("paste_content")
            if @options["paste_content"] == "-"
                @options["paste_content"] = $stdin.read
            else
                File.open(@options["paste_content"]) do |file|
                    @options["paste_content"] = file.read
                end
            end
        end
        clnt = HTTPClient.new
        clnt.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = clnt.post("https://privatepaste.com/save", @options).header['location'][0]
        "https://privatepaste.com" + res
    end

    def get_raw
        @options["secure_paste_key"] = "" if ! @options["secure_paste_key"]
        url = "https://privatepaste.com/" +
              "download/" +
              @options["link"].split("/")[3] +
              "/" +
              @options["secure_paste_key"]
        clnt = HTTPClient.new(:agent_name => 'ruby privatepaste gem')
        clnt.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        clnt.get_content(url)
    end


end
