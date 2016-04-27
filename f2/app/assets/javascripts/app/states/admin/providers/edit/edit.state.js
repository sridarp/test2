(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates());
  }

  function getStates() {
    return {
      'admin.providers.edit': {
        url: '/edit/:providerId',
        templateUrl: 'app/states/admin/providers/edit/edit.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Edit Provider',
        resolve: {
          provider: resolveProvider
        }
      }
    };
  }

  /** @ngInject */
  function resolveProvider($stateParams, Provider) {
    return Provider.get({id: $stateParams.providerId, 'includes[]': ['registered_provider', 'answers']}).$promise;
  }

  /** @ngInject */
  function StateController(lodash, provider) {
    var vm = this;

    vm.title = 'Edit Provider';
    vm.provider = provider;

    vm.activate = activate;

    activate();

    function activate() {
      initProvider();
    }

    // Private

    function initProvider() {
      var questions = angular.copy(provider.registered_provider.questions);

      delete provider.registered_provider;
      angular.forEach(questions, mergeWithAnswer);
      vm.provider.answers = questions;

      function mergeWithAnswer(question) {
        var answer = lodash.find(provider.answers, 'name', question.name);

        angular.extend(question, answer || {});
      }
    }
  }
})();
