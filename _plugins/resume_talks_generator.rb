module Jekyll
  class ResumeBlogIntegrationGenerator < Generator
    safe true
    priority :high  # Run early so data is available to templates

    def generate(site)
      return unless site.data['resume']

      # Generate publications from Talks posts (JSON Resume compliant)
      site.data['resume']['publications'] = generate_publications(site)

      # Generate projects from Projects posts (JSON Resume compliant)
      site.data['resume']['projects'] = generate_projects(site)
    end

    private

    # JSON Resume schema for publications:
    # name, publisher, releaseDate, url, summary
    def generate_publications(site)
      talk_posts = site.posts.docs.select do |post|
        categories = post.data['categories'] || []
        categories.any? { |c| c.downcase == 'talks' }
      end

      talk_posts = talk_posts.sort_by { |post| post.data['date'] }.reverse

      talk_posts.map do |post|
        talk_data = post.data['talk'] || {}

        {
          'name' => post.data['title'],
          'publisher' => talk_data['event'] || extract_event_from_title(post.data['title']),
          'releaseDate' => post.data['date'].strftime('%Y-%m-%d'),
          'url' => talk_data['slides_url'] || "#{site.config['url']}#{post.url}",
          'summary' => talk_data['summary'] || post.data['excerpt']&.to_s&.strip
        }.compact
      end
    end

    # JSON Resume schema for projects:
    # name, startDate, endDate, description, highlights, url
    def generate_projects(site)
      project_posts = site.posts.docs.select do |post|
        categories = post.data['categories'] || []
        categories.any? { |c| c.downcase == 'projects' }
      end

      project_posts = project_posts.sort_by { |post| post.data['date'] }.reverse

      project_posts.map do |post|
        project_data = post.data['project'] || {}

        # Build highlights from technologies if provided
        highlights = []
        if project_data['technologies']&.any?
          highlights << "Built with: #{project_data['technologies'].join(', ')}"
        end

        {
          'name' => project_data['name'] || post.data['title'],
          'startDate' => post.data['date'].strftime('%Y-%m-%d'),
          'description' => project_data['summary'] || post.data['excerpt']&.to_s&.strip,
          'highlights' => highlights.empty? ? nil : highlights,
          'url' => project_data['url']
        }.compact
      end
    end

    def extract_event_from_title(title)
      if title =~ /^(.+?)\s*[-–—]\s*.+$/
        $1.strip
      else
        nil
      end
    end
  end
end
