(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper, navigationHelper) {
    routerHelper.configureStates(getStates());
    navigationHelper.navItems(navItems());
  }

  function navItems() {
    return {};
  }

  function getStates() {
    return {
      'login': {
        parent: 'blank',
        url: '/login',
        templateUrl: 'app/states/login/login.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Login',
        resolve: {
          motd: resolveMotd
        }
      }
    };
  }

  /** @ngInject */
  function resolveMotd(Motd) {
    return Motd.get().$promise;
  }

  /** @ngInject */
  function StateController(motd) {
    var vm = this;

    vm.title = 'Login';
    vm.motd = motd;
    activate();

    function activate() {
    }
  }
})();
