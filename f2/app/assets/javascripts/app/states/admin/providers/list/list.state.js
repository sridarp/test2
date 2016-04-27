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
      'admin.providers.list': {
        url: '',
        templateUrl: 'app/states/admin/providers/list/list.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Providers List',
        resolve: {
          providers: resolveProviders
        }
      }
    };
  }

  /** @ngInject */
  function resolveProviders(Provider) {
    return Provider.query().$promise;
  }

  /** @ngInject */
  function StateController($state, providers, ProviderTypeModal) {
    var vm = this;

    vm.title = 'Providers List';

    vm.providers = providers;

    vm.activate = activate;
    vm.showModal = showModal;
    vm.edit = edit;

    activate();

    function activate() {
    }

    function showModal() {
      ProviderTypeModal.showModal().then(handleResult);

      function handleResult(registeredProvider) {
        $state.go('admin.providers.create', {registeredProviderId: registeredProvider.id});
      }
    }

    function edit(provider) {
      $state.go('admin.providers.edit', {providerId: provider.id});
    }
  }
})();
