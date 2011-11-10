require "test/unit"
require 'bet_unit'
require 'team'
require 'game'

class BetUnitTest < Test::Unit::TestCase
  @bu
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @bu = BetUnit.new
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    @bu = nil
  end

  def test_unit_start_amount
    assert_equal(1000.0, @bu.unit_start_amount)

    @bu.unit_start_amount=12345
    assert_equal(12345.0, @bu.unit_start_amount)
  end

  def test_unit_date
    date_string = Time.now.strftime("%Y-%m-%d")
    assert_equal(date_string,@bu.unit_date)

    @bu.unit_date = "2011-08-12"
    assert_equal("2011-08-12",@bu.unit_date)
  end

  def test_unit_number
    @bu.unit_number = 0
    assert_equal(0,@bu.unit_number)

    @bu.unit_number = 12
    assert_equal(12,@bu.unit_number)
  end

  def test_previous_unit_absolute_net_loss
    assert_equal(0.0,@bu.previous_unit_absolute_net_loss)

    @bu.previous_unit_absolute_net_loss=44
    assert_equal(44.0,@bu.previous_unit_absolute_net_loss)
  end

  def test_unit_bet_amount_per_game
    assert_equal(33.33,@bu.unit_bet_amount_per_game)

    @bu.unit_start_amount = 1071
    @bu.previous_unit_absolute_net_loss=61.67
    assert_equal(48.03,@bu.unit_bet_amount_per_game)

    @bu.unit_start_amount = 1111.83
    @bu.previous_unit_absolute_net_loss = 165.72
    assert_equal(70.20,@bu.unit_bet_amount_per_game)
  end

  def test_unit_bet_amount_net
    assert_equal(166.65,@bu.unit_bet_amount_net)
  end

  def test_absolute_net_loss
    assert_equal(0.00,@bu.absolute_net_loss)
    g_a = []
    team1 = Team.new
    team1.name = "SF"
    team1.team_odds = 1.22
    team1.final_score = 6
    team2 = Team.new
    team2.name = "LAD"
    team2.team_odds = 2.33
    team2.final_score = 3
    game1 = Game.new
    game1.team1=team1
    game1.team2=team2
    assert(game1.did_lower_odds_team_win?)
    assert_equal(1.11,game1.get_game_spread)
    g_a << game1

    team3 = Team.new
    team3.name = "MIN"
    team3.team_odds = 1.33
    team3.final_score = 6
    team4 = Team.new
    team4.name = "CWS"
    team4.team_odds = 2.44
    team4.final_score = 3
    game2 = Game.new
    game2.team1=team3
    game2.team2=team4
    assert(game2.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game2.get_game_spread.to_s)
    g_a << game2

    team5 = Team.new
    team5.name = "KC"
    team5.team_odds = 1.44
    team5.final_score = 3
    team6 = Team.new
    team6.name = "DET"
    team6.team_odds = 2.55
    team6.final_score = 6
    game3 = Game.new
    game3.team1=team5
    game3.team2=team6
    assert_equal(false,game3.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game3.get_game_spread.to_s)
    g_a << game3

    team7 = Team.new
    team7.name = "TAM"
    team7.team_odds = 1.55
    team7.final_score = 0
    team8 = Team.new
    team8.name = "OAK"
    team8.team_odds = 2.66
    team8.final_score = 6
    game4 = Game.new
    game4.team1=team7
    game4.team2=team8
    assert_equal(false,game4.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game4.get_game_spread.to_s)
    g_a << game4

    team9 = Team.new
    team9.name = "BOS"
    team9.team_odds = 1.66
    team9.final_score = 0
    team10 = Team.new
    team10.name = "NYY"
    team10.team_odds = 2.77
    team10.final_score = 1
    game5 = Game.new
    game5.team1=team9
    game5.team2=team10
    assert_equal(false,game5.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game5.get_game_spread.to_s)
    g_a << game5
    assert_equal(5,g_a.size)
    @bu.set_game_array=g_a
    net_loss = @bu.absolute_net_loss
    assert_equal(154.98,net_loss)
  end

  def test_unit_net_amount
    assert_equal(0.00,@bu.unit_net_amount)
    g_a = []
    team1 = Team.new
    team1.name = "SF"
    team1.team_odds = 1.22
    team1.final_score = 6
    team2 = Team.new
    team2.name = "LAD"
    team2.team_odds = 2.33
    team2.final_score = 3
    game1 = Game.new
    game1.team1=team1
    game1.team2=team2
    assert(game1.did_lower_odds_team_win?)
    assert_equal(1.11,game1.get_game_spread)
    g_a << game1

    team3 = Team.new
    team3.name = "MIN"
    team3.team_odds = 1.33
    team3.final_score = 6
    team4 = Team.new
    team4.name = "CWS"
    team4.team_odds = 2.44
    team4.final_score = 3
    game2 = Game.new
    game2.team1=team3
    game2.team2=team4
    assert(game2.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game2.get_game_spread.to_s)
    g_a << game2

    team5 = Team.new
    team5.name = "KC"
    team5.team_odds = 1.44
    team5.final_score = 3
    team6 = Team.new
    team6.name = "DET"
    team6.team_odds = 2.55
    team6.final_score = 6
    game3 = Game.new
    game3.team1=team5
    game3.team2=team6
    assert_equal(false,game3.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game3.get_game_spread.to_s)
    g_a << game3

    team7 = Team.new
    team7.name = "TAM"
    team7.team_odds = 1.55
    team7.final_score = 0
    team8 = Team.new
    team8.name = "OAK"
    team8.team_odds = 2.66
    team8.final_score = 6
    game4 = Game.new
    game4.team1=team7
    game4.team2=team8
    assert_equal(false,game4.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game4.get_game_spread.to_s)
    g_a << game4

    team9 = Team.new
    team9.name = "BOS"
    team9.team_odds = 1.66
    team9.final_score = 0
    team10 = Team.new
    team10.name = "NYY"
    team10.team_odds = 2.77
    team10.final_score = 1
    game5 = Game.new
    game5.team1=team9
    game5.team2=team10
    assert_equal(false,game5.did_lower_odds_team_win?)
    assert_equal(1.11.to_s,game5.get_game_spread.to_s)
    g_a << game5
    assert_equal(5,g_a.size)
    @bu.set_game_array=g_a
    net_amount = @bu.unit_net_amount
    assert_equal(-69.99,net_amount)
  end

  def test_amount_to_bet
    assert_equal(0.0,BetUnit.amount_to_bet)
    assert_equal(1.0,BetUnit.amount_to_bet(1.0,1.0))
    assert_equal(3.0,BetUnit.amount_to_bet(3.0,1.0))
  end
end