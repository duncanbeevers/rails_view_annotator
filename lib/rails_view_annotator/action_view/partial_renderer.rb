module RailsViewAnnotator
  def self.augment_partial_renderer klass
    render = klass.instance_method :render
    klass.send(:define_method, :render) do |*args|
      inner = render.bind(self).call(*args)
      return unless identifier
      short_identifier = Pathname.new(identifier).relative_path_from Rails.root

      r = /^#{Regexp.escape(Rails.root.to_s)}\/([^:]+:\d+)/
      caller.find { |line| line.match r }
      called_from = context = $1

      descriptor = "#{short_identifier} (from #{called_from})"

      if not inner.blank?
        comment_pattern = "%{partial}"

        template_formats = Array(args[1][:formats])
        if template_formats.include?(:js)
          comment_pattern = "/* begin: %{comment} */\n#{comment_pattern}/* end: %{comment} */"
        elsif template_formats.empty? || template_formats.include?(:html)
          comment_pattern = "<!-- begin: %{comment} -->\n#{comment_pattern}<!-- end: %{comment} -->"
        end

        (comment_pattern % {:partial => inner, :comment => descriptor}).html_safe
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
