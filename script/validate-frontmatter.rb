#!/usr/bin/env ruby
# Script to validate post front matter

require 'yaml'

REQUIRED_FIELDS = %w[title date author layout permalink]

puts "Validating front matter in _posts/*.md\n\n"

wordpress_artifacts = []
missing_fields = []
missing_excerpts = []
missing_tags = []
inconsistent_categories = []

Dir.glob('_posts/*.md').sort.each do |file|
  content = File.read(file)

  if content =~ /\A---\s*\n(.*?)\n---\s*\n/m
    front_matter = YAML.load($1)

    # Check for WordPress artifacts
    if front_matter['id'] || front_matter['guid']
      wordpress_artifacts << file
    end

    # Check for missing required fields
    missing = REQUIRED_FIELDS - front_matter.keys
    if missing.any?
      missing_fields << "#{file}: Missing #{missing.join(', ')}"
    end

    # Check for missing excerpt
    unless front_matter['excerpt']
      missing_excerpts << file
    end

    # Check for missing tags
    unless front_matter['tags'] && front_matter['tags'].any?
      missing_tags << file
    end

    # Check category format
    if front_matter['categories']
      cats = front_matter['categories']
      old_style = ['Coding', 'Debriefs', 'PPL', 'Aerobatics', 'Trips', 'Reinforcement',
                   'Gradle', 'Kotlin', 'Twitter', 'Triathlon', 'Uncategorized']
      if cats.is_a?(Array) && (cats & old_style).any?
        inconsistent_categories << file
      end
    end
  else
    puts "✗ Could not parse: #{file}"
  end
end

puts "=== VALIDATION RESULTS ===\n\n"

puts "WordPress Artifacts (#{wordpress_artifacts.length}):"
if wordpress_artifacts.any?
  wordpress_artifacts.first(5).each { |f| puts "  - #{f}" }
  puts "  ... and #{wordpress_artifacts.length - 5} more" if wordpress_artifacts.length > 5
else
  puts "  ✓ None found"
end

puts "\nMissing Required Fields (#{missing_fields.length}):"
if missing_fields.any?
  missing_fields.first(5).each { |f| puts "  - #{f}" }
  puts "  ... and #{missing_fields.length - 5} more" if missing_fields.length > 5
else
  puts "  ✓ All posts have required fields"
end

puts "\nMissing Excerpts (#{missing_excerpts.length}):"
if missing_excerpts.any?
  missing_excerpts.first(5).each { |f| puts "  - #{f}" }
  puts "  ... and #{missing_excerpts.length - 5} more" if missing_excerpts.length > 5
else
  puts "  ✓ All posts have excerpts"
end

puts "\nMissing Tags (#{missing_tags.length}):"
if missing_tags.any?
  missing_tags.first(5).each { |f| puts "  - #{f}" }
  puts "  ... and #{missing_tags.length - 5} more" if missing_tags.length > 5
else
  puts "  ✓ All posts have tags"
end

puts "\nInconsistent Categories (#{inconsistent_categories.length}):"
if inconsistent_categories.any?
  inconsistent_categories.first(5).each { |f| puts "  - #{f}" }
  puts "  ... and #{inconsistent_categories.length - 5} more" if inconsistent_categories.length > 5
else
  puts "  ✓ All categories use standard names"
end

puts "\n=== SUMMARY ===\n"
puts "Total posts: #{Dir.glob('_posts/*.md').length}"
puts "Posts needing attention: #{[wordpress_artifacts, missing_tags, inconsistent_categories].flatten.uniq.length}"
