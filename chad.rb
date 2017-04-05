require "mechanize"

most_recent_review = "Shawarma Express"

#Get name of most recent review.
agent = Mechanize.new
page  = agent.get("https://www.yelp.com/user_details_reviews_self?userid=0_3KQG5DnBAxG6O8CC1t3A")
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
	`curl -X POST --data-urlencode 'payload={"channel": "#ji-chi", "username": "chadbot", "text": "#{post_array.sample}", "icon_emoji": ":chad:"}' https://hooks.slack.com/services/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`
	#change most recent review in this file
	file_name = "/Users/luke/Code_Personal/chad.rb"
	text = File.read(file_name)
	a = text.match /most_recent_review\s=\s(?<review>[^\n]+)/
	old_string = a[:review]
	old_string.gsub! /"/, ""
	new_contents = text.gsub(old_string, string)
	File.open(file_name, "w") {|file| file.puts new_contents }
end
