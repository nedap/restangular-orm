
angular.module 'RestangularORM', [ 'restangular' ]
.provider 'notificationStream', [()->
  @stream = new Bacon.Bus
  @$get = ()=>
    @stream
  @setStream = (newStream) =>
    @stream = newStream
  null
]
.factory 'RestangularModel', [ 'Restangular', 'notificationStream', ( Restangular, stream ) ->

  class RestangularModel extends RelationalModel
    constructor: ( data ) ->
      super

    @initialize: ( name..., options ) ->
      @restangularURL = options.url

      Restangular.addElementTransformer options.url, false, (data) =>
        if options.factory && @hasOwnProperty( options.factory ) && typeof(@[ options.factory ]) == 'function'
          @[ options.factory ]( data, this, stream )
        else
          new this( data, this, stream )

      super name[ 0 ]

    @find: ( id ) ->
      Restangular.one( @restangularURL, id ).get()

    @all: ->
      Restangular.all( @restangularURL ).getList()

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
      "fetch#{ property.slice(0,1).toUpperCase() }#{ property.slice(1) }"
]