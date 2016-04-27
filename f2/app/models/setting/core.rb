class Setting
  class Core < Setting
    def self.load_defaults
      return unless super
      transaction do
        [
          set('contact_name', description: 'Application contact name', default: 'Jellyfish Administrator'),
          set('contact_email', description: 'Application contact email address', value_type: :email, default: 'admin@projectjellyfish.org')
        ].each { |s| create! s.merge!(type: 'Setting::Core') }
      end
    end
  end
end
