(function() {
  'use strict';

  angular.module('app.components')
    .config(themeForm);

  /** @ngInject */
  function themeForm(FormsProvider) {
    FormsProvider.register('themeForm', {
      controller: ThemeFormController
    });

    /** @ngInject */
    function ThemeFormController(lodash, Forms) {
      var vm = this;

      init();

      function init() {
        var groups = [
          ['global', 'Site Colors'],
          ['navigation', 'Navigation'],
          ['button', 'Buttons'],
          ['link', 'Links'],
          ['region', 'Regions'],
          ['tables', 'Tables'],
          ['tags', 'Tags'],
          ['modal', 'Modals']
        ];

        vm.fields = lodash.flatten(lodash.map(groups, buildFieldGroup));

        function buildFieldGroup(group) {
          var key = group[0];
          var label = group[1];

          var dataSet = vm.record.config[key];

          return [
            {
              className: 'forms__category',
              template: '<hr />' + label + ':'
            },
            {
              className: 'forms__body',
              fieldGroup: lodash.map(dataSet, buildField)
            }
          ];

          function buildField(data, index) {
            var field = angular.copy(Forms.fields('colorpicker'));
            field.key = 'config[\'' + key + '\'][' + index + '].value';
            field.templateOptions.label = data.label;

            return field;
          }
        }
      }
    }
  }
})();
