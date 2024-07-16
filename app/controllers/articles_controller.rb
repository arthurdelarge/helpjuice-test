class ArticlesController < ApplicationController
  def index
    @articles = Article.by_text(params[:query])
  end

  def create
    Article.create(text: params[:text])
    redirect_to articles_path
  end

  def search
    SearchService.set_query(ip_address, params[:query])
    redirect_to articles_path(query: params[:query])
  end

  private

  def ip_address
    @ip_address ||= request.remote_ip
  end
end
