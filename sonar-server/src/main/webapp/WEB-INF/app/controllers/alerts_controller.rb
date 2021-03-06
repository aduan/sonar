#
# Sonar, open source software quality management tool.
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
class AlertsController < ApplicationController

  verify :method => :post, :only => ['create', 'update', 'delete'], :redirect_to => { :action => 'index' }
  before_filter :admin_required, :except => [ 'index' ]

  SECTION=Navigation::SECTION_CONFIGURATION

  #
  #
  # GET /alerts/index/<profile_id>
  #
  #
  def index
    require_parameters :id
    @profile = Profile.find(params[:id])
    @alerts = @profile.valid_alerts.sort
    @alert=Alert.new
    add_breadcrumbs ProfilesController::ROOT_BREADCRUMB, Api::Utils.language_name(@profile.language), {:name => @profile.name, :url => {:controller => 'rules_configuration', :action => 'index', :id => @profile.id}}
  end

  #
  #
  # GET /alerts/show/<alert id>
  #
  #
  def show
    @alert = @profile.alerts.find(params[:id])
  end

  #
  #
  # GET /alerts/new?profile_id=<profile id>
  #
  #
  def new
    @profile = Profile.find(params[:profile_id])
    @alert = @profile.alerts.build(params[:alert])
    render :partial => 'new', :status => 200
  end


  #
  #
  # GET /alerts/edit/<alert id>
  #
  #
  def edit
    @alert = @profile.alerts.find(params[:id])
  end


  #
  #
  # POST /alerts/create?profile_id=<profile id>&...
  #
  #
  def create
    @profile = Profile.find(params[:profile_id])
    params[:alert][:period] = nil if params[:alert][:period] == '0'
    @alert = @profile.alerts.build(params[:alert])

    if @alert.save
      flash[:notice] = message('alerts.alert_created')
      render :text => 'ok', :status => 200
    else
      @alerts = @profile.alerts.reload
      errors = []
      @alert.errors.full_messages.each{|msg| errors<<msg + '<br/>'}
      render :text => errors, :status => 404
    end
  end

  #
  #
  # POST /alerts/update/<alert id>?profile_id=<profile id>
  #
  #
  def update
    @profile = Profile.find(params[:profile_id])
    params[:alert][:period] = nil if params[:alert][:period] == '0'
    @alerts=@profile.alerts
    alert = @alerts.find(params[:id])

    if alert.update_attributes(params[:alert])
      flash[:notice] = message('alerts.alert_updated')
      render :text => 'ok', :status => 200
    else
      errors = []
      alert.errors.full_messages.each{|msg| errors<<msg + '<br/>'}
      render :text => errors, :status => 404
    end
  end

  #
  #
  # POST /alerts/delete/<alert id>?profile_id=<profile id>
  #
  #
  def delete
    @profile = Profile.find(params[:profile_id])
    @alert = @profile.alerts.find(params[:id])
    @alert.destroy
    flash[:notice] = message('alerts.alert_deleted')
    redirect_to(:action => 'index', :id=>@profile.id)
  end

end
