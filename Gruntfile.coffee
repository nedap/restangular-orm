
module.exports = ( grunt ) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    filename: '<% pkg.name %>'

    coffee:
      default:
        options:
          bare: true
        files:
          'dist/<%= pkg.name %>.js': [ 'src/restangular_model.coffee' ]
      test:
        expand: true
        src: [ 'src/**/*.coffee', 'test/**/*.coffee' ]
        dest: 'tmp'
        ext: '.js'
        options:
          bare: true

    clean: [ 'tmp' ]

    jasmine:
      default:
        src: [ 'lib/**/*.js', 'tmp/src/**/*.js', 'test/support/angular-mocks.js' ]
        options:
          specs: 'tmp/test/**/*_spec.js'
          helpers: [ 'tmp/test/**/*_helper.js' ]

    bower:
      install: {}

    bump:
      options:
        files: [ 'package.json', 'bower.json' ]
        commitFiles: [ 'package.json', 'bower.json', 'dist/<%= pkg.name %>.js' ]
        tagName: '%VERSION%'
        pushTo: 'origin'


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-bump'

  grunt.registerTask 'release',       [ 'coffee', 'bump' ]
  grunt.registerTask 'release:major', [ 'coffee', 'bump:major' ]
  grunt.registerTask 'release:minor', [ 'coffee', 'bump:minor' ]
  grunt.registerTask 'release:patch', [ 'coffee', 'bump:patch' ]
  grunt.registerTask 'test',          [ 'coffee:test', 'jasmine', 'clean' ]
  grunt.registerTask 'install',       [ 'bower:install' ]
