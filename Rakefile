require 'html-proofer'
task :test do
  options = {
    http_status_ignore: [999],
    url_ignore: [/(.*\.)?nichenjie.com/, /twitter.com/],
    assume_extension: true,
    allow_hash_href: true,
    external_only: true,
    empty_alt_ignore: true,
    only_4xx: true
  }
  HTMLProofer.check_directory("./_site/", options).run
end