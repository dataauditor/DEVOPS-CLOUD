#!/usr/bin/env ruby


#
#  Copyright 2017 Amazon.com
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.



require 'rubygems'  # not necessary for Ruby 1.9
require 'mongo'

port = ARGV.first || '27017'

# Connect to db. Located here to make it easy to change port etc...
db = Mongo::Client.new([ '127.0.0.1:' + port ], :database => 'dms_sample')
Mongo::Logger.logger       = ::Logger.new('./log/load_name_data.log')
Mongo::Logger.logger.level = ::Logger::INFO

# Load data from the file
fname = ARGV.first || './data/name_data.sql'

puts "loading name data from: " + fname

name_hash = {}
File.open(fname).each_with_index do |r,idx|

  unless r.chomp.empty?
    r =  r.slice(r.rindex('values (') +8, r.length).strip.chomp(');')  

    vals = r.split(',').map{ |v| v.sub(/'/,'').chomp("'") }
    vals = vals.map{ |v| v == vals[0] ? v.to_sym : v }

    if name_hash[vals[0]] 
      name_hash[vals[0]] << vals[1]
    else
      name_hash[vals[0]] = [vals[1]]
    end

  end
end

# Load Mongo collection
name_data = db[:name_data]
result = name_data.drop
result = name_data.insert_one(name_hash)
puts "inserted: " + result.n.to_s + " name records"
