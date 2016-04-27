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
      'manage.wizard-questions': {
        url: '/wizard-questions',
        redirectTo: 'manage.wizard-questions.list',
        template: '<ui-view></ui-view>'
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'manage.alerts': {
        type: 'state',
        state: 'manage.wizard-questions',
        label: 'Wizard Questions',
        order: 9
      }
    };
  }
})();
