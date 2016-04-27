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
      'errors.sorry': {
        url: '/sorry',
        templateUrl: 'app/states/errors/sorry/sorry.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Sorry',
        data: {
          layout: 'blank'
        }
      }
    };
  }

  /** @ngInject */
  function StateController() {
    var vm = this;

    vm.title = 'Sorry';
  }
})();
