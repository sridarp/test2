(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper, navigationHelper) {
    routerHelper.configureStates(getStates());
    navigationHelper.navItems(navItems());
    navigationHelper.sidebarItems(sidebarItems());
  }

  function getStates() {
    return {
      'admin.users.edit': {
        url: '/edit/:id',
        templateUrl: 'app/states/admin/users/edit/edit.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Admin User Edit',
        resolve: {
          user: resolveUser
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {};
  }

  /** @ngInject */
  function resolveUser(Staff, $stateParams) {
    return Staff.get({id: $stateParams.id}).$promise;
  }

  /** @ngInject */
  function StateController($stateParams, user) {
    var vm = this;

    vm.title = 'Admin User Edit';
    vm.activate = activate;
    vm.user = user;

    activate();

    function activate() {
    }
  }
})();
