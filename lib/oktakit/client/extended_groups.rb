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

require 'oktakit/client/groups'

module Oktakit
  class Client
    module ExtendedGroups
      include Oktakit::Client::Groups

      ACTIVE_STATUSES = %w[ACTIVE LOCKED_OUT PASSWORD_EXPIRED RECOVERY].freeze

      def list_active_group_members(group_id)
        list_group_members(group_id).shift.select do |user|
          active_statuses = ACTIVE_STATUSES.dup
          active_statuses.push('SUSPENDED') if $treat_suspended_as_active
          active_statuses.include?(user.status)
        end
      end

      def groups
        @groups ||= list_groups.first
      end

      def group_id(group_name)
        groups.select { |group| group[:type] == 'OKTA_GROUP' && group[:profile][:name] =~ /^#{group_name}$/i }.shift.id
      end
    end
  end
end

module Oktakit
  class Client
    include ExtendedGroups
  end
end
