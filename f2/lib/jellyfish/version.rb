module Jellyfish
  # Simple struct for manipulation and comparing versions
  class Version
    attr_reader :version, :major, :minor, :patch, :tag, :short, :notag
    alias full version

    def initialize(givenversion = nil)
      if givenversion
        @version = givenversion
      else
        root = File.expand_path File.join('..', '..', '..'), __FILE__
        @version = File.read(File.join(root, 'VERSION')).chomp # or fail if not found
      end
      @major, @minor, @patch = @version.scan(/\d+/)
      @short = "#{@major}.#{@minor}"
      @notag = @version
      @tag = ''

      @version.match(/\A(.*)-([^-]+)\z/) do |m|
        @notag = m[1]
        @tag = m[2]
      end
    end

    def to_s
      @version
    end
  end
end
