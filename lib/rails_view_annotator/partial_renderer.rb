require 'action_view/renderer/partial_renderer'

module RailsViewAnnotator
  class PartialRenderer < ActionView::PartialRenderer
    # Tells for which formats the partial has been requested.
    def extract_requested_formats_from(context)
      lookup_context = context.lookup_context
      lookup_context.formats
    end

    def render(context, options, block)
      inner = super
      identifier = template_identifier

      return unless identifier

      short_identifier = Pathname.new(identifier).relative_path_from Rails.root

      r = /^#{Regexp.escape(Rails.root.to_s)}\/([^:]+:\d+)/
      caller.find { |line| line.match r }
      called_from = $1

      descriptor = "#{short_identifier} (from #{called_from})"

      if inner.present?
        comment_pattern = "%{partial}"
        template_formats = extract_requested_formats_from(context)
        if template_formats.include?(:text) # Do not render any comments for raw plaintext repsonses
          return inner
        elsif template_formats.include?(:js)
          comment_pattern = "/* begin: %{comment} */\n#{comment_pattern}/* end: %{comment} */"
        elsif template_formats.empty? || template_formats.include?(:html)
          comment_pattern = "<!-- begin: %{comment} -->\n#{comment_pattern}<!-- end: %{comment} -->"
        end

        (comment_pattern % {:partial => inner, :comment => descriptor}).html_safe
      end
    end

    protected

    def template_identifier
      (@template = find_partial) ? @template.identifier : @path
    end
  end
end
