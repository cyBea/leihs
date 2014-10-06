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

  # URL starting from the execution, with the passed path appended
  def entry_url(path)
    return "#{base_url}/cider-ci/api/v1/execution/#{@execution_id}/#{path}"
  end

  # URL starting from the base URL root, with the passed path appended
  def url(path)
    return "#{base_url}/#{path}"
  end

  def tasks
    t = JSON.parse(RestClient.get(entry_url("tasks")))
    t["_links"]["cici:task"]
  end

  def trials
    trials = []
    tasks.each do |task|
      task_url = url(task['href'])
      details = JSON.parse(RestClient.get(task_url))
      trials_url = url(details["_links"]["cici:trials"]["href"])
      single_trial = JSON.parse(RestClient.get(trials_url))
      single_trial["_links"]["cici:trial"].each do |st|
        trials << st
      end
    end
    trials
  end

  def trial_attachments(pattern = nil)
    trial_attachments = []
    attachments = []
    trials.each do |trial|
      trial_url = url(trial["href"])
      single_trial = JSON.parse(RestClient.get(trial_url))
      trial_attachments << single_trial["_links"]["cici:trial-attachments"]
    end
    trial_attachments.each do |ta|
      attachment_detail_url = url(ta["href"])
      attachment_details = JSON.parse(RestClient.get(attachment_detail_url))  # 404 happens here
    end
  end

end

cc = CiderClient.new
cc.username = username
cc.password = password
cc.execution_id = "d7a1c121-8f22-471a-8d25-292cb5669883"
cc.trial_attachments

