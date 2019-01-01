require 'html-proofer'
task :test do
  options = {
    http_status_ignore: [999],
    url_ignore: [/(.*\.)?nichenjie.com/]
  }
  HTMLProofer.check_directory("./_site/", options).run
end