module Krill
  class BaseComponent

    include Prawn::View

    attr_reader :view_model
    attr_reader :padding
    attr_reader :subcomponents
    attr_reader :opts

    attr_accessor :document

    DEFAULT_OPTS = {
      padding: [0, 0, 0, 0]
    }

    def initialize(view_model: nil, **opts)

      @view_model    = view_model
      @subcomponents = []
      @opts          = DEFAULT_OPTS.merge(opts)

      # only define data method if view_model arg provided
      if view_model
        self.class.send(:define_method, 'data') do
          @data ||=view_model.data_table.dup
        end
      end

    end

    def add_component *components
      @subcomponents.push(*components)
    end

    def build
      # Abstract method to be overwritten by subclass
    end

    def margin_box
      margin_box_opts = {}
      margin_start_x = (opts[:start_x] || 0) + bounds.left
      margin_start_y = bounds.top - (opts[:start_y] || 0)
      margin_width = (opts[:width] || bounds.right)
      margin_height = opts[:height] if opts[:height]
      margin_box_opts.merge!(width: margin_width)
      margin_box_opts.merge!(height: margin_height) if margin_height

      bounding_box([margin_start_x, margin_start_y], margin_box_opts) do
        # yield
        if opts[:bg]
          fill_color opts[:bg]
          fill_rectangle [0, bounds.top], bounds.right, bounds.top
        end
        yield
        if opts[:border]
          if opts[:border][:bottom]
            fill_color opts[:border][:bottom]
            move_down opts[:padding][2] if opts[:padding][2] > 0 && !opts[:height]
            fill_rectangle [0, 1], bounds.right, 1
          end
        end
      end

    end

    def padding_box
      pad_top    = opts[:padding][0]
      pad_right  = opts[:padding][1]
      pad_bottom = opts[:padding][2]
      pad_left   = opts[:padding][3]

      padding_box_opts = {}
      padding_width = bounds.right - pad_left - pad_right
      padding_height = opts[:height] - pad_top - pad_bottom if opts[:height]
      padding_start_x = bounds.left + pad_left
      padding_start_y = bounds.top - pad_top
      padding_box_opts.merge!(width: padding_width)
      padding_box_opts.merge!(height: padding_height) if padding_height

      bounding_box([padding_start_x, padding_start_y], padding_box_opts) do
        yield
      end
    end

    def draw
      margin_box do
        padding_box do
          yield
        end
        return { height: bounds.height, width: bounds.right, top: bounds.absolute_top, left: bounds.absolute_left }
      end
    end

    def render
      # raise error if you render dangling component
      draw do
        build
        if subcomponents.present?
          subcomponents.each do |component|
            component.render
          end
        end
      end
    end

  end
end
