require 'rubygems'

require 'rest-client'
require 'json'
require 'pry'



execution_id = ARGV[0]
raise "You must give an execution ID as an argument, e.g.: bundle exec ruby script/retrieve_cider_coverage.rb 37b8408a-8e22-465b-9ae9-ba90b58262fd" if execution_id.nil?

username = ENV['CIDER_USERNAME']
password = ENV['CIDER_PASSWORD']

raise "Please set CIDER_USERNAME and CIDER_PASSWORD." if username.nil? or password.nil?

class CiderClient
  attr_accessor :execution_id
  attr_writer :username, :password

  @execution_id = nil
  @username = nil
  @password = nil

  def base_url
    return "http://#{@username}:#{@password}@ci2.zhdk.ch"
  end

  def url(path)
    return "#{base_url}/cider-ci/api/v1/execution/#{@execution_id}/#{path}"
  end

  def tasks
    t = JSON.parse(RestClient.get(url("tasks")))
    t["_links"]["cici:task"]
  end

  def collect_trials
    trials = []
    tasks.each do |task|
      task_url = "#{base_url}#{task['href']}"
      details = JSON.parse(RestClient.get(task_url))
      trials_url = "#{base_url}#{details["_links"]["cici:trials"]["href"]}"
      trial_details = JSON.parse(RestClient.get(trials_url))
      trial_details["_links"]["cici:trial"].each do |td|
        trials << td
      end
    end
    trials
  end

  def collect_attachments(pattern = nil)
    collect_trials.each do |trial|

    end
  end

end


cc = CiderClient.new
cc.username = username
cc.password = password
cc.execution_id = "37b8408a-8e22-465b-9ae9-ba90b58262fd"
cc.tasks
cc.collect_trials
