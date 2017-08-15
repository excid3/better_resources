module ActionDispatch::Routing
  class Mapper
    def better_resources(*resources, &block)
      options = resources.extract_options!.dup

      if apply_common_behavior_for(:resources, resources, options, &block)
        return self
      end

      with_scope_level(:resources) do
        options = apply_action_options options
        resource_scope(Resource.new(resources.pop, api_only?, @scope[:shallow], options)) do
          yield if block_given?

          concerns(options[:concerns]) if options[:concerns]

          collection do
            get  :index if parent_resource.actions.include?(:index)
          end

          new do
            get :new
            # BetterResource: The create action belongs at /resources/new
            post :create if parent_resource.actions.include?(:create)
          end if parent_resource.actions.include?(:new)

          member do
            get :edit if parent_resource.actions.include?(:edit)
            get :show if parent_resource.actions.include?(:show)
            # BetterResource: Edit routes should be /resource/:id/edit but hit the update action
            if parent_resource.actions.include?(:update)
              patch :edit, action: :update
              put   :edit, action: :update
            end
            delete :destroy if parent_resource.actions.include?(:destroy)
          end
        end
      end

      self
    end
  end
end
