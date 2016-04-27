(function() {
  'use strict';

  angular.module('app.components')
    .factory('WizardService', WizardServiceFactory);

  /** @ngInject */
  function WizardServiceFactory($modal, WizardQuestion) {
    var service = {
      showModal: showModal
    };

    return service;

    function showModal() {
      var modalOptions = {
        templateUrl: 'app/components/wizard/wizard-modal.html',
        controller: WizardModalController,
        controllerAs: 'vm',
        resolve: {
          questions: resolveQuestions
        },
        windowTemplateUrl: 'app/components/common/modal-window.html'
      };
      var modal = $modal.open(modalOptions);

      return modal.result;

      function resolveQuestions() {
        return WizardQuestion.query().$promise;
      }
    }
  }

  /** @ngInject */
  function WizardModalController(questions, lodash, $modalInstance, Toasts) {
    var vm = this;

    vm.state = 'intro';
    vm.questions = questions;
    vm.question = null;
    vm.questionPointer = 0;
    vm.answeredQuestions = [];

    vm.startWizard = startWizard;
    vm.answerWith = answerWith;
    vm.questionNavigation = questionNavigation;
    vm.wizardSuccess = wizardSuccess;

    activate();

    function activate() {
    }

    function startWizard() {
      vm.question = vm.questions[vm.questionPointer];
      vm.state = 'wizard';
    }

    function answerWith(index) {
      vm.answeredQuestions[vm.questionPointer] = 0 > index ? -1 : vm.question.wizard_answers[index];

      if (vm.questionPointer < vm.questions.length - 1) {
        vm.questionNavigation(1);
      } else {
        lodash.forEach(vm.answeredQuestions, parseQuestionAnswers);
        vm.state = 'complete';
      }
    }

    function parseQuestionAnswers(item) {
      var filter;

      if (item !== -1) {
        filter = item.tags_to_remove;
        filter.unshift(lodash.union(vm.tags, item.tags_to_add));
        vm.tags = lodash.without.apply(vm, filter);
      }
    }

    function questionNavigation(direction) {
      vm.questionPointer = vm.questionPointer + direction;
      vm.question = vm.questions[vm.questionPointer];
    }

    function wizardSuccess() {
      $modalInstance.close(vm.tags);
      Toasts.toast('Wizard results are shown.');
    }
  }
})();
