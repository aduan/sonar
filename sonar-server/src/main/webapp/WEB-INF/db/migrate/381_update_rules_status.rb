#
# Sonar, entreprise quality control tool.
# Copyright (C) 2008-2012 SonarSource
# mailto:contact AT sonarsource DOT com
#
# Sonar is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Sonar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with Sonar; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
#

#
# Sonar 3.6
#
class UpdateRulesStatus < ActiveRecord::Migration

  class Rule < ActiveRecord::Base
  end

  def self.up
    set_rule_status
  end

  private

  def self.set_rule_status
    Rule.reset_column_information
    Rule.update_all({:status => 'READY', :created_at => Time.now}, ['enabled=?', true])
    Rule.update_all({:status => 'REMOVED', :updated_at => Time.now}, ['enabled=?', false])
  end

end

