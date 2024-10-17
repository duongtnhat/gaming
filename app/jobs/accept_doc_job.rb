# frozen_string_literal: true

module AcceptDocJob
  def self.perform
    docs = Doc.where(action: "DEPOSIT", status: :pending).where("created_at > ?", 1.hour.ago)
    docs.each do |doc|
      PaymentProcess.process(doc)
      sleep(0.5)
    end
  end

  def self.preform_presale
    docs = Doc.where(action: "PRESALE", status: :pending).where("created_at > ?", 1.hour.ago)
    docs.each do |doc|
      PaymentProcess.process_presale(doc)
      sleep(0.5)
    end
  end
end

