class PaymentController < ApplicationController
  before_action :authenticate_devise_api_token!

  def index
    limit = params[:limit] || DEFAULT_PAGE_LIMIT
    page = params[:page] || 1
    @doc = Doc.list_payment current_user, page, limit
    success(@doc, DocSerializer)
  end

  def create

  end

  def refresh
  end

  def payout
  end
end
