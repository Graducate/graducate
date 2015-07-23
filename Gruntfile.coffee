"use strict"

module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt

  localConfig = undefined
  try
    localConfig = require("./server/config/local.env")
  catch e
    localConfig = {}


  # Define the configuration for all the tasks
  grunt.initConfig
    remote: (if "win32" is "#{process.platform}" then "git@github.com:" else "https://github.com/") + "Graducate/graducate.git"
    yeoman:
      client: "client"
      dist: "dist"

# --------------------------------------------------------------------------------------

    env:
      prod:
        NODE_ENV: "production"
      all: localConfig

# --------------------------------------------------------------------------------------

    express:
      options:
        port: 9000
      dev:
        options:
          script: ".server/app.js"
          debug: true
      prod:
        options:
          script: "dist/server/app.js"

# --------------------------------------------------------------------------------------

    open:
      server:
        url: "http://localhost:<%= express.options.port %>"

# --------------------------------------------------------------------------------------

    watch:
      injectJS:
        files: [
          "<%= yeoman.client %>/{app,components}/**/*.js"
          "!<%= yeoman.client %>/{app,components}/**/*.spec.js"
          "!<%= yeoman.client %>/{app,components}/**/*.mock.js"
          "!<%= yeoman.client %>/app/app.js"
        ]
        tasks: ["injector:scripts"]
      injectCss:
        files: ["<%= yeoman.client %>/{app,components}/**/*.css"]
        tasks: ["injector:css"]
      injectSass:
        files: ["<%= yeoman.client %>/{app,components,styles}/**/*.{scss,sass}"]
        tasks: ["injector:sass"]
      sass:
        files: ["<%= yeoman.client %>/{app,components,styles}/**/*.{scss,sass}"]
        tasks: [
          "sass"
          "autoprefixer"
        ]
      coffee:
        files: [
          "<%= yeoman.client %>/{app,components}/**/*.{coffee,litcoffee,coffee.md}"
          "!<%= yeoman.client %>/{app,components}/**/*.spec.{coffee,litcoffee,coffee.md}"
        ]
        tasks: [
          "newer:coffee"
          "injector:scripts"
        ]
      coffeeNode:
        files: ['server/**/*.{coffee,litcoffee,coffee.md}']
        tasks: ['newer:coffee']
      gruntfile:
        files: ["Gruntfile.coffee"]
      livereload:
        files: [
          "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.css"
          "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.html"
          "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js"
          "!{.tmp,<%= yeoman.client %>}{app,components}/**/*.spec.js"
          "!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js"
          "<%= yeoman.client %>/assets/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        options:
          livereload: true
      express:
        files: [".server/**/*.{js,json}"]
        tasks: [
          "express:dev"
          "wait"
        ]
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

# --------------------------------------------------------------------------------------

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            ".server"
            "<%= yeoman.dist %>/*"
          ]
        ]

      server: [
        ".tmp"
        ".server"
      ]

# --------------------------------------------------------------------------------------

    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 3 version"]
      dist:
        files: [
          expand: true
          cwd: ".tmp/"
          src: "{,*/}*.css"
          dest: ".tmp/"
        ]

# --------------------------------------------------------------------------------------

    # Debugging with node inspector
    "node-inspector":
      custom:
        options:
          "web-host": "localhost"

# --------------------------------------------------------------------------------------

    # Use nodemon to run server in debug mode with an initial breakpoint
    nodemon:
      debug:
        script: ".server/app.js"
        options:
          nodeArgs: ["--debug-brk"]
          env:
            PORT: process.env.PORT or 9000

          callback: (nodemon) ->
            nodemon.on "log", (event) ->
              console.log event.colour

            # opens browser on initial server start
            nodemon.on "config:update", ->
              setTimeout (->
                require("open") "http://localhost:8080/debug?port=5858"
              ), 500

# --------------------------------------------------------------------------------------

    # Automatically inject Bower components into the app
    wiredep:
      target:
        src: "<%= yeoman.client %>/index.html"
        ignorePath: "<%= yeoman.client %>/"
        exclude: [
          /bootstrap-sass-official/
          /bootstrap.js/
          "/json3/"
          "/es5-shim/"
          /bootstrap.css/
          /font-awesome.css/
        ]

# --------------------------------------------------------------------------------------

    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/public/{,*/}*.js"
            "<%= yeoman.dist %>/public/{,*/}*.css"
            "<%= yeoman.dist %>/public/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            "!<%= yeoman.dist %>/public/bower_components/normalize.css"
          ]

# --------------------------------------------------------------------------------------

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: ["<%= yeoman.client %>/index.html"]
      options:
        dest: "<%= yeoman.dist %>/public"

# --------------------------------------------------------------------------------------

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/public/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/public/{,*/}*.css"]
      js: ["<%= yeoman.dist %>/public/{,*/}*.js"]
      options:
        assetsDirs: [
          "<%= yeoman.dist %>/public"
          "<%= yeoman.dist %>/public/assets/images"
        ]
        # This is so we update image references in our ng-templates
        patterns:
          js: [[
            /(assets\/images\/.*?\.(?:gif|jpeg|jpg|png|webp|svg))/g
            "Update the JS to reference our revved images"
          ]]

# --------------------------------------------------------------------------------------

    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.client %>/assets/images"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
          dest: "<%= yeoman.dist %>/public/assets/images"
        ]

# --------------------------------------------------------------------------------------

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.client %>/assets/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/public/assets/images"
        ]

# --------------------------------------------------------------------------------------

    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngAnnotate:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat"
          src: "*/**.js"
          dest: ".tmp/concat"
        ]

# --------------------------------------------------------------------------------------

    # Package all the html partials into a single javascript payload
    ngtemplates:
      options:
        # This should be the name of your apps angular module
        module: "graducateApp"
        htmlmin:
          collapseBooleanAttributes: true
          collapseWhitespace: true
          removeAttributeQuotes: true
          removeEmptyAttributes: true
          removeRedundantAttributes: true
          removeScriptTypeAttributes: true
          removeStyleLinkTypeAttributes: true
        usemin: "app/app.js"
      main:
        cwd: "<%= yeoman.client %>"
        src: ["{app,components}/**/*.html"]
        dest: ".tmp/templates.js"
      tmp:
        cwd: ".tmp"
        src: ["{app,components}/**/*.html"]
        dest: ".tmp/tmp-templates.js"

# --------------------------------------------------------------------------------------

    # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/public/*.html"]

# --------------------------------------------------------------------------------------

    # Copies remaining files to places other tasks can use
    copy:
      node:
        files: [
          expand: true
          cwd: 'server'
          dest: '.server'
          src: [
            'views/**/*'
          ]
        ]
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.client %>"
            dest: "<%= yeoman.dist %>/public"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "bower_components/**/*"
              "assets/images/{,*/}*.{webp}"
              "assets/fonts/**/*"
              "assets/favicons/**/*"
              "*.html"
            ]
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/public/assets/images"
            src: ["generated/*"]
          }
          {
            expand: true
            cwd: '.server'
            dest: '<%= yeoman.dist %>/server'
            src: [
              '../package.json'
              '**/*'
            ]
          }
        ]
      styles:
        expand: true
        cwd: "<%= yeoman.client %>"
        dest: ".tmp/"
        src: ["{app,components}/**/*.css"]

# --------------------------------------------------------------------------------------

    buildcontrol:
      options:
        dir: "dist"
        commit: true
        push: true
        connectCommits: false
        remote: "<%= remote %>"
        message: "Built %sourceName% from commit %sourceCommit% on branch %sourceBranch%"
      heroku_prod:
        options:
          branch: "deploy-heroku"
      heroku_stage:
        options:
          branch: "deploy-heroku-stage"

# --------------------------------------------------------------------------------------

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee"
        "copy:node"
        "sass"
      ]
      debug:
        tasks: [
          "nodemon"
          "node-inspector"
        ]
        options:
          logConcurrentOutput: true

      dist: [
        "coffee"
        "sass"
        "imagemin"
        "svgmin"
      ]

# --------------------------------------------------------------------------------------

    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ''
      client:
        files: [
          expand: true
          cwd: 'client'
          src: [
            '{app,components}/**/*.coffee'
            '!{app,components}/**/*.spec.coffee'
          ]
          dest: '.tmp'
          ext: '.js'
        ]
      server:
        files: [
          expand: true
          cwd: 'server'
          src: ['**/*.coffee']
          dest: '.server'
          ext: '.js'
          extDot: 'last'
        ]

# --------------------------------------------------------------------------------------

    # Compiles Sass to CSS
    sass:
      server:
        options:
          loadPath: [
            "<%= yeoman.client %>/bower_components"
            "<%= yeoman.client %>/app"
            "<%= yeoman.client %>/components"
            "<%= yeoman.client %>/styles"
          ]
          compass: false
        files:
          ".tmp/app/app.css": "<%= yeoman.client %>/app/app.scss"

# --------------------------------------------------------------------------------------

    eol:
      dist:
        options:
          eol: 'lf'
          replace: true
        files: [
          src: ['<% yeoman.client %>/index.html']
        ]

# --------------------------------------------------------------------------------------

    injector:
      options: {}
      # Inject application script files into index.html (doesn't include bower)
      scripts:
        options:
          transform: (filePath) ->
            filePath = filePath.replace("/client/", "")
            filePath = filePath.replace("/.tmp/", "")
            "<script src=\"" + filePath + "\"></script>"

          starttag: "<!-- injector:js -->"
          endtag: "<!-- endinjector -->"

        files:
          "<%= yeoman.client %>/index.html": [[
            "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js"
            "!{.tmp,<%= yeoman.client %>}/app/app.js"
            "!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.spec.js"
            "!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js"
          ]]

      # Inject component scss into app.scss
      sass:
        options:
          transform: (filePath) ->
            filePath = filePath.replace("/client/app/", "")
            filePath = filePath.replace("/client/components/", "")
            "@import '" + filePath + "';"

          starttag: "// injector"
          endtag: "// endinjector"

        files:
          "<%= yeoman.client %>/app/app.scss": [
            "<%= yeoman.client %>/{app,components}/**/*.{scss,sass}"
            "!<%= yeoman.client %>/app/app.{scss,sass}"
          ]


      # Inject component css into index.html
      css:
        options:
          transform: (filePath) ->
            filePath = filePath.replace("/client/", "")
            filePath = filePath.replace("/.tmp/", "")
            "<link rel=\"stylesheet\" href=\"" + filePath + "\">"

          starttag: "<!-- injector:css -->"
          endtag: "<!-- endinjector -->"

        files:
          "<%= yeoman.client %>/index.html": ["<%= yeoman.client %>/{app,components}/**/*.css"]

# --------------------------------------------------------------------------------------

    bump:
      options:
        files: ["package.json"]
        updateConfigs: []
        commit: true
        createTag: true
        push: true
        pushTo: "origin master"

# --------------------------------------------------------------------------------------

    shell:
      options:
        async: true
      mongo_start:
        command: if 'win32' is "#{process.platform}" then '' else "exec ./bin/mongo_start"
      mongo_stop:
        command: if 'win32' is "#{process.platform}" then '' else "exec ./bin/mongo_stop"


# --------------------------------------------------------------------------------------

  # Used for delaying livereload until after server has restarted
  grunt.registerTask "wait", ->
    grunt.log.ok "Waiting for server reload..."
    done = @async()
    setTimeout (->
      grunt.log.writeln "Done waiting!"
      done()
    ), 1500

# --------------------------------------------------------------------------------------

  grunt.registerTask "express-keepalive", "Keep grunt running", ->
    @async()

# --------------------------------------------------------------------------------------

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "env:all"
        "env:prod"
        "express:prod"
        "wait"
        "open"
        "express-keepalive"
      ])
    if target is "debug"
      return grunt.task.run([
        "clean:server"
        "env:all"
        "injector:sass"
        "concurrent:server"
        "injector"
        "wiredep"
        "autoprefixer"
        "concurrent:debug"
      ])
    grunt.task.run [
      "clean:server"
      "env:all"
      "injector:sass"
      "concurrent:server"
      "injector"
      "wiredep"
      "autoprefixer"
      #"shell:mongo_start"
      "express:dev"
      "wait"
      "open"
      "watch"
    ]

# --------------------------------------------------------------------------------------

  grunt.registerTask "build", [
    "clean:dist"
    "eol"
    "injector:sass"
    "concurrent:dist"
    "injector"
    "wiredep"
    "useminPrepare"
    "autoprefixer"
    "ngtemplates"
    "concat"
    "ngAnnotate"
    "copy:dist"
    "cdnify"
    "cssmin"
    "uglify"
    "rev"
    "usemin"
  ]

# --------------------------------------------------------------------------------------

  grunt.registerTask "default", [
    "build"
  ]

# --------------------------------------------------------------------------------------

  grunt.registerTask "stage", ->
    grunt.task.run [
      #"bump-only:prerelease"
      "default"
      "buildcontrol:heroku_stage"
      #"bump-commit"
    ]

# --------------------------------------------------------------------------------------

  grunt.registerTask "deploy", (target = "patch") ->
    grunt.task.run [
      "bump-only:#{target}"
      "default"
      "buildcontrol:heroku_prod"
      "bump-commit"
    ]