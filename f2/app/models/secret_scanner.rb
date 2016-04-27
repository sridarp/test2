class SecretScanner
  CERTIFICATE = /BEGIN (CERTIFICATE|RSA PRIVATE KEY)/
  ACCESS_KEY_ID_REGEX = /[A-Z0-9]{19}[A-Z0-9]/
  SECRET_ACCESS_KEY_REGEX = /[A-Za-z0-9\+]{39}[A-Za-z0-9\+]/
  WHITELIST_PATTERNS = [].freeze
  WHITELIST_FILES = [].freeze

  def self.scan_dirs(directories, _regexes = [CERTIFICATE, ACCESS_KEY_ID_REGEX], _whitelists = WHITELIST_FILES)
    matches = []
    [directories].flatten.each do |dir_path|
      matches += scan_files(Dir.glob("#{dir_path}/**/*"))
    end
    matches
  end

  def self.scan_files(file_paths, regexes = [CERTIFICATE, ACCESS_KEY_ID_REGEX], whitelists = WHITELIST_FILES)
    matches = []
    [file_paths].flatten.each do |file_path|
      next if File.directory?(file_path)
      next if whitelists.any? { |path| file_path =~ /#{path}$/ }
      file = File.read(file_path)
      begin
        lines = file.split
      rescue
        next # don't bother scanning files that can't be split (e.g. images)
      end

      regexes.each do |regex|
        next if (matched_lines = lines.grep(regex)).empty?
        matched_lines.each do |line|
          next if WHITELIST_PATTERNS.any? { |pattern| line =~ pattern }
          matches << "#{file_path} : #{line}" # ("%s : %s" % [file_path, line])
        end
      end
    end
    matches
  end
end
