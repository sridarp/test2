(function() {
  'use strict';

  angular.module('app.components')
    .factory('EditSettingModal', EditSettingFactory);

  /** @ngInject */
  function EditSettingFactory($modal) {
    var service = {
      showModal: showModal
    };

    return service;

    function showModal(setting) {
      var modalOptions = {
        templateUrl: 'app/components/edit-setting-modal/edit-setting-modal.html',
        controller: EditSettingModalController,
        controllerAs: 'vm',
        resolve: {
          setting: resolveSetting
        },
        windowTemplateUrl: 'app/components/common/modal-window.html'
      };
      var modal = $modal.open(modalOptions);

      return modal.result;

      function resolveSetting() {
        return setting;
      }
    }
  }

  /** @ngInject */
  function EditSettingModalController(setting, Toasts, $modalInstance) {
    var vm = this;

    // Make a copy to modifications are not reflected elsewhere
    vm.setting = angular.copy(setting);
    vm.onSubmit = onSubmit;
    vm.showErrors = showErrors;
    vm.hasErrors = hasErrors;

    activate();

    function activate() {
      determineInputType();
      // TODO: Use formly to create an input with type, error messages, and validation
    }

    function onSubmit() {
      vm.showValidationMessages = true;

      if (vm.form.$valid) {
        vm.setting.$update(updateSuccess, updateFailure);
      }

      function updateSuccess() {
        $modalInstance.close(vm.setting);
        Toasts.toast('Setting successfully saved.');
      }

      function updateFailure() {
        Toasts.error('Server returned an error while updating.');
      }
    }

    function showErrors() {
      return vm.showValidationMessages;
    }

    function hasErrors(field) {
      if (angular.isUndefined(field)) {
        return vm.showValidationMessages && vm.form.$invalid;
      }

      return vm.showValidationMessages && vm.form[field].$invalid;
    }

    // Private

    function determineInputType() {
      var type = 'text';

      // TODO: List is far from complete
      switch (setting.value_type) {
        case 'password':
          type = 'password';
          break;
        case 'json':
        case 'certificate':
          type = 'textarea';
          break;
      }
      vm.inputType = type;
    }
  }
})();
