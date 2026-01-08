require 'json'
require 'open3'
require 'tmpdir'

module Jekyll
  class ResumeCLIGenerator < Generator
    safe true
    priority :low  # Run after ResumeBlogIntegrationGenerator

    def generate(site)
      return unless site.data['resume']

      Jekyll.logger.info "Resume CLI:", "Generating resume HTML with JSON Resume CLI..."

      # Create a temporary directory for the resume export
      Dir.mktmpdir do |tmpdir|
        resume_json_path = File.join(tmpdir, 'resume.json')
        resume_html_path = File.join(tmpdir, 'resume.html')

        # Write the complete resume data (with dynamically generated publications/projects)
        File.write(resume_json_path, JSON.pretty_generate(site.data['resume']))

        # Run the resume CLI to export HTML
        npm_bin = File.join(site.source, 'node_modules', '.bin')
        resume_cmd = File.join(npm_bin, 'resume')

        unless File.exist?(resume_cmd)
          Jekyll.logger.warn "Resume CLI:", "resume-cli not found. Run 'npm install' first."
          return
        end

        cmd = [
          resume_cmd,
          'export',
          resume_html_path,
          '--theme', 'jsonresume-theme-stackoverflow',
          '--resume', resume_json_path
        ]

        Jekyll.logger.info "Resume CLI:", "Running: #{cmd.join(' ')}"

        stdout, stderr, status = Open3.capture3(*cmd, chdir: site.source)

        if status.success?
          Jekyll.logger.info "Resume CLI:", "Successfully generated resume HTML"

          # Read the generated HTML
          if File.exist?(resume_html_path)
            html_content = File.read(resume_html_path)

            # Reorder sections: Work, Languages, Skills (instead of Skills, Work, ..., Languages)
            html_content = reorder_sections(html_content)

            # Store the HTML content in site data for use in templates
            site.data['resume_html'] = html_content

            # Extract just the body content for embedding
            site.data['resume_body'] = extract_body_content(html_content)

            Jekyll.logger.info "Resume CLI:", "Resume HTML stored in site.data['resume_html']"
          else
            Jekyll.logger.error "Resume CLI:", "Expected output file not found: #{resume_html_path}"
          end
        else
          Jekyll.logger.error "Resume CLI:", "Failed to generate resume HTML"
          Jekyll.logger.error "Resume CLI:", "STDOUT: #{stdout}" unless stdout.empty?
          Jekyll.logger.error "Resume CLI:", "STDERR: #{stderr}" unless stderr.empty?
        end
      end
    end

    private

    def reorder_sections(html)
      # Extract sections by their IDs
      # Current order: summary, skills, work, projects, education, publications, languages, interests
      # Desired order: summary, work, languages, skills, projects, education, publications, interests

      sections = {}
      section_pattern = /<section id="(\w+)">(.*?)<\/section>/m

      # Extract all sections
      html.scan(section_pattern) do |id, content|
        sections[id] = "<section id=\"#{id}\">#{content}</section>"
      end

      return html if sections.empty?

      # Define desired order
      desired_order = %w[summary work languages skills projects education publications interests]

      # Build reordered sections HTML
      reordered = desired_order.map { |id| sections[id] }.compact.join("\n      ")

      # Replace all sections with reordered version
      # Find the container that holds sections and replace its content
      html.gsub(/<section id="skills">.*<section id="interests">.*?<\/section>/m) do |_match|
        reordered
      end
    end

    def extract_body_content(html)
      # Extract content between <body> and </body> tags
      if html =~ /<body[^>]*>(.*)<\/body>/m
        $1.strip
      else
        html
      end
    end
  end
end
