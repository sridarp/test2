(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates());
  }

  function getStates() {
    return {
      'services.details': {
        url: '/:serviceId',
        title: 'Service Details',
        templateProvider: templateProvider,
        controllerProvider: controllerProvider,
        controllerAs: 'vm',
        resolve: {
          service: resolveService
        }
      }
    };
  }

  /** @ngInject */
  function resolveService(Service, $stateParams) {
    var includes = ['order', 'product', 'project', 'provider', 'service_outputs', 'logs'];

    return Service.get({id: $stateParams.serviceId, 'includes[]': includes}).$promise;
  }

  /** @ngInject */
  function templateProvider($templateFactory, StateOverride, service) {
    var templateUrl = 'app/states/services/details/details.html';
    var override = StateOverride.get('services.details', {service: service}) || {templateUrl: templateUrl};

    return $templateFactory.fromUrl(override.templateUrl);
  }

  /** @ngInject */
  function controllerProvider(StateOverride, service) {
    var controller = StateController;
    var override = StateOverride.get('services.details', {service: service}) || {controller: controller};

    return override.controller;
  }

  /** @ngInject */
  function StateController(service) {
    var vm = this;

    vm.title = 'Service Details';

    vm.service = service;
    vm.logs = service.logs;

    vm.activate = activate;

    activate();

    function activate() {
    }
  }
})();
