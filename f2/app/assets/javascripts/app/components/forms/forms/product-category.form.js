(function() {
  'use strict';

  angular.module('app.components')
    .config(form);

  /** @ngInject */
  function form(FormsProvider) {
    FormsProvider.register('productCategoryForm', {
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
                  required: '"A category name must be provided"'
                }
              }
            },
            {
              key: 'description',
              type: 'textarea',
              templateOptions: {
                label: 'Description',
                required: true
              },
              validation: {
                messages: {
                  required: '"A description must be provided"'
                }
              }
            },
            {
              key: 'tags',
              type: 'tags',
              templateOptions: {
                label: 'Tag(s)',
                minTags: 1
              },
              validation: {
                messages: {
                  minTags: '"At least one tag must be used"'
                }
              }
            }
          ]
        }
      ]
    });
  }
})();
