require 'html-proofer'
task :test do
  HTMLProofer.check_directory("./_site/", http_status_ignore: [999]).run
end