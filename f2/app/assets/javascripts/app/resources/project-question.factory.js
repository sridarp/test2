(function() {
  'use strict';

  angular.module('app.resources')
    .factory('ProjectQuestion', ProjectQuestionFactory);

  /** @ngInject */
  function ProjectQuestionFactory($resource, lodash) {
    var ProjectQuestion = $resource('/api/v1/project_questions/:id' , {id: '@id'}, {
      'update': {
        method: 'PUT',
        isArray: false
      },
      'reposition': {
        method: 'PUT',
        url: '/api/v1/project_questions/:id/reposition',
        isArray: false
      }
    });

    ProjectQuestion.defaults = {
      question: '',
      help: '',
      required: false,
      field_type: 'yes_no',
      options: []
    };

    ProjectQuestion.optionDefaults = {
      option: '',
      include: [],
      exclude: [],
      position: 0
    };

    ProjectQuestion.new = newProjectQuestion;

    ProjectQuestion.prototype.asField = asField;

    return ProjectQuestion;

    function newProjectQuestion() {
      return new ProjectQuestion(angular.copy(ProjectQuestion.defaults));
    }

    function asField() {
      /*jshint validthis: true */
      var self = this;

      var field = {
        name: self.uuid,
        value_type: 'string',
        label: self.question,
        required: self.required
      };

      setFieldType();

      return field;

      function setFieldType() {
        switch (self.field_type) {
          case 'yes_no':
            field.options = [
              {label: 'Yes', value: 'Yes'},
              {label: 'No', value: 'No'}
            ];
            field.field = 'select';
            break;
          case 'multiple':
            field.options = lodash.map(self.options, asOption);
            field.field = 'select';
            break;
          default:
            field.field = self.field_type;
        }
      }

      function asOption(option) {
        return {label: option, value: option};
      }
    }
  }
})();
