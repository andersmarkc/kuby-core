# typed: true
require 'kube-dsl'

module Kuby
  module Plugins
    class NginxIngress < ::Kuby::Plugin
      class Config
        extend ::KubeDSL::ValueFields

        value_fields :provider
      end

      VERSION = '1.1.1'.freeze
      DEFAULT_PROVIDER = 'cloud'.freeze
      NAMESPACE = 'ingress-nginx'.freeze
      SERVICE_NAME = 'ingress-nginx-controller'.freeze

      SETUP_RESOURCES = [
        "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v#{VERSION}/deploy/static/provider/%{provider}/deploy.yaml"
      ].freeze

      def configure(&block)
        @config.instance_eval(&block) if block
      end

      def setup
        Kuby.logger.info('Deploying nginx ingress resources')

        if already_deployed?
          Kuby.logger.info('Nginx ingress already deployed, skipping')
          return
        end

        SETUP_RESOURCES.each do |uri|
          uri = uri % { provider: @config.provider || DEFAULT_PROVIDER }
          kubernetes_cli.apply_uri(uri)
        end

        Kuby.logger.info('Nginx ingress resources deployed!')
      rescue => e
        Kuby.logger.fatal(e.message)
        raise
      end

      def namespace
        NAMESPACE
      end

      def service_name
        SERVICE_NAME
      end

      private

      def already_deployed?
        kubernetes_cli.get_object('Service', NAMESPACE, SERVICE_NAME)
        true
      rescue KubernetesCLI::GetResourceError
        return false
      end

      def after_initialize
        @config = Config.new
      end

      def kubernetes_cli
        environment.kubernetes.provider.kubernetes_cli
      end
    end
  end
end
