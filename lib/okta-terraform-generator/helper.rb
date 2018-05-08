#
# Copyright 2018 Stephen Hoekstra <shoekstra@schubergphilis.com>
# Copyright 2018 Schuberg Philis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'fileutils'
require 'json'
require 'pp'

module OktaTerraformGenerator
  module Helper
    def add_to_resource_hash(resource_config)
      resources['resource'][resource].merge!(resource_config)
    end

    def print_usage
      puts opt_parser
    end

    def resource_name_exists?(resource_name)
      resources['resource'][resource].key? resource_name
    end

    def resource
      @resource ||= cli_arguments.shift
    end

    def resources
      @resources ||= { 'resource' => { resource => {} } }
    end

    def write_tf_file(tf_file, content)
      File.open(tf_file, 'w') do |f|
        f.write(JSON.pretty_generate(content) + "\n")
        puts "\nWrote generated JSON to #{tf_file}"
      end
    end
  end
end
