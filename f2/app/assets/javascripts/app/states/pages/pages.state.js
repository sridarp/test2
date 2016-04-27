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
      'pages': {
        parent: 'application',
        url: '/pages/:slug',
        templateUrl: 'app/states/pages/page.html',
        title: 'Pages',
        controller: StateController,
        controllerAs: 'vm',
        resolve: {
          page: resolvePage
        },
        data: {
          authorizedRoles: ['user', 'manager', 'admin']
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'pages': {
        type: 'pages',
        state: 'pages',
        label: 'Pages',
        style: 'pages',
        order: 5
      }
    };
  }

  /** @ngInject */
  function resolvePage($stateParams, ContentPage) {
    return ContentPage.get({id: $stateParams.slug}).$promise;
  }

  /** @ngInject */
  function StateController(page) {
    var vm = this;

    vm.page = page;
  }
})();
