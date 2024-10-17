# frozen_string_literal: true

module PaymentProcess
  def self.process doc
    return false unless doc.pending?
    amount = self.verify_get_block doc
    return false if amount.blank? || amount <= 0
    return false unless self.perform_transfer doc, amount
    true
  end

  def self.process_presale doc
    return false unless doc.pending? && "PRESALE".eql?(doc.action)
    amount = self.verify_get_block doc
    return false if amount.blank? || amount <= 0
    perform_transfer_presale doc, amount
  end

  def self.perform_transfer_presale doc, amount
    main_curr = Config.get_config "MAIN_CURR", "USDT"
    main_currency = Currency.find_by_code main_curr
    origin_curr = doc.currency
    rate = main_currency.isCrypto ? self.get_convert_rate(origin_curr.code, main_curr) : 1
    ruby = Currency.find_by(code: "RUBY")
    ActiveRecord::Base.transaction do
      main_amount = amount * rate / ruby.local_rate
      account = Account.by_player_and_currency(doc.user, ruby).first
      if account.blank?
        account = Account.create(balance: 0, currency_id: ruby.id,
                                 user_id: doc.user.id, account_type: :casa)
      end
      before_balance = account.balance
      doc.update approved_at: DateTime.now, status: :success
      account.balance += main_amount
      return false unless account.save
      transaction = Transaction.new trans_type: :deposit,
                                    amount: main_amount,
                                    currency: ruby,
                                    original_amount: amount,
                                    original_currency_id: origin_curr.id,
                                    user: doc.user,
                                    account: account,
                                    comment: "Presale for doc " + doc.id.to_s,
                                    source: doc.id.to_s,
                                    status: :approved,
                                    before_balance: before_balance,
                                    after_balance: account.balance, doc_id: doc.id,
                                    custom_info_01: rate
      transaction.save
    rescue Exception
      raise ActiveRecord::Rollback
      false
    end
  end

  def self.verify_get_block doc
    currency = doc.currency.code
    curr = Currency.find_by code: currency, enable: true
    currency_chain = currency
    currency_chain = doc.chain unless curr.isCrypto
    api_key = Config.get_config "GET_#{currency_chain}_BLOCK_API_KEY", ""
    return 0 if api_key.blank?
    require "uri"
    require "json"
    require "net/http"
    url = URI("https://go.getblock.io/" + api_key)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "jsonrpc": "2.0",
      "method": "eth_getTransactionByHash",
      "params": [doc.ext_id],
      "id": "getblock.io"
    })
    response = https.request(request)
    res = JSON.parse response.read_body
    return 0 if res["result"].blank?
    result = res["result"]
    doc.source = result["from"]
    address = Config.get_config("#{currency_chain}_DEPOSIT_ADDRESS", "No Address Config")
    address = address.upcase
    if curr.isCrypto
      return 0 unless address.eql? result["to"].upcase
      result["value"].to_i(16)
    else
      get_value_from result["input"], address
    end
  end

  def self.get_value_from input, address
    method = "0xa9059cbb"
    return 0 unless input.start_with? method
    input = input.sub(method, "")
    param = input.each_char.each_slice(64).map(&:join)
    return 0 unless address.eql?(("0x" + param[0].gsub(/\A0+/, "")).upcase)
    param[1].to_i(16)
  end

  def self.perform_transfer doc, amount
    main_curr = Config.get_config "MAIN_CURR", "USDT"
    main_currency = Currency.find_by_code main_curr
    origin_curr = doc.currency
    rate = main_currency.isCrypto ? self.get_convert_rate(origin_curr.code, main_curr) : 1
    ActiveRecord::Base.transaction do
      main_amount = amount * rate / origin_curr.local_rate
      account = Account.by_player_and_currency(doc.user, main_curr).first
      if account.blank?
        account = Account.create(balance: 0, currency_id: main_currency.id,
                               user_id: doc.user.id, account_type: :casa)
      end
      before_balance = account.balance
      doc.update approved_at: DateTime.now, status: :success
      account.balance += main_amount
      return false unless account.save
      transaction = Transaction.new trans_type: :deposit,
                         amount: main_amount,
                         currency: main_currency,
                         original_amount: amount,
                         original_currency_id: origin_curr.id,
                         user: doc.user,
                         account: account,
                         comment: "Deposit for doc " + doc.id.to_s,
                         source: doc.id.to_s,
                         status: :approved,
                         before_balance: before_balance,
                         after_balance: account.balance, doc_id: doc.id,
                         custom_info_01: rate
      transaction.save
    rescue Exception
      raise ActiveRecord::Rollback
      false
    end
  end

  def self.get_convert_rate from, to
    return 1 if from.eql? to
    require "uri"
    require "net/http"
    url = URI("https://min-api.cryptocompare.com/data/price?fsym=#{from}&tsyms=#{to}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    convert_rate = JSON.parse response.read_body
    convert_rate[to]
  end
end
