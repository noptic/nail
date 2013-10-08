'use strict'
module.exports = (grunt) ->
  fs        = require 'fs'
  glob      = require 'glob'
  _         = require 'underscore'
  path      = require 'path'
  
  configuration = grunt.file.readJSON('build.json')
  #each component requires a .coffe file in src and a coffe.md file in spec
  components  = configuration.build?.components ?[]
  #non component source files
  sourceFiles = configuration.build?.sourceFiles ?[]

  for component in components
    sourceFiles.push "src/#{component}.coffee"

  tests = "#{configuration.path.tests}/**/*.js"
  tasks = "lib/**/*.js"
  links = false

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      options:
        bare: true
      compile:
        files:
          "lib/module.js": sourceFiles
      specs:
        expand: true
        cwd: configuration.path.specs
        src: './**/*.coffee.md'
        dest: configuration.path.tests
        ext: '.js'

    simplemocha:
      options:
        globals: ['should']
        timeout: 3000
        ignoreLeaks: false
        ui: 'bdd'
        reporter: 'spec'
      all:
        src: tests

    instrument:
      files: tasks
      options:
        lazy: false
        basePath: "#{configuration.path.coverage}/instrument/"

    storeCoverage:
      options:
        dir: configuration.path.coverage

    reloadTasks:
      rootPath: "#{configuration.path.coverage}/instrument/lib"

    makeReport:
      src: "#{configuration.path.coverage}/**/*.json"
      options:
        type: "lcov"
        dir: "#{configuration.path.docs}/coverage"
        print: "detail"


    coverage:
      options:
        thresholds:
          'statements': configuration.coverage.statements
          'branches':   configuration.coverage.branches
          'lines':      configuration.coverage.lines
          'functions':  configuration.coverage.functions
        dir: 'coverage/reports',
        root: '.'


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-istanbul-coverage'
  grunt.loadNpmTasks 'grunt-istanbul'

  grunt.registerTask 'test', ['coffee','simplemocha']

  grunt.registerTask 'default', [
    'links'
    'docs'
    'readme'
    'coverageReport'
    'coverage'
  ]

  grunt.registerTask 'coverageReport', [
    'coffee'
    'instrument'
    'reloadTasks'
    'simplemocha'
    'storeCoverage'
    'makeReport'
  ]

  grunt.registerTask 'docs', ['links','write-documentation']
  
  grunt.registerTask 'links', ->
    base      = configuration.path.specs
    extension = configuration.extension.spec
    files = glob.sync "#{base}/**/*#{extension}"
    
    grunt.verbose.writeln "Link files:"
    grunt.verbose.writeln files.join("\n")
    
    links =
      external: ''
      perDirectory:    {}
      manual:    ''
      
    mdLink = (name,url) -> "[#{name}]: #{url}\n"
    
    #get internal links
    directories = _.uniq( _.map(files, path.dirname) )
    directories.push '.'
    for directory in directories 
      links.perDirectory[directory] = ''
      for file in files
        name = file
            .substring(base.length+1,file.length - extension.length)
            .replace('/','.')
        links.perDirectory[directory] += mdLink(
            name, 
            path.relative(directory, file)
        )

    #get external Links
    for packageFile in  glob.sync 'node_modules/*/package.json'
      packageInfo = require "./#{packageFile}"
      linkAdress = packageInfo.homepage ? "https://npmjs.org/package/#{[packageInfo.name]}"
      links.external += mdLink(packageInfo.name, linkAdress)
    
    #manualLinks
    for name,url of configuration.see
      links.manual += mdLink(name,url)
    
  grunt.registerTask 'write-documentation', ->
    target    = configuration.path.docs
    base      = configuration.path.specs
    extension = configuration.extension.spec
    
    files = glob.sync "#{base}/**/*#{extension}"
    for directory,specs of _.groupBy(files, path.dirname)
      targetDirectory = '.'
      for dir in (target + directory.substring(base.length)).split('/')
        targetDirectory += "/#{dir}"
        if ! fs.existsSync(targetDirectory)
          fs.mkdirSync targetDirectory
      for spec in specs
        fs.writeFileSync(targetDirectory+'/'+path.basename(spec), [
            links.external
            links.perDirectory[directory]
            links.manual
            fs.readFileSync(spec).toString()
          ].join("\n")
        )

  grunt.registerTask 'readme', ->
    packageInfo = require './package.json'
    readme      = ['']
    
    if (!links) 
      grunt.task.run('links')
    readme.push [links.external, links.manual, links.perDirectory['.']].join("\n")
    readme.push fs.readFileSync 'spec/About.coffee.md'
    readme.push """
      
      ##Setup
      Install with npm:
      ```bash
      npm install #{packageInfo.name}
      ```
      
      Clone with GIT:
      ```bash
      git clone #{packageInfo.repository.url}
      ```
      
      ##Documentation
      Head here → [#{configuration.path.docs}](#{configuration.path.docs})
      
                """
    for dependencyType in ['dependencies', 'devDependencies']
      if (_.has packageInfo, dependencyType)
        title = dependencyType.charAt(0).toUpperCase() + dependencyType.slice(1)
        readme.push "###{title}"
        for name,version of packageInfo[dependencyType]
          readme.push " - [#{name}] #{version}"
        readme.push('')
    fs.writeFileSync('README.md', readme.join("\n"))
    
    