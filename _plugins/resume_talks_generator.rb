module Jekyll
  class ResumeTalksGenerator < Generator
    safe true
    priority :high  # Run early so data is available to templates

    def generate(site)
      # Get all posts in the "Talks" category (case-insensitive)
      talk_posts = site.posts.docs.select do |post|
        categories = post.data['categories'] || []
        categories.any? { |c| c.downcase == 'talks' }
      end

      # Sort by date descending (most recent first)
      talk_posts = talk_posts.sort_by { |post| post.data['date'] }.reverse

      # Build publications array from talk posts
      publications = talk_posts.map do |post|
        talk_data = post.data['talk'] || {}

        {
          'name' => post.data['title'],
          'publisher' => talk_data['event'] || extract_event_from_title(post.data['title']),
          'releaseDate' => post.data['date'].strftime('%Y-%m-%d'),
          'url' => post.url,
          'summary' => talk_data['summary'] || post.data['excerpt']&.to_s&.strip,
          'slides_url' => talk_data['slides_url'],
          'video_url' => talk_data['video_url']
        }.compact  # Remove nil values
      end

      # Inject into site.data.resume
      if site.data['resume']
        site.data['resume']['publications'] = publications
      end
    end

    private

    # Try to extract event name from title like "Droidcon London 2023 - Talk Title"
    def extract_event_from_title(title)
      if title =~ /^(.+?)\s*[-–—]\s*.+$/
        $1.strip
      else
        nil
      end
    end
  end
end
