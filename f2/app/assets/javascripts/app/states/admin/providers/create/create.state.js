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
      'admin.providers.create': {
        url: '/create/:registeredProviderId',
        templateUrl: 'app/states/admin/providers/create/create.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Create Provider',
        resolve: {
          registeredProvider: resolveRegisteredProvider
        }
      }
    };
  }

  /** @ngInject */
  function resolveRegisteredProvider($stateParams, registeredProviders, lodash) {
    return lodash.find(registeredProviders, 'id', parseInt($stateParams.registeredProviderId, 10));
  }

  /** @ngInject */
  function StateController(Provider, registeredProvider) {
    var vm = this;

    vm.title = 'Create Provider';

    vm.activate = activate;

    activate();

    function activate() {
      initProvider();
    }

    // Private

    function initProvider() {
      vm.provider = Provider.new({registered_provider_id: registeredProvider.id});
      vm.provider.tags = angular.copy(registeredProvider.tags);
      vm.provider.answers = angular.copy(registeredProvider.questions);
    }
  }
})();
