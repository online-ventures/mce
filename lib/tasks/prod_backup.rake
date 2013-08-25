task :prod_backup do
	if RUBY_VERSION.in? `heroku version`
		puts 'Capture a backup now?'
		response = gets.chomp
		if response.include? 'y'
			`heroku pgbackups:capture --expire`
		end
		`curl -o latest.dump \`heroku pgbackups:url\``
	else
		puts 'Sorry, heroku toolbelt isn\'t compatible with your `ruby -v`'
	end
end