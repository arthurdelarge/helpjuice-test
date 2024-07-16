class SearchesController < ApplicationController
  def index
    @recent_global = Search.recent_global
    @recent_local  = Search.recent_local(ip_address)
    @trending      = Search.trending
  end

  private

  def ip_address
    @ip_address ||= request.remote_ip
  end
end
