# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

if config['footnotes']
  say_wizard "Adding 'rails-footnotes'"
  gem 'rails-footnotes', '>= 3.7', :group => :development
  after_bundler do
    generate 'rails_footnotes:install'
  end
end

if config['ban_spiders']
  say_wizard "Banning spiders by modifying 'public/robots.txt'"
  after_bundler do
    # ban spiders from your site by changing robots.txt
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
end

if config['paginate']
  say_wizard "Adding 'kaminari'"
  gem 'kaminari', '>= 0.13.0'
  after_bundler do
    generate 'kaminari:config'
    get "https://raw.github.com/gist/2863989/f1ff348df24072d4b24c874f6ef0f537510c0a41/kaminari.zh-CN.yml", 'config/locales/kaminari.zh-CN.yml'
  end
  recipes << 'paginate'
end

if config['jsruntime']
  say_wizard "Adding 'therubyracer' JavaScript runtime gem"
  # maybe it was already added by the html5 recipe for bootstrap_less?
  unless recipes.include? 'jsruntime'
    gem 'therubyracer', :group => :assets, :platform => :ruby
  end
end

if config['i18n']
  say_wizard "Setting default i18n locales"
  gem 'rails-i18n'
  
  inject_into_file 'config/application.rb', :before => '# config.i18n.default_locale' do <<-RUBY
config.i18n.locale = 'zh-CN'
    config.i18n.default_locale = 'zh-CN'
RUBY
  end
  
  inject_into_file 'config/application.rb', :before => '# config.time_zone' do <<-RUBY
config.time_zone = 'Beijing'
RUBY
  end
  
end

__END__

name: Extras
description: "Various extras including 'ban_spiders' and 'rails-footnotes'."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - footnotes:
      type: boolean
      prompt: Would you like to use 'rails-footnotes' (it's SLOW!)?
  - ban_spiders:
      type: boolean
      prompt: Would you like to set a robots.txt file to ban spiders?
  - paginate:
      type: boolean
      prompt: Would you like to add 'kaminari' for pagination?
  - jsruntime:
      type: boolean
      prompt: Add 'therubyracer' JavaScript runtime (for Linux users without node.js)?
  - i18n:
      type: boolean
      prompt: Set project default i18n locales to zh-CN?
