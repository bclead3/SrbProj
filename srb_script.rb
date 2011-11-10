require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'yaml'
require 'game'
require 'team'
require 'srb_spread_sheet'
require 'bet_unit'

class SrbScript
  def self.strip_or_self!(str)
    str.strip! || str
  end
  time = Time.now
  date_string = time.strftime("%Y-%m-%d")
  date_string2 = (time - 8*86400).strftime("%Y%m%d")
  refs = open('reference.yml') {|f| YAML.load(f) }

  sport = refs['reference']['sport']
  spread_url_base = refs['reference']['spread_url']
  agent = Mechanize.new{ |a|
    a.user_agent_alias = 'Mac Safari'
  }
  cookie = Mechanize::Cookie.new('odds_option_ODDS_FORMAT', '2')
  cookie.domain = ".sbrforum.com"
  cookie.path = "/"
  uri = URI.parse("http://www.sbrforum.com")

  agent.cookie_jar.add(uri,cookie)
  zero_array = []
  one_array = []
  two_array = []
  three_array = []
  four_array = []
  five_array = []
  bet_unit_array = []
  sd = Date.parse('2011-04-01')
  #sd = Date.parse('2011-09-09')
  ed = Date.parse('2011-09-28')
  #sd = Date.parse('2011-07-10')
  #ed = Date.parse('2011-07-16')
  sd.upto(ed) do |date|
    spread_url = spread_url_base + date.strftime("%Y%m%d")
    request = agent.get(spread_url)

    doc = Nokogiri::HTML(request.body)

    long_date = doc.xpath("//div[@class='eventGroup class-mlb-baseball show-rotation']/div[@id='byDateleagueData-#{date.strftime("%Y-%m-%d")}']/div/div[@class='groupNameText no-left-border']/div[@class='date']").text

    g_a = []
    g_a_5 = []
    t_a = []
    if( long_date != "" && long_date != "Tuesday, July 12, 2011" &&long_date != "Friday, September 9, 2011")
      puts "The url for #{sport} is #{spread_url} called on #{long_date}"
      doc.xpath("//div[@class='eventLines']/div/div[@class='eventLine  status-complete ' or @class='eventLine odd status-complete ']").each do |element|
        element_id = element.xpath("@id").text
        team1_score = element.xpath("./div[@class='score-content']/div/div[@id='score-#{element_id}']/span[@id='score-#{element_id}-o']").text
        team2_score = element.xpath("./div[@class='score-content']/div/div[@id='score-#{element_id}']/span[@id='score-#{element_id}-u']").text
        team1 = element.xpath("./div[@class='el-div eventLine-team']/div[1]/div")
        team2 = element.xpath("./div[@class='el-div eventLine-team']/div[2]/div")
        pitcher1 = team1.xpath("./span").text
        pitcher2 = team2.xpath("./span").text
        teamA = Team.new
        teamB = Team.new
        teamA.name = /[A-Z]{2,}/.match(team1.text)
        teamB.name = /[A-Z]{2,}/.match(team2.text)
        teamA.pitcher = pitcher1
        teamB.pitcher = pitcher2
        t1_odds = element.xpath("./div[@rel='1096']/div[@class='eventLine-book-value ' or @class='eventLine-book-value'][1]/b")
        t2_odds = element.xpath("./div[@rel='1096']/div[@class='eventLine-book-value ' or @class='eventLine-book-value'][2]/b")
        t1_s = /-*\d.\d+/.match(t1_odds.text)
        t2_s = /-*\d.\d+/.match(t2_odds.text)
        teamA.team_odds = t1_s.to_s.to_f
        teamB.team_odds = t2_s.to_s.to_f
        teamA.final_score = team1_score.to_i
        teamB.final_score = team2_score.to_i
        t_a << teamA
        t_a << teamB
        game = Game.new
        game.team1 = teamA
        game.team2 = teamB
        g_a << game
      end
      t_a.sort!{|x,y| x.team_odds <=> y.team_odds}
      t_a.each do |team|
        puts team.inspect
      end

      g_a.sort!{|x,y| y.get_game_spread <=> x.get_game_spread}
      count = 0
      win_count = 0
      (0..4).each do |game_index|
        count += 1
        game = g_a[game_index]
        g_a_5 << game
        puts "#{count}:#{game.inspect}\t\t#{game.lowest_odds}\t#{game.did_lower_odds_team_win?}:#{Game.true_false_to_integer(game.did_lower_odds_team_win?)}\t\tHas top 5 odds?#{game.has_top_five_odds?(t_a)}"
        if(game.did_lower_odds_team_win?)
          win_count+=1
        end
      end
      puts "The number of winners was #{win_count} out of 5 on #{date.strftime("%Y-%m-%d")}"
      bu = BetUnit.new
      bu.set_game_array=g_a_5
      if(bet_unit_array.size===0)
        bu.unit_start_amount
        bu.previous_unit_absolute_net_loss = 0
      else
        bu.unit_start_amount = bet_unit_array[-1].unit_start_amount + bet_unit_array[-1].unit_net_amount
        bu.previous_unit_absolute_net_loss = bet_unit_array[-1].absolute_net_loss
      end
      bu.unit_date=date

      puts "The starting amount at #{date} is #{bu.unit_start_amount}."
      puts "The bet amount per game is #{bu.unit_bet_amount_per_game}   net:#{bu.unit_bet_amount_net}"
      puts "The absolute net loss was #{bu.absolute_net_loss}"
      puts "Net amount:#{bu.unit_net_amount}"
      bet_unit_array << bu
      case win_count
        when 0
          zero_array << date
        when 1
          one_array << date
        when 2
          two_array << date
        when 3
          three_array << date
        when 4
          four_array << date
        else
          five_array << date
      end
    end
  end
  puts "The number of zero wins #{zero_array.count}:#{zero_array.inspect}\n\n"
  puts "The number of one wins #{one_array.count}:#{one_array.inspect}\n\n"
  puts "The number of two wins #{two_array.count}:#{two_array.inspect}\n\n"
  puts "The number of three wins #{three_array.count}:#{three_array.inspect}\n\n"
  puts "The number of four wins #{four_array.count}:#{four_array.inspect}\n\n"
  puts "The number of five wins #{five_array.count}:#{five_array.inspect}\n\n"
end

