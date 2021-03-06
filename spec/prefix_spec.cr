require "./spec_helper"

def parse_p(line)
  FastIRC.parse_line(":#{line} COMMAND".to_slice).prefix.not_nil!
end

def gen_p(nick, user, host)
  FastIRC::Prefix.new(source: nick, user: user, host: host)
end

describe FastIRC::Prefix do
  it "parses a nickmask" do
    parse_p("nick!user@host").should eq(gen_p("nick", "user", "host"))
  end

  it "supports missing username" do
    parse_p("nick@host").should eq(gen_p("nick", nil, "host"))
  end

  it "supports only having a nick" do
    parse_p("nick").should eq(gen_p("nick", nil, nil))
  end

  it "parses nick+user" do
    parse_p("nick!user").should eq(gen_p("nick", "user", nil))
  end

  it "detects servers" do
    parse_p("irc.example.org").should eq(gen_p("irc.example.org", nil, nil))
  end

  it "emits a basic nick properly" do
    gen_p("nick", nil, nil).to_s.should eq("nick")
  end

  it "emits a nick with user" do
    gen_p("nick", "user", nil).to_s.should eq("nick!user")
  end

  it "emits a nick with host" do
    gen_p("nick", nil, "host").to_s.should eq("nick@host")
  end

  it "emits a full nick mask properly" do
    gen_p("nick", "user", "host").to_s.should eq("nick!user@host")
  end

  it "emits a server" do
    gen_p("host.name.com", nil, nil).to_s.should eq("host.name.com")
  end
end
