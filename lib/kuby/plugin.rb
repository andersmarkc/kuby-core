# typed: true
module Kuby
  class Plugin
    attr_reader :environment

    def initialize(environment)
      @environment = environment
      after_initialize
    end

    class << self
      # returns an array of directories containing .rake files
      def task_dirs
        []
      end

      def depends_on(dependable_name, *constraints)
        dependencies << Kuby::Dependency.new(dependable_name, *constraints)
      end

      def dependencies
        @dependencies ||= []
      end
    end

    def configure(&block)
      # do nothing by default
    end

    # install any global resources like operators, etc
    def setup
      # do nothing by default
    end

    # remove all global resources installed by #setup
    def remove
      # do nothing by default
    end

    # additional kubernetes resources that should be deployed
    def resources
      []
    end

    # additional docker images that should be built and pushed
    def docker_images
      []
    end

    # called after all plugins have been configured
    def after_configuration
      # do nothing by default
    end

    # called before any plugins have been setup
    def before_setup
      # do nothing by default
    end

    # called after all plugins have been setup
    def after_setup
      # do nothing by default
    end

    # called before deploying any resources
    def before_deploy(manifest)
      # do nothing by default
    end

    # called after deploying all resources
    def after_deploy(manifest)
      # do nothing by default
    end

    private

    def after_initialize
      # override this in derived classes
    end
  end
end
