#= require spec_helper

describe 'RestangularModel', ->

  beforeEach ->
    @RestangularModel = @factory 'RestangularModel'

    class @Person extends @RestangularModel
      @initialize url: 'people'
      constructor: ( data, stream ) ->
        super SubClass, stream, data



  it "finds models", ->
    id = 11
    @http.expectGET( "/people/#{id}" )
    @Person.find id
    @http.flush()

  it "sets restangularURL on a class-level", -> # this functionality is already implemented, test should succeed when angular-mocks is up and running
    SomeModel extends @RestangularModel
    Message extends SomeModel
      @initialize url: 'messages'

    expect( Message.restangularURL ).toEqual 'messages'
    expect( SomeModel.restangularURL ).toBeUndefined()
