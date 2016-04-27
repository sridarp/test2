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
      'services.list': {
        url: '', // No url, this state is the index of projects
        templateUrl: 'app/states/services/list/list.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Services',
        resolve: {
          services: resolveServices
        }
      }
    };
  }

  /** @ngInject */
  function resolveServices(Service) {
    return Service.query({'includes[]': ['product', 'project']}).$promise;
  }

  /** @ngInject */
  function StateController($state, services, lodash) {
    /* jshint validthis: true */
    var vm = this;

    vm.services = services;

    vm.activate = activate;
    vm.title = 'Services';
    vm.goTo = goTo;

    activate();

    function activate() {
      initServices();
    }

    function goTo(serviceId, productId) {
      $state.go('services.details', {serviceId: serviceId, productId: productId});
    }

    // Private

    function initServices() {
      vm.projects = lodash.groupBy(lodash.map(services, mapService), 'project_id');

      function mapService(service) {
        var project = service.project;

        delete service.project;

        service.project_id = project.id;
        service.project = project.name;

        return service;
      }
    }
  }
})();
