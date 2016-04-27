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
      'admin.users.create': {
        url: '/create',
        templateUrl: 'app/states/admin/users/create/create.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Admin User Create'
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
  function StateController(Staff) {
    var vm = this;

    vm.title = 'Admin User Create';
    vm.activate = activate;

    activate();

    function activate() {
      initStaff();
    }

    // Private

    function initStaff() {
      vm.user = Staff.new();
    }
  }
})();
