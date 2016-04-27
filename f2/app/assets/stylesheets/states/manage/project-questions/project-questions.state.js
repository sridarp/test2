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
      'manage.project-questions': {
        url: '/project-questions',
        redirectTo: 'manage.project-questions.list',
        template: '<ui-view></ui-view>'
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {
      'manage.project-questions': {
        type: 'state',
        state: 'manage.project-questions',
        label: 'Project Questions',
        order: 6
      }
    };
  }
})();
