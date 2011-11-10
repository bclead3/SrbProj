class BetUnit
  attr_accessor :unit_date, :unit_number, :unit_bet_amount_per_game ,:unit_bet_amount_net, :unit_start_amount, :absolute_net_loss, :unit_net

  def self.refs
    @refs ||= open('reference.yml') {|f| YAML.load(f) }
    @refs
  end

  def unit_bet_amount_per_game
    @unit_bet_amount_per_game = @unit_start_amount.to_f/30.0 + (@previous_unit_absolute_net_loss.to_f/5)
    if(@unit_start_amount - @unit_bet_amount_per_game < 0 || @unit_bet_amount_per_game * 30 > @unit_start_amount.to_f)
      @unit_bet_amount_per_game = @unit_start_amount.to_f/30.0
    end
    sprintf("%.2f",@unit_bet_amount_per_game).to_f
  end

  def unit_bet_amount_net
    amount = @unit_bet_amount_per_game.to_f * 5
    sprintf("%.2f",amount).to_f
  end

  def set_game_array=(array)
    @game_array = array
  end

  def absolute_net_loss
    ab_net_loss = 0.0
    if(!@game_array.nil?)
      (0..4).each do |game_index|
        game = @game_array[game_index]
        if( ! game.did_lower_odds_team_win?)
          odds = game.lowest_odds
          ab_net_loss += @unit_bet_amount_per_game * odds
        end
      end
    else
      print "there was no game array passed in"
    end
    sprintf("%.2f",ab_net_loss).to_f
  end

  def unit_net_amount
    net_amount = unit_bet_amount_net * -1
    if(!@game_array.nil? && @game_array.size==5)
      (0..4).each do |game_index|
        game = @game_array[game_index]
        odds = game.lowest_odds
        if( game.did_lower_odds_team_win?)
          net_amount += unit_bet_amount_per_game * odds
        end
      end
    end
    sprintf("%.2f",net_amount).to_f
  end

  def self.amount_to_bet(bet_amount=0.0,odds=1.0)
    value = bet_amount * odds
    sprintf("%.2f",value).to_f
  end

  def previous_unit_absolute_net_loss
    @previous_unit_absolute_net_loss ||= 0
    sprintf("%.2f",@previous_unit_absolute_net_loss).to_f
  end
  def previous_unit_absolute_net_loss=(value=0)
    @previous_unit_absolute_net_loss = value.to_f
  end

  def unit_date
    @unit_date ||= Time.now.strftime("%Y-%m-%d")
  end
  def unit_date=(date=Time.now.strftime("%Y-%m-%d"))
    @unit_date= date
  end

  def unit_start_amount
    @unit_start_amount ||= BetUnit.refs['reference']['start_amount'].to_f
    sprintf("%.2f",@unit_start_amount).to_f
  end
  def unit_start_amount=(amt=BetUnit.refs['reference']['start_amount'].to_f)
    @unit_start_amount = amt
  end
end