
beforeEach ->
  @isArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
  @inspect = ( obj, recursive=true, newlines=true ) =>
    if @isArray obj
      '[ '+( "#{ @inspect value, false }" for value in obj ).join(", #{ if newlines then '\n    ' else ' ' }")+" ]"
    else if obj?.toString?() == '[object Object]'
      '{ '+( "#{prop}: #{ if recursive || typeof( obj[prop] ) == 'function' then @inspect obj[prop] else obj[prop] }" for prop of obj ).join(", #{ if newlines then '\n    ' else ' ' }")+" }"
    else if typeof( obj ) == 'function'
      'function(){...}'
    else
      obj
