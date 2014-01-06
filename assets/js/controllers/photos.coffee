@PhotoController = ($scope, $http) ->
  $http(
    method: 'GET'
    url: '/photos/'
  ).success((data, status) ->
    $scope.photos = data
  )
