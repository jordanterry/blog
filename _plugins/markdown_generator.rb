module Jekyll
  class MarkdownGenerator < Generator
    safe true
    priority :lowest

    def generate(site)
      site.posts.docs.each do |post|
        site.static_files << MarkdownStaticFile.new(site, post)
      end
    end
  end

  class MarkdownStaticFile < StaticFile
    def initialize(site, post)
      @post = post

      post_url = post.url.chomp('/')
      dir = "llm" + File.dirname(post_url)
      name = File.basename(post_url) + ".md"

      # StaticFile expects: site, base, dir, name
      super(site, site.source, dir, name)
    end

    def write(dest)
      dest_path = destination(dest)
      FileUtils.mkdir_p(File.dirname(dest_path))

      content = build_content

      File.open(dest_path, 'wb') do |f|
        f.write(content)
      end

      true
    end

    def build_content
      content_parts = []
      content_parts << "# #{@post.data['title']}"
      content_parts << ""

      if @post.data['date']
        content_parts << "*#{@post.data['date'].strftime('%B %d, %Y')}*"
        content_parts << ""
      end

      if @post.data['excerpt']
        excerpt_text = @post.data['excerpt'].to_s.strip
        unless excerpt_text.empty?
          content_parts << "> #{excerpt_text.gsub("\n", "\n> ")}"
          content_parts << ""
        end
      end

      # Get raw markdown content (not converted HTML)
      raw_content = File.read(@post.path)
      # Remove frontmatter
      raw_content = raw_content.sub(/\A---\s*\n.*?\n---\s*\n/m, '')

      content_parts << raw_content

      content_parts.join("\n")
    end

    # Always write (don't check modified time)
    def modified?
      true
    end
  end
end
