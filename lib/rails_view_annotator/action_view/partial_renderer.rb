module RailsViewAnnotator
  # Tells for which formats the partial has been requested.
  def self.extract_requested_formats_from(render_arguments)
    lookup_context = render_arguments[0].lookup_context
    lookup_context.formats
  end

  def self.augment_partial_renderer klass
    stock_render = klass.instance_method :render
    klass.send(:define_method, :render) do |*args|
      inner = stock_render.bind(self).call(*args)

      return unless identifier

      short_identifier = Pathname.new(identifier).relative_path_from Rails.root

      r = /^#{Regexp.escape(Rails.root.to_s)}\/([^:]+:\d+)/
      caller.find { |line| line.match r }
      called_from = context = $1

      descriptor = "#{short_identifier} (from #{called_from})"

      if inner.present?
        template_formats = RailsViewAnnotator.extract_requested_formats_from(args)
        case template_formats.first
        when :js then
          "/* begin: #{descriptor} */\n#{inner}/* end: #{descriptor} */"
        when :html, nil then
          "<!-- begin: #{descriptor} -->\n#{inner}<!-- end: #{descriptor} -->".html_safe
        else # Do not render any comments for unrecognized formats
          inner
        end
      end
    end
    klass.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def identifier
      (@template = find_partial) ? @template.identifier : @path
    end
  end
end
