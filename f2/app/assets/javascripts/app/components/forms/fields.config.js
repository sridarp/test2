(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    // Generic text input
    Forms.fields('text', {
      key: 'value',
      type: 'text',
      templateOptions: {
        label: 'Text'
      }
    });

    Forms.fields('password', {
      key: 'value',
      type: 'password',
      templateOptions: {
        label: 'Password'
      }
    });

    // Generic textarea
    Forms.fields('textarea', {
      key: 'value',
      type: 'textarea',
      templateOptions: {
        label: 'Describe',
        rows: 3
      }
    });

    // Generic checkbox
    Forms.fields('checkbox', {
      key: 'value',
      type: 'checkbox',
      templateOptions: {
        label: 'Toggle'
      }
    });

    // Generic select
    Forms.fields('select', {
      key: 'value',
      type: 'select',
      templateOptions: {
        label: 'Select',
        options: []
      }
    });

    // Generic date
    Forms.fields('date', {
      key: 'value',
      type: 'date',
      templateOptions: {
        label: 'Date'
      }
    });

    // Generic email
    Forms.fields('email', {
      key: 'value',
      type: 'email',
      templateOptions: {
        label: 'Email'
      }
    });

    // Generic color
    Forms.fields('colorpicker', {
      key: 'value',
      type: 'colorpicker',
      templateOptions: {
        label: 'Color',
        colorPickerFormat: '"hex"',
        colorPickerAlpha: false,
        colorPickerPos: '"top left"',
        colorPickerSwatchBootstrap: false
      }
    });
  }
})();
