# Description:
#   reputation dice
#
# Commands:
#   dice <bet> <amount> - bet to roll lower than any number between 100 and 64000, with amount

float = 1000000
max = 65536

save = (robot) ->
    robot.brain.data.float = float

module.exports = (robot) ->
    robot.brain.on 'loaded', ->
        float = robot.brain.data.float or float

    robot.hear /^dice ([\d]+)([\d.]+)$/i, (msg) ->
        bet = parseInt(msg.match[1])
        if bet >= 64000
          msg.send "dice must be less than 64000"
          return
        if bet < 100
          msg.send "dice must be higher than 100"
          return
        amount = parseFloat(msg.match[2])
        if amount < 1
          msg.send "bet must be higher than 1₥"
          return
        if amount > 500
          msg.send "bet must be lower than 500₥"
          return
        dice = Math.floor(Math.random() * max) + 1
        if bet > dice
          msg.send "Sorry, dice was #{dice} and you bet lower than #{bet}"
          return
        odds = (bet/max).toFixed(4)
        mul = ((max/bet)*0.981).toFixed(4)
        win = bet*mul
        msg.send "Congratulations! dice: #{dice}, bet: #{bet}, odds: #{odds}, multiplier: #{mul}, *win*: #{win}₥"
        save(robot)