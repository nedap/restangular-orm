
angular.module 'RestangularORM', [ 'restangular' ]
.factory 'RestangularModel', [ 'Restangular', ( Restangular ) ->

  class RestangularModel extends RelationalModel
    constructor: ->
      super

    @initialize: ( name..., options ) ->
      @restangularURL = options.url
      super name[ 0 ]

    @find: ( id ) ->
      Restangular.one( @restangularURL, id ).get()

    @hasMany: ->
      super
      # make an alias for Restangular.getList()
      # create alias its name with getMethodName()

    @hasOne: ->
      super
      # make an alias for Restangular.one()
      # create alias its name with getMethodName()

    # RelationalModel.belongsTo() calls .hasOne(), so we don't need an alias for that

    @getMethodName: ( property ) ->
      "get#{ property.slice(0,1).toUpperCase() }#{ property.slice(1) }"
]