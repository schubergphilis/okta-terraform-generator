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

require 'facets/string'
require 'mixlib/cli'
require 'okta-terraform-generator/helper'
require 'oktakit'
require 'oktakit/client/extended_groups'

Dir[File.dirname(__FILE__) + '/cli/*.rb'].each { |file| require file }

module OktaTerraformGenerator
  class CLI
    include Mixlib::CLI
    include OktaTerraformGenerator::Helper

    banner 'Usage: okta-terraform-generator [--version] GENERATOR (options)'

    def load_generator
      if ARGV.empty?
        print_usage
        print_generators
        exit 1
      end

      if ARGV.any? { |arg| arg.casecmp('--version').zero? }
        puts "okta-terraform-generator v#{OktaTerraformGenerator::VERSION}"
        exit 0
      end

      Object.const_get("OktaTerraformGenerator::CLI::#{generator_class}").new
    end

    private

    def generator_class
      generator_name.capitalize.camelcase
    end

    def generator_name
      validate_generator
    end

    def print_generators
      puts "\nThe following resource generators are available:\n"
      valid_generators.each do |valid_generator|
        puts "  * #{valid_generator}"
      end
      puts ''
    end

    def valid_generators
      Dir[File.dirname(__FILE__) + '/cli/*.rb'].map { |file| File.basename(file, '.rb') }.sort
    end

    def validate_generator
      generator = ARGV[0]
      return generator if valid_generators.include? generator

      puts 'Invalid generator passed as first argument!'
      print_usage
      print_generators
      exit 1
    end
  end
end
