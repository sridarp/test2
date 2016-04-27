module Jellyfish
  class ExtensionNotFound < StandardError
  end
  class ExtensionRequirementError < StandardError
  end

  # Base class for Jellyfish extensions.
  # Extensions are registered using the <tt>register</tt> class method that acts as the public constructor.
  #
  #   Jellyfish::Extension.register :example do
  #     name 'Example extension'
  #     author 'John Smith'
  #     description 'This is an example extension for Jellyfish'
  #     version '0.0.1'
  #   end
  #
  class Extension
    include ActiveModel::SerializerSupport

    @registered_extensions = {}
    @tests_to_skip = {}

    class << self
      attr_reader :registered_extensions
      private :new

      def def_field(*names)
        class_eval do
          names.each do |name|
            define_method(name) do |*args|
              args.empty? ? instance_variable_get("@#{name}") : instance_variable_set("@#{name}", *args)
            end
          end
        end
      end

      # Extension constructor
      def register(id, &block)
        extension = new(id.to_sym)
        if (gem = Gem.loaded_specs[id.to_s])
          extension.name gem.name
          extension.author gem.authors.join(',')
          extension.description gem.description
          extension.url gem.homepage
          extension.version gem.version.to_s
          extension.path gem.full_gem_path
        end

        extension.instance_eval(&block)
        extension.after_initialize

        registered_extensions[id] = extension
      end

      # Clears the registered extensions hash
      # It doesn't unload installed extensions
      def clear
        @registered_extensions = {}
      end

      # Returns an array of all registered extensions
      def all
        registered_extensions.values.sort_by(&:name)
      end

      # Finds a extension by its id
      def find(id)
        registered_extensions[id.to_sym]
      end

      # Checks if a extension is installed
      #
      # @param [String] id name of the extension
      def installed?(id)
        registered_extensions[id.to_sym].present?
      end
    end

    def_field :name, :description, :url, :author, :author_url, :version, :path, :scripts, :mount
    attr_reader :id # , :logging

    def initialize(id)
      @id = id.to_sym
      @scripts = []
      @mount = nil
    end

    def after_initialize
    end

    def <=>(other)
      id.to_s <=> other.id.to_s
    end

    def to_s
      "Jellyfish extension: #{id}, #{version}, #{author}, #{description}"
    end

    # Sets a requirement on Jellyfish version
    # Raises a ExtensionRequirementError exception if the requirement is not met
    # matcher format is gem dependency format
    def requires_jellyfish(matcher)
      current = SETTINGS[:version].notag
      unless Gem::Dependency.new('', matcher).match?('', current)
        raise ExtensionRequirementError, '%{id} extension requires Jellyfish %{matcher} but current is %{current}'.format(id: id, matcher: matcher, current: current)
      end
      true
    end

    # Sets a requirement on a Jellyfish extension version
    # Raises a ExtensionRequirementError exception if the requirement is not met
    # matcher format is gem dependency format
    def requires_jellyfish_extension(extension_name, matcher)
      extension = Extension.find(extension_name)
      raise ExtensionNotFound, '%{id} extension requires the %{extension_name} extension, not found'.format(id: id, extension_name: extension_name) unless extension
      unless Gem::Dependency.new('', matcher).match?('', extension.version)
        raise ExtensionRequirementError, '%{id} extension requires the %{extension_name} extension %{matcher} but current is %{extension_version}'.format(id: id, extension_name: extension_name, matcher: matcher, extension_version: extension.version)
      end
      true
    end

    # Sets a list of JavaScript includes for UX
    #
    # scripts should be complete paths excluding public/
    def load_scripts(*scripts)
      @scripts.concat scripts
    end

    def mount_extension(engine, options)
      @mount = {
        engine: engine,
        options: options.freeze
      }.freeze
    end

    def pending_migrations
      migrations = ActiveRecord::Migrator.new(:up, ActiveRecord::Migrator.migrations_paths).pending_migrations
      !migrations.empty?
    end
  end
end
