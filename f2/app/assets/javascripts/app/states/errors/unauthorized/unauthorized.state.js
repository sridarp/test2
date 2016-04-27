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
      'errors.unauthorized': {
        url: '/unauthorized-access',
        templateUrl: 'app/states/errors/unauthorized/unauthorized.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Unauthorized',
        data: {
          layout: 'blank'
        }
      }
    };
  }

  /** @ngInject */
  function StateController() {
    var vm = this;

    vm.title = 'Unauthorized';

    vm.activate = activate;

    activate();

    function activate() {
    }
  }
})();
