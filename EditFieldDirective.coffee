angular.module('translation').
directive('editField', ->
  return {
    restrict: 'E'
    scope:
      ngModel: '='
      type:    '@'
      lang:    '='
      save:    '&'
    template: '<span ng-hide="edit" ng-click="edit=true" type="text">{{ ngModel }}</span>'+

              '<input ng-show="type==\'input\' && translation" type="text" ng-model="ngModel" disabled/>'+
              '<input ng-show="type==\'input\' && edit       " type="text" ng-model="value" style="width:80%" ng-disabled="loading" ng-keypress="keypress($event)" focus="edit" ng-blur="edit=false"/>'+

              '<textarea ng-show="type == \'textarea\' && translation" ng-model="ngModel" disabled></textarea>'+
              '<textarea ng-show="type == \'textarea\' && edit       " ng-model="value" ng-disabled="loading" ng-keyup="change=true" focus="edit" ng-blur="edit=false"></textarea>'+

              '<span ng-show="loading" us-spinner="{width:2,length:6,radius:5}"></span>'+

              '<span ng-show="edit && !loading">'+
                '<button ng-click="goSave()" class="btn btn-default glyphicon glyphicon-ok"     style="color:green;"></button>'+
                '<button ng-click="cancel()" class="btn btn-default glyphicon glyphicon-remove" style="color:red;  "></button>'+
              '</span>'

    link: (scope, element, attrs) ->
      scope.change = false
      scope.edit   = false

      scope.$on('EditFieldTranslationOn', ->
        scope.translation = true
        scope.ngModel     = ''
      )
      scope.$watch('lang', ->
        scope.value       = angular.copy(scope.ngModel)
        scope.translation = false
      )

      scope.keypress = ($event) ->
        if $event.key == 'Enter'
          scope.goSave()
        else if $event.key == 'Esc'
          scope.edit = false
          $event.preventDefault()
        else
          scope.change = true

      scope.goSave = ->
        if scope.change == false
          return scope.cancel()

        scope.loading = true

        scope.save({value:scope.value}).then(
          (data) -> #Success
            scope.loading     = false
            scope.translation = false
            scope.edit        = false
            scope.ngModel     = angular.copy(scope.value)
          ,(err) -> #Error
            scope.loading = false
        )

      scope.cancel = ->
        scope.value   = scope.ngModel
        scope.edit    = false
        scope.change  = false
  }
)
