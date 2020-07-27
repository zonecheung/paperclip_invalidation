Gem::Specification.new do |s|
  s.name                      = 'paperclip_invalidation'
  s.version                   = '0.0.2'
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ['John Tjanaka']
  s.email                     = ['zonecheung@gmail.com']
  s.homepage                  = 'https://github.com/zonecheung'
  s.description               = 'Invalidate paperclip attachment in ' \
                                'cloudflare or an external host'
  s.summary                   = "paperclip_invalidation-#{s.version}"

  s.required_rubygems_version = '> 1.3.6'

  s.add_dependency 'activesupport', '>=3.0.0'
  s.add_dependency 'rails',         '>=3.0.0'

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n")
                                .map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
