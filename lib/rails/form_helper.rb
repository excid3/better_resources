module ActionView
  module Helpers
    module FormHelper
      def better_form_for(record, options = {}, &block)
        raise ArgumentError, "Missing block" unless block_given?
        html_options = options[:html] ||= {}

        case record
        when String, Symbol
          object_name = record
          object      = nil
        else
          object      = record.is_a?(Array) ? record.last : record
          raise ArgumentError, "First argument in form cannot contain nil or be empty" unless object
          object_name = options[:as] || model_name_from_record_or_class(object).param_key
          apply_better_form_for_options!(record, object, options)
        end

        html_options[:data]   = options.delete(:data)   if options.has_key?(:data)
        html_options[:remote] = options.delete(:remote) if options.has_key?(:remote)
        html_options[:method] = options.delete(:method) if options.has_key?(:method)
        html_options[:enforce_utf8] = options.delete(:enforce_utf8) if options.has_key?(:enforce_utf8)
        html_options[:authenticity_token] = options.delete(:authenticity_token)

        builder = instantiate_builder(object_name, object, options)
        output  = capture(builder, &block)
        html_options[:multipart] ||= builder.multipart?

        html_options = html_options_for_form(options[:url] || {}, html_options)
        form_tag_with_body(html_options, output)
      end

      def apply_better_form_for_options!(record, object, options) #:nodoc:
        object = convert_to_model(object)

        as = options[:as]
        namespace = options[:namespace]
        persisted = object.respond_to?(:persisted?) && object.persisted?
        action, method = persisted ? [:edit, :patch] : [:new, :post]
        options[:html].reverse_merge!(
          class:  as ? "#{action}_#{as}" : dom_class(object, action),
          id:     (as ? [namespace, action, as] : [namespace, dom_id(object, action)]).compact.join("_").presence,
          method: method
        )

        # BetterResource: We need to pass in the action here to get the correct urls for the form
        options[:url] ||= if options.key?(:format)
          polymorphic_path(record, action: action, format: options.delete(:format))
        else
          polymorphic_path(record, action: action)
        end
      end

      def better_form_with(model: nil, scope: nil, url: nil, format: nil, **options)
        options[:allow_method_names_outside_object] = true
        options[:skip_default_ids] = true

        if model
          # BetterResource: We use the edit or new routes instead
          action = model.persisted? ? :edit : :new
          url ||= polymorphic_path(model, action: action, format: format)

          model   = model.last if model.is_a?(Array)
          scope ||= model_name_from_record_or_class(model).param_key
        end

        if block_given?
          builder = instantiate_builder(scope, model, options)
          output  = capture(builder, &Proc.new)
          options[:multipart] ||= builder.multipart?

          html_options = html_options_for_form_with(url, model, options)
          form_tag_with_body(html_options, output)
        else
          html_options = html_options_for_form_with(url, model, options)
          form_tag_html(html_options)
        end
      end
    end
  end
end
