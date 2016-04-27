(function() {
  'use strict';

  angular.module('app.components')
    .provider('Forms', FormsProvider);

  function FormsProvider($compileProvider) {
    var provider = {
      register: register,
      $get: FormsHelper
    };

    return provider;

    function register(name, options) {
      var scope = {
        record: '=',
        heading: '@',
        backTo: '@',
        backToParams: '=?',
        subHeading: '@?',
        successMsg: '@?',
        failureMsg: '@?',
        options: '=?',
        debug: '@?'
      };

      $compileProvider.directive(name, FormsDirective);

      function FormsDirective() {
        var directive = {
          restrict: 'E',
          scope: angular.extend(scope, options.scope || {}),
          link: options.link || link,
          templateUrl: options.templateUrl || 'app/components/forms/form.html',
          controller: FormsController,
          controllerAs: 'vm',
          bindToController: true
        };

        return directive;

        function link(scope, element, attrs, vm, transclude) {
          vm.activate();
        }

        /** @ngInject */
        function FormsController($injector, $state, Toasts) {
          var vm = this;

          vm.fields = options.fields;

          vm.activate = activate;
          vm.goBack = goBack;
          vm.hasErrors = hasErrors;
          vm.onSubmit = onSubmit;

          if (angular.isDefined(options.controller)) {
            $injector.invoke(options.controller, this);
          }

          function activate() {
            vm.successMsg = vm.successMsg || 'Save successful!';
            vm.failureMsg = vm.failureMsg || 'Error encountered during save attempt!';
            vm.options = vm.options || {};
            vm.debug = vm.debug || false;
            if (angular.isDefined(vm.afterActivate)) {
              vm.afterActivate();
            }
          }

          function goBack() {
            $state.go(vm.backTo, vm.backToParams || {});
          }

          function hasErrors(field) {
            if (angular.isUndefined(field)) {
              return vm.form.$submitted && vm.form.$invalid;
            }

            return vm.form.$submitted && vm.form[field].$invalid;
          }

          function onSubmit() {
            if (vm.form.$invalid) {
              return false;
            }

            if (vm.record.id) {
              vm.record.$update(saveSuccess, saveFailure);
            } else {
              vm.record.$save(saveSuccess, saveFailure);
            }

            function saveSuccess() {
              Toasts.toast(vm.successMsg);
              goBack();
            }

            function saveFailure(error) {
              var data = error.data;
              var message = vm.failureMsg;

              if (angular.isObject(data) && angular.isDefined(data.error)) {
                message = data.error;
              }

              Toasts.error(message);
            }
          }
        }
      }
    }

    function FormsHelper() {
      var service = {
        fields: fields
      };
      var fieldsMap = {};

      return service;

      function fields(key, field) {
        if (angular.isDefined(field)) {
          fieldsMap[key] = field;
        }

        return fieldsMap[key] || {noFormControl: true, template: '<div>fieldsMap["' + key + '"] is undefined</div>'};
      }
    }
  }
})();
