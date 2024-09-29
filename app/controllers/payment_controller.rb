class PaymentController < ApplicationController
  before_action :authenticate_devise_api_token!

  def index
    limit = params[:limit] || DEFAULT_PAGE_LIMIT
    page = params[:page] || 1
    @doc = Doc.list_payment current_user, page, limit
    success(@doc, DocSerializer)
  end

  def create
    @doc = Doc.create_deposit(current_user, params[:amount], params[:currency], params[:ext_id])
    if @doc.save
      success(@doc, DocSerializer)
    else
      error({ error: @doc.errors.details }, 400, "Cannot create payment")
    end
  end

  def refresh
    @doc = Doc.find params[:id]
    return not_found if @doc.blank?
    response_success({result: PaymentProcess.process(@doc)})
  end

  def payout
  end
end
