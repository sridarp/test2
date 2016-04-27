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
      'manage.project-questions.edit': {
        url: '/edit/:projectQuestionId',
        templateUrl: 'app/states/manage/project-questions/edit/edit.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Manage Project Question Edit',
        resolve: {
          projectQuestion: resolveProjectQuestion
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
  function resolveProjectQuestion(ProjectQuestion, $stateParams) {
    return ProjectQuestion.get({id: $stateParams.projectQuestionId}).$promise;
  }

  /** @ngInject */
  function StateController(projectQuestion) {
    var vm = this;

    vm.title = 'Manage Project Question Edit';
    vm.activate = activate;

    activate();

    function activate() {
      vm.projectQuestion = projectQuestion;
    }
  }
})();
