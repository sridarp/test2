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
      'admin.theme': {
        url: '/theme',
        templateUrl: 'app/states/admin/theme/theme.html',
        controller: ThemeController,
        controllerAs: 'vm',
        title: 'Theme',
        resolve: {
          theme: resolveTheme
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'admin.theme': {
        type: 'state',
        state: 'admin.theme',
        label: 'Theme',
        order: 4
      }
    };
  }

  /** @ngInject */
  function resolveTheme(Theme) {
    return Theme.query({}).$promise;
  }

  /** @ngInject */
  function ThemeController(theme) {
    var vm = this;

    vm.title = 'Theme';

    vm.theme = theme;

    vm.activate = activate;

    activate();

    function activate() {
    }
  }
})();
