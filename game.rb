class Game
  attr_accessor :team1, :team2

  def get_game_spread
    val = 0
    if(!team1.team_odds.nil? && !team2.team_odds.nil?)
      t1_s = team1.team_odds
      t2_s = team2.team_odds
      val = t1_s.to_s.to_f - t2_s.to_s.to_f
    end
    val.abs
  end

  def team1_WL
    if team1.final_score > team2.final_score
      team1.multiplier = 1
      team2.multiplier = -1
      "W"
    elsif team1.final_score < team2.final_score
      team1.multiplier = -1
      team2.multiplier = 1
      "L"
    else
      team1.multiplier = 0
      team2.multiplier = 0
      "Tie"
    end
  end

  def team2_WL
    if team1.final_score > team2.final_score
      team1.multiplier = 1 if team1.multiplier.nil?
      team2.multiplier = -1 if team2.multiplier.nil?
      "L"
    elsif team1.final_score < team2.final_score
      team1.multiplier = -1 if team1.multiplier.nil?
      team2.multiplier = 1 if team2.multiplier.nil?
      "W"
    else
      team1.multiplier = 0 if team1.multiplier.nil?
      team2.multiplier = 0 if team2.multiplier.nil?
      "Tie"
    end
  end

  def has_top_five_odds?(team_array_sorted)
    return_value = false
    match_one = false
    (0..4).each do |x|
      team = team_array_sorted[x]
      if((team1.team_odds == team.team_odds || team2.team_odds == team.team_odds) && match_one == false)
        match_one = true
        return_value = true
      end
    end
    return_value
  end

  def has_two_top_five_odds?(team_array_sorted)
    return_value = false
    match_one = false
    match_two = false
    (0..4).each do |x|
      team = team_array_sorted[x]
      if((team1.team_odds == team.team_odds || team2.team_odds == team.team_odds) && match_one == true && match_two == false)
        match_two = true
        return_value = true
      end
      if((team1.team_odds == team.team_odds || team2.team_odds == team.team_odds) && match_one == false)
        match_one = true
      end
    end
    return_value
  end

  def did_lower_odds_team_win?
    return_value = false
    if(team1.team_odds < team2.team_odds)
      if(team1.final_score > team2.final_score)
        return_value = true
      end
    elsif(team1.team_odds > team2.team_odds)
      if(team1.final_score < team2.final_score)
        return_value = true
      end
    end
    return_value
  end

  def lowest_odds
    return_odds = 1.0
    if(team1.team_odds < team2.team_odds)
      return_odds = team1.team_odds
    else
      return_odds = team2.team_odds
    end
  end

  def self.true_false_to_integer(value)
    return_value = -1
    if(value == true)
      return_value = 1
    end
    return_value
  end

  def inspect
    "\t#{team1.name}\tt1_odds:#{team1.team_odds}\t#{team1.final_score}:#{team1_WL}:#{team1.multiplier}\t\t#{team2.name}\tt2_odds:#{team2.team_odds}\t#{team2.final_score}:#{team2_WL}:#{team2.multiplier}\t\tspread:#{sprintf("%.2f", get_game_spread)}"
  end
end