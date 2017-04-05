require "mechanize"

most_recent_review = "Some Business"
slack_channel      = "Define the Slack channel to post to here. Format is #channel"
slack_user         = "Define the Slack user to use."
slack_emoji        = "Define the Slack emoji for the user's avatar."
slack_url          = "Define the Slack hook URL to POST the request to."

#Get name of most recent review.
agent = Mechanize.new
page  = agent.get("Yelp URL goes here.")
search = page.search('//div[@class="media-story"]').first
string = search.elements.first.text
string.gsub!("\n", "")
string.rstrip!
string.lstrip!
if string != most_recent_review
	#Get rating of new review
	stars = page.search('//div[@class="biz-rating biz-rating-large clearfix"]').first.to_html
	b = stars.match /(?<number>\d\.\d)\sstar\srating/
	rating = b[:number].to_i
	emoji  = ":star:"
	post_string = "Here's my #{emoji * rating} review for #{string}!"
	#post to slack
	`curl -X POST --data-urlencode 'payload={"channel": "#{slack_channel}", "username": "#{slack_user}", "text": "#{post_string}", "icon_emoji": "#{slack_emoji}"}' #{slack_url}`
	#change most recent review in this file
	file_name = "/path/to/this/file"
	text = File.read(file_name)
	a = text.match /most_recent_review\s=\s(?<review>[^\n]+)/
	old_string = a[:review]
	old_string.gsub! /"/, ""
	new_contents = text.gsub(old_string, string)
	File.open(file_name, "w") {|file| file.puts new_contents }
end
