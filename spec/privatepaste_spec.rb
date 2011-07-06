require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Privatepaste" do
    before do
        `echo "hello world" > /tmp/hw.txt`
        options = {"paste_content" => "/tmp/hw.txt",
            "line_numbers" => "on",
            "expire" => "300",
            "secure_paste" => "on",
            "secure_paste_key" => "foo"
        }
        @pbin = Privatepaste.new(options)
    end

    after do
        `rm /tmp/hw.txt`
    end

    it "tests that @pbin is indeed a Privatepasteobject" do
        @pbin.class.to_s.should == "Privatepaste"
    end

    it "should paste some text and return a link" do
        @link = @pbin.paste
        @link.should match(/https:.*\/[\d\w]+/)
    end

    it "should return raw text from a paste link" do
        options = {}
        options["secure_paste_key"] = "foo"
        options["link"] = @pbin.paste
        @pbin = Privatepaste.new(options)
        text = @pbin.get_raw
        text.should match(/hello world/)
    end

end
