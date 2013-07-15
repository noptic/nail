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

    concat:
      options:
        process: (src, filename) ->
          grunt.log.writeln src
          src = src.trim()
          return "\n<section style='backgrond: red' d='#{filename}'>#{src}</section>\n"
    markdown:
      all:
        files: [
          expand: true,
          src: 'index.md',
          dest: './',
          ext: '.html'
          ]
        options:
          template: 'template.jst',
          markdownOptions:
            gfm: true


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-markdown'
  grunt.registerTask 'default', ['coffee', 'nodeunit']
  grunt.registerTask 'page', ['coffee', 'nodeunit', 'concat', 'markdown']
  grunt.registerTask 'gh-pages', 'a sampletask', () ->
    fs = require 'fs'
    _ = require 'underscore'
    marked = require( "marked" )
    result = ''
    nav = ''
    h1Pattern = /<h1>(.*)<\/h1>/
    for file in [
      './README.md'
      './docs/properties.coffee.md'
      './docs/methods.coffee.md'
      ]
      fragment = marked(fs.readFileSync(file).toString().trim())
      h1 = h1Pattern.exec fragment
      if h1
        id = h1[1].replace(' ','-').toLowerCase()
        nav += "<li><a href='##{id}'>#{h1[1]}</a></li>\n"
        grunt.log.writeln h1[1]
      else
        id = file
      result += "\n<section class='section' id='#{id}'>\n#{fragment}\n</section>"
    template = _.template (fs.readFileSync 'template.jst').toString()
    fs.writeFileSync('index.html', template
      content: result,
      navigation: nav
    )
    grunt.log.writeln nav
