# Description:
#   Invite people into the community!
# Commands:
#   hubot invite <email_address> - Sends an invite to the provided email address
# Author:
#   colmdoyle

slackKey = process.env.HUBOT_SLACK_ADMIN_TOKEN
unless slackKey?
  console.log "Missing Hubot Slack Token for admin script"

module.exports = (robot) ->
  robot.respond /invite (.*)/i, (msg) ->
    sender = msg.message.user.name.toLowerCase()
    email_address = encodeURIComponent(msg.match[1])
    data = "email=#{email_address}&channels=C035FCDDD&set_active=true&_attempts=1&token=#{slackKey}"
    console.log(data)
    robot.http("https://irishtechcommunity.slack.com/api/users.admin.invite?t=#{Date.now()}")
      .header('Accept', 'application/json')
      .header("Content-Type","application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        console.log(body)
        data = JSON.parse(body)
        msg.send "#{data.ok}"
        if (data.ok)
          console.log("#{sender} sent an invite to #{email_address}")
          msg.reply "Ok, I've sent an invite to #{email_address}"
        else
          console.log("#{sender} sent an invite to #{email_address}, but it failed")
          console.log(body)
          console.log(data)
          msg.reply "Herp, something went wrong"