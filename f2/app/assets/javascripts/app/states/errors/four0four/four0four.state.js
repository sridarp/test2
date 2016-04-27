(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates(), '/errors/404');
  }

  function getStates() {
    return {
      'errors.four0four': {
        url: '/404',
        templateUrl: 'app/states/errors/four0four/four0four.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Not Found : 404',
        params: {
          toState: null
        }
      }
    };
  }

  /** @ngInject */
  function StateController($stateParams) {
    var vm = this;

    vm.state = '';

    if ($stateParams.toState) {
      vm.state = $stateParams.toState.to;
    }
  }
})();
