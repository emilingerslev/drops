exports.config =
  minMimosaVersion: "1.0.0"
  # require:
  #   tracking:
  #     enabled: true
  # modules:['bower','require','server','minify','live-reload','web-package', 'combine']
  modules:['bower','server','minify','live-reload','web-package', 'combine', 'copy', 'coffeescript', 'stylus', 'jade']
  watch:
    sourceDir: "assets"
    compiledDir: "public"
  server:
    defaultServer:
      enabled: true
  template:
    wrapType: 'none'
  copy: 
    extensions: ["js","css","png","jpg","jpeg","gif","html","eot","svg","ttf","woff","otf","yaml","kml","ico","htc","htm","json","txt","xml","xsd","map","md","mp4","xap"]
  # minify:
    # exclude:[/\.min\./, "javascripts/main.js"]
  # bower:
  #   copy:
  #     strategy:
  #       '*': "vendorRoot"
  #     mainOverrides:
  #       chosen: ["chosen.jquery.js", "chosen.css", "chosen-sprite.png"]
  #       bootstrap: ["./docs/assets/js/bootstrap.js", "./docs/assets/css/bootstrap-responsive.css", "./docs/assets/css/bootstrap.css"]
  #       'bootstrap-switch': ["./static/js/bootstrap-switch.js", "./static/stylesheets/bootstrap-switch.css"]
  #       'bootstrap-notify': ["./js/bootstrap-notify.js", "./css/bootstrap-notify.css"]
  # combine:
  #   folders: [
  #     {
  #       folder: "stylesheets/vendor"
  #       output: "stylesheets/vendor/vendor.css"
  #     }
  #     {
  #       folder: "stylesheets/views"
  #       output: "stylesheets/application.css"
  #     }
  #   ]
