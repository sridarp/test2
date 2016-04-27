(function() {
  'use strict';

  angular.module('app.components')
    .config(orderForm);

  /** @ngInject */
  function orderForm(FormsProvider) {
    FormsProvider.register('orderForm', {
      fields: [
        {
          className: 'forms__body',
          fieldGroup: [
            {
              key: 'name',
              type: 'text',
              model: 'model.service',
              templateOptions: {
                label: 'Service Name',
                required: true
              },
              validation: {
                messages: {
                  required: '"A service name must be provided"'
                }
              }
            },
            {
              key: 'project_id',
              type: 'data_select',
              templateOptions: {
                label: 'Project',
                options: [],
                labelProp: 'name',
                valueProp: 'id',
                dataKey: 'projects',
                required: true
              },
              validation: {
                messages: {
                  required: '"You must select a project for the service to belong to"'
                }
              }
            },
            {
              key: 'answers',
              type: 'questions'
            }
          ]
        }
      ]
    });
  }
})();
