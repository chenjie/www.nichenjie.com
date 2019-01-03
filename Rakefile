require 'html-proofer'
task :test do
  options = {
    http_status_ignore: [999],
    url_ignore: [/(.*\.)?nichenjie.com/],
    assume_extension: true,
    allow_hash_href: true
  }
  HTMLProofer.check_directory("./_site/", options).run
end