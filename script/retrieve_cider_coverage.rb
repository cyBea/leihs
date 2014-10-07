require 'rubygems'

require 'rest-client'
require 'json'
require 'pry'
require 'simplecov'

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

  def trial_attachment_groups
    trial_attachment_groups = []
    trials.each do |trial|
      trial_url = url(trial["href"])
      single_trial = JSON.parse(RestClient.get(trial_url))
      trial_attachment_groups << single_trial["_links"]["cici:trial-attachments"]
    end
    trial_attachment_groups
  end

  # Takes a regex pattern and returns only hrefs of the attachments that matched the regex.
  def trial_attachment_hrefs(pattern = /.*/)
    matching_tas = []
    trial_attachment_groups.each do |ta|
      trial_attachment_url = url(ta["href"])
      trial_attachment_details = JSON.parse(RestClient.get(trial_attachment_url))
      matching_tas << trial_attachment_details["_links"]["cici:trial-attachment"].select {|ta|
        ta if ta["href"].match(pattern)
      }
    end
    matching_tas.flatten.map {|ta|
      ta["href"]
    }
  end

  def trial_attachment_data(href)
    trial_attachment_details = JSON.parse(RestClient.get(url(href)))
    stream_url = trial_attachment_details["_links"]["data-stream"]["href"]
    stream_url.gsub!("https://195.176.254.43", base_url)
    RestClient.get(stream_url)
  end
end

cc = CiderClient.new
cc.username = username
cc.password = password
cc.execution_id = execution_id

resultsets = []
puts "Gathering coverage data for execution #{cc.execution_id}."
cc.trial_attachment_hrefs(/.*resultset\.json$/).each do |tah|
  puts "Gathering results from #{tah}"
  resultsets << SimpleCov::JSON.parse(cc.trial_attachment_data(tah))
end

results = []
resultsets.each do |resultset|
  resultset.each do |command_name, data|
    fixed_coverage_data = {}
    data["coverage"].each do |k, v|
      # Fix the filenames by stupidly dumping the first three directories the executor used,
      # then adding our current pwd. TODO: Check that we're in Rails.root
      local_path = File.join(k.split("/").reverse.shift(4).reverse.unshift(FileUtils.pwd))
      fixed_coverage_data[local_path] = v
    end
    data["coverage"] = fixed_coverage_data
    result = SimpleCov::Result.from_hash(command_name => data)
    results << result
  end
end

puts "Merging results"
merged = {}
results.each do |result|
  merged = result.original_result.merge_resultset(merged)
end

result = SimpleCov::Result.new(merged)
result.command_name = results.map(&:command_name).sort.join(", ")
formatter = SimpleCov::Formatter::HTMLFormatter.new
formatter.format(result)
puts "Done"
