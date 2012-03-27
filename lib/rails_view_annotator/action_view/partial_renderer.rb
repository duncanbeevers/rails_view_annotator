module RailsViewAnnotator
  class ContextError < StandardError
  end

  def self.augment_partial_renderer klass
    render = klass.instance_method :render
    klass.send(:define_method, :render) do |*args|
      inner = render.bind(self).call(*args)
      return unless identifier
      short_identifier = Pathname.new(identifier).relative_path_from Rails.root

      backtrace = nil
      begin
        raise ContextError
      rescue ContextError => e
        backtrace = e.backtrace
      end

      r = /^#{Regexp.escape(Rails.root.to_s)}\/([^:]+:\d+)/
      backtrace.find { |line| line.match r }
      called_from = context = $1

      descriptor = "#{short_identifier} (from #{called_from})"

      if not inner.blank?
        "<!-- begin: #{descriptor} -->\n#{inner}<!-- end: #{descriptor} -->".html_safe
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
