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
      'manage.wizard-questions.create': {
        url: '/create',
        templateUrl: 'app/states/manage/wizard-questions/create/create.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Manage Create Wizard Question'
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
  function StateController(logger, WizardQuestion) {
    var vm = this;

    vm.title = '';

    vm.activate = activate;

    activate();

    function activate() {
      initQuestion();
      initAnswers();
      logger.info('Activated Manage Create Wizard Question View');
    }

    function initQuestion() {
      vm.question = WizardQuestion.new();
    }

    function initAnswers() {
      vm.question.wizard_answers = [];
      vm.question.wizard_answers.push(angular.extend({}, angular.copy(WizardQuestion.answerDefaults)));
      vm.question.wizard_answers.push(angular.extend({}, angular.copy(WizardQuestion.answerDefaults)));
    }
  }
})();
