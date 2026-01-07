module Jekyll
  module RemoveTrailingSlashFilter
    def remove_trailing_slash(input)
      return input if input.nil?
      input.to_s.chomp('/')
    end
  end
end

Liquid::Template.register_filter(Jekyll::RemoveTrailingSlashFilter)
