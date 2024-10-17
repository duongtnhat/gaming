class PaymentController < ApplicationController
  before_action :authenticate_devise_api_token!, except: [:create_presale, :presale]

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

  def presale
    @doc = Doc.where(action: "PRESALE", source: params[:address]).order(created_at: :desc)
    success(@doc, DocSerializer)
  end

  def create_presale
    @doc = Doc.create_presale(params[:address], params[:amount], params[:currency], params[:ext_id])
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
    @doc = Doc.create_withdraw(current_user, params[:amount], params[:address])
    if @doc.id.blank?
      return error({ error: "Unknown error" }, 400, "Cannot create payout")
    elsif @doc.errors.present?
      return error({ error: @doc.errors.details }, 400, "Cannot create payout")
    end
    success(@doc, DocSerializer)
  end
end
