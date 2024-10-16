# frozen_string_literal: true

module AcceptDocJob
  def self.perform
    docs = Doc.where(action: "DEPOSIT", status: :pending).where("created_at > ?", 1.hour.ago)
    docs.each do |doc|
      PaymentProcess.process(doc)
      sleep(0.5)
    end
  end
end

