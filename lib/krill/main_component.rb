module Krill
  class MainComponent < BaseComponent

    attr_reader :document
    attr_reader :subcomponents

    def initialize(document)
      @document = document
      @subcomponents = []
    end

    def render
      if subcomponents.present?
        subcomponents.each do |component|
          component.render
        end
      end
    end

    def render!
      render
      document.render
    end

    def add_component *components
      # raise error if you nest a main component
      # raise error if not of component class
      # components = components.each{|sc| sc.document = document}
      components = traverse_components(components)
      @subcomponents.push(*components)
    end

    def traverse_components components
      components.each do |component|
        component.document = document
        if component.subcomponents && component.subcomponents.length > 1
          traverse_components(component.subcomponents)
        end
      end
    end

    def render_to_file filepath
      render
      document.render_file(filepath)
    end

  end
end
