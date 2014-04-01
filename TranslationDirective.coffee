angular.module('translation').
directive('translation', ($compile, $rootScope, $timeout)->
  return {
    restrict: 'E'
    scope: {
      field:   '@'
      default: '='
      other:   '='
      save:    '&'
    }
    transclude: true
    template: '<span ng-hide="edit" class="text" ng-transclude></span>'+
              '<span ng-show="edit" class="input">'+
                '<input type="text" ng-model="textTranslated" ng-keypress="key($event, textTranslated)" popover="{{ text }}" popover-trigger="mouseenter"/>'+
                '<button ng-click="textMode()">&gt;&gt;</button>'+
              '</span>'
    link: (scope, element, attrs) ->
      scope.translation = false
      scope.edit        = false

      $rootScope.$on('LangBarNewLanguage', ($event, lang)->
        if scope.lang == lang
          scope.textTranslated = scope.text
        else
          scope.textTranslated = ''
        scope.translation = true
      )
      $rootScope.$on('LangBarStopTranslate', ->
        scope.translation = false
      )

      element.on('mouseenter', ->
        if scope.translation
          scope.edit = true
      )
      element.on('mouseleave', ->
        scope.edit = false
      )


      scope.$watch('other', ->
        id    = scope.default.id
        field = scope.field
        if scope.other.hasOwnProperty(id) and scope.other[id].hasOwnProperty(field)
          scope.text           = scope.other[id][field]
          scope.lang           = scope.other[id].lang
        else
          scope.text = scope.default[field]
          scope.lang = scope.default.lang
      )

      scope.textMode = ->
        scope.edit = false

      scope.key = ($event, content) ->
        if $event.keyCode == 13
          scope.edit = false
          scope.save({
            text:  content
            field: scope.field
            id:    scope.default.id
          })
  }
)
