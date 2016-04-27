(function() {
  'use strict';

  angular.module('app.components')
    .config(providerForm);

  /** @ngInject */
  function providerForm(FormsProvider) {
    FormsProvider.register('providerForm', {
      fields: [
        {
          className: 'forms__body',
          fieldGroup: [
            {
              key: 'name',
              type: 'text',
              templateOptions: {
                label: 'Name',
                required: true
              },
              validation: {
                messages: {
                  required: '"A provider name must be provided"'
                }
              }
            },
            {
              key: 'description',
              type: 'textarea',
              templateOptions: {
                label: 'Description'
              }
            },
            {
              key: 'active',
              type: 'checkbox',
              templateOptions: {
                label: 'Available',
                checkboxLabel: 'Active'
              }
            },
            {
              key: 'answers',
              type: 'questions'
            },
            {
              key: 'tags',
              type: 'tags',
              templateOptions: {
                label: 'Tags'
              }
            }
          ]
        }
      ]
    });
  }
})();
