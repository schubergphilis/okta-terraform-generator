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

require 'octokit'
require 'okta-terraform-generator/cli'

module OktaTerraformGenerator
  class CLI
    class GithubMembership < OktaTerraformGenerator::CLI
      include Mixlib::CLI

      banner "Usage: okta-terraform-generator github_membership (options)\n\nOptions:"

      option :github_token,
             short: '-h GITHUB_TOKEN',
             long: '--github-token GITHUB_TOKEN',
             default: ENV['GITHUB_TOKEN'],
             description: 'Specifies the GitHub API token',
             required: true

      option :okta_admin_group,
             short: '-a OKTA_GITHUB_ADMIN_GROUP',
             long: '--okta-github-admin-group OKTA_GITHUB_ADMIN_GROUP',
             default: ENV['OKTA_GITHUB_ADMIN_GROUP'],
             description: 'Specifies the Okta group containing GitHub admin users',
             required: true

      option :okta_endpoint,
             short: '-e OKTA_ENDPOINT',
             long: '--okta-endpoint OKTA_ENDPOINT',
             default: ENV['OKTA_ENDPOINT'],
             description: 'Specifies the Okta API endpoint (e.g. https://myorg.okta.com/api/v1)',
             required: true

      option :okta_group,
             short: '-g OKTA_GITHUB_USER_GROUP',
             long: '--okta-github-user-group OKTA_GITHUB_USER_GROUP',
             default: ENV['OKTA_GITHUB_USER_GROUP'],
             description: 'Specifies the Okta group containing GitHub users (can be a comma separated list)',
             proc: proc { |okta_group| okta_group.split('.').map(&:strip) },
             required: true

      option :okta_token,
             short: '-t OKTA_TOKEN',
             long: '--okta-token OKTA_TOKEN',
             default: ENV['OKTA_TOKEN'],
             description: 'Specifies the Okta API token',
             required: true

      option :treat_suspended_as_active,
             long: '--treat-suspended-as-active',
             boolean: true,
             description: 'Treat suspended users as active',
             proc: proc { |treat_suspended_as_active| $treat_suspended_as_active = true if treat_suspended_as_active }

      def run(argv = ARGV.dup)
        if argv.size == 1
          print_usage
          exit 1
        end

        setup(argv)
        generate
      end

      private

      def setup(argv)
        parse_options(argv)
      end

      def github_client
        @github_client ||= Octokit::Client.new(access_token: config[:github_token])
      end

      def okta_client
        @okta_client ||= Oktakit::Client.new(token: config[:okta_token], api_endpoint: config[:okta_endpoint])
      end

      def admins
        @admin_group_id ||= okta_client.group_id(config[:okta_admin_group])
        @admins ||= list_group_github_handles(@admin_group_id).map { |u| u.profile.login.downcase.split('@').shift }.sort
      end

      def github_handle(handle)
        github_client.user(handle).login
      rescue Octokit::NotFound
        false
      end

      def list_group_github_handles(group_id)
        okta_client.list_active_group_members(group_id).select { |user| user.profile.key?(:githubHandle) && !user.profile.githubHandle.empty? }
      end

      def user_or_admin(login)
        admins.include?(login) ? 'admin' : 'member'
      end

      def add_login_and_github_handle(login_and_github_handle)
        login, handle = login_and_github_handle(login_and_github_handle)

        return unless (github_handle = github_handle(handle))
        return if resource_name_exists? login

        add_to_resource_hash(login.to_s => {
                               'username' => github_handle,
                               'role'     => user_or_admin(login)
                             })
      end

      def login_and_github_handle(login_and_github_handle)
        # login  = Okta login
        # handle = GitHub handle
        login, handle = login_and_github_handle
        login = login.split('@').shift
        [login, handle]
      end

      def logins_and_github_handles(okta_group, group_id)
        puts "Looking for active users in Okta group \"#{okta_group}\" (with group id: #{group_id}) and the \"githubHandle\" profile attribute set ... "
        list_group_github_handles(group_id).map { |u| [u.profile.login.downcase, u.profile.githubHandle.downcase] }
      end

      def generate
        config[:okta_group].each do |okta_group|
          group_id = okta_client.group_id(okta_group)
          logins_and_github_handles(okta_group, group_id).sort_by { |x, _y| x }.each do |login_and_github_handle|
            add_login_and_github_handle(login_and_github_handle)
          end
        end

        write_tf_file('github_membership.tf', resources)
      end
    end
  end
end
