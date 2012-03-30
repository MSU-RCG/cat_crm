# Cat CRM
# Copyright (C) 2012 by Sean Cleveland
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

class StudentReportsController < EntitiesController
  before_filter :get_data_for_sidebar, :only => :index

  # GET /student_reports
  #----------------------------------------------------------------------------
  def index
    @fields = Field.where(:disabled=>false)
  end

  


  # PUT /accounts/1/attach
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :attach

  # PUT /accounts/1/discard
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :discard

  # POST /accounts/auto_complete/query                                     AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /accounts/options                                                  AJAX
  #----------------------------------------------------------------------------
  def options
    unless params[:cancel].true?
      @per_page = @current_user.pref[:accounts_per_page] || Account.per_page
      @outline  = @current_user.pref[:accounts_outline]  || Account.outline
      @sort_by  = @current_user.pref[:accounts_sort_by]  || Account.sort_by
    end
  end

  # POST /accounts/redraw                                                  AJAX
  #----------------------------------------------------------------------------
  def redraw
    @current_user.pref[:accounts_per_page] = params[:per_page] if params[:per_page]
    @current_user.pref[:accounts_outline]  = params[:outline]  if params[:outline]
    @current_user.pref[:accounts_sort_by]  = Account::sort_by_map[params[:sort_by]] if params[:sort_by]
    @accounts = get_accounts(:page => 1)
    render :index
  end

  # POST /accounts/filter                                                  AJAX
  #----------------------------------------------------------------------------
  def filter
    session[:filter_by_account_category] = params[:category]
    @accounts = get_accounts(:page => 1)
    render :index
  end

  private
  #----------------------------------------------------------------------------
  def get_accounts(options = {})
    get_list_of_records(Account, options.merge!(:filter => :filter_by_account_category))
  end

  #----------------------------------------------------------------------------
  def get_data_for_sidebar

  end
end
