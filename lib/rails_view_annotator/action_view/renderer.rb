require 'action_view/renderer/renderer'
require 'rails_view_annotator/partial_renderer'

module ActionView
  class Renderer
    def render_partial(context, options, &block) #:nodoc:
      RailsViewAnnotator::PartialRenderer.new(@lookup_context).render(context, options, block)
    end
  end
end
