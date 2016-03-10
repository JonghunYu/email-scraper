module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      glob_to_multiple:
        expand: true
        options:
          bare: true
        src: [
          'scraper.coffee'
        ]
        ext: '.js'

    watch:
      files: [
        'scraper.coffee'
      ]
      tasks: ['coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.registerTask 'default', ['coffee']
