module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'
      create_js_examples:
        expand: true
        cwd: 'docs'
        src: ['*.coffee.md']
        dest: 'test'
        ext: '_generated_test.js'

    nodeunit:
      files: ['test/**/*_test.coffee','test/**/*_test.js']

    watch:
      src:
        files: ['src/**/*.coffee']
        tasks: ['coffee']
      lib:
        files: ['lib/**/*.js']
        tasks: ['nodeunit']
      test:
        files: ['test/**/*.coffee']
        tasks: ['nodeunit']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['coffee', 'nodeunit']
