#= require spec_helper

describe 'RestangularModel', ->

  beforeEach module 'RestangularORM'

  beforeEach ->
    inject ( $injector, _$httpBackend_ ) ->
      @RestangularModel = $injector.get 'RestangularModel'
      @http = _$httpBackend_

    class @Person extends @RestangularModel
      @initialize url: 'people'
      constructor: ( data, stream ) ->
        super Person, stream, data



  it "finds models", ->
    id = 11
    @http.expectGET( "/people/#{id}" ).respond 200
    @Person.find( id )
    @http.flush()

  it "sets restangularURL on a class-level", ->
    class SomeModel extends @RestangularModel
    class Message extends SomeModel
      @initialize url: 'messages'

    expect( Message.restangularURL ).toEqual 'messages'
    expect( SomeModel.restangularURL ).toBeUndefined()
