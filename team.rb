class Team
  attr_accessor :name, :pitcher, :team_odds, :final_score, :multiplier

  def inspect
    "team:#{name}\todds:#{team_odds}\t#{pitcher}"
  end
end