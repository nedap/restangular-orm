#= require spec_helper

describe 'RestangularModel', ->

  beforeEach module 'RestangularORM'

  beforeEach ->
    @id = 11
    @url = 'people'

    inject ( $injector, _$httpBackend_ ) ->
      @Restangular = $injector.get 'Restangular'
      @RestangularModel = $injector.get 'RestangularModel'
      @http = _$httpBackend_

    class @Organism extends @RestangularModel
    class @Person extends @Organism
      @initialize url: 'people'
      constructor: ( data, stream ) ->
        super Person, stream, data


  it "sets restangularURL on a class-level", ->
    expect( @Person.restangularURL ).toEqual @url
    expect( @Organism.restangularURL ).toBeUndefined()

  it "finds models", ->
    @http.expectGET( "/#{@url}/#{@id}" ).respond 200
    @Person.find @id
    @http.flush()

  it "finds all models", ->
    @http.expectGET( "/#{@url}" ).respond []
    @Person.all()
    @http.flush()

  it "calls Restangular to transform data", ->
    spyOn @Restangular, 'addElementTransformer'
    class SomeModel extends @RestangularModel
    SomeModel.initialize url: 'somewhere'
    expect( @Restangular.addElementTransformer ).toHaveBeenCalled()

  it "transforms single initialized models", ->
    @http.whenGET( "/#{@url}/#{@id}" ).respond { name: 'Kermit' }
    @Person.find( @id ).then ( data ) =>
      expect( data instanceof @Person ).toEqual true
    @http.flush()

  it "transforms multiple initialized models", ->
    @http.whenGET( "/#{@url}" ).respond [{ name: 'Kermit' }]
    @Person.all().then ( data ) =>
      expect( data[0] instanceof @Person ).toEqual true
    @http.flush()
