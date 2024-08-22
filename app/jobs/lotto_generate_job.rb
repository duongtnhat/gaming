# frozen_string_literal: true

module LottoGenerateJob
  def self.perform
    self.perform_end_game
    self.perform_new_game
  end

  def self.perform_end_game
    active_game = LottoInst.where(status: :active)
    active_game.each do |game|
      if (game.end_at - DateTime.current) / 1.minutes <= 1
        game.process_end_game
      end
    end
  end

  def self.perform_new_game
    list_schema = LottoSchema.where(enable: true)
    current = DateTime.current
    list_schema.each do |schema|
      cron = Fugit::Cron.new schema.new_round_at
      next unless cron.match? DateTime.current
      Rails.logger.info "Generate match schema %s at %s" % [schema.id, current]
      schema.new_instance
    end
  end
end

