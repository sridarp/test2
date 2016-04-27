(function() {
  'use strict';

  angular.module('app.components')
    .config(projectQuestionForm);

  /** @ngInject */
  function projectQuestionForm(FormsProvider) {
    FormsProvider.register('projectQuestionForm', {
      fields: [
        {
          className: 'forms__full',
          fieldGroup: [
            {
              key: 'question',
              type: 'text',
              templateOptions: {
                label: 'Question',
                labelClass: 'field__aside--slim',
                required: true
              },
              validation: {
                messages: {
                  required: '"A question must be provided"'
                }
              }
            },
            {
              key: 'help_text',
              type: 'text',
              templateOptions: {
                label: 'Help Text',
                labelClass: 'field__aside--slim'
              }
            },
            {
              key: 'required',
              type: 'checkbox',
              templateOptions: {
                label: 'Answer',
                labelClass: 'field__aside--slim',
                checkboxLabel: 'Required'
              }
            },
            {
              key: 'field_type',
              type: 'select',
              templateOptions: {
                label: 'Question Type',
                labelClass: 'field__aside--slim',
                options: [
                  {label: '"Yes or No"', value: 'yes_no'},
                  {label: 'Multiple Choice', value: 'multiple'},
                  {label: 'Text Input', value: 'text'},
                  {label: 'Date Input', value: 'date'},
                  {label: 'Checkbox Toggle', value: 'checkbox'}
                ],
                onChange: typeChanged
              }
            },
            {
              key: 'options',
              type: 'multiple-options',
              templateOptions: {
                label: '',
                labelClass: 'field__aside--slim',
                noFormControl: true,
                sortableOptions: {
                  axis: 'y',
                  cursor: 'move',
                  handle: '.multiple-option__action--handle',
                  opacity: 0.9,
                  placeholder: 'multiple-options__placeholder'
                }
              },
              hideExpression: 'model.field_type != "multiple"'
            }
          ]
        }
      ]
    });

    function typeChanged(value, field, scope) {
      if ('multiple' !== value) {
        scope.model.options.length = 0;
      } else {
        scope.model.options.push('');
        scope.model.options.push('');
      }
    }
  }
})();
