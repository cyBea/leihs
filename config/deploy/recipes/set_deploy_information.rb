task :set_deploy_information do
  run "cd #{release_path} && rbenv shell #{rbenv_ruby_version} && RAILS_ENV='production' BRANCH='#{branch}' REVISION_PATH='#{release_path}/REVISION' bundle exec rake leihs:set_deploy_information_footer --trace"
end
