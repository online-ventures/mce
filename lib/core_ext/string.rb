class String
	def to_url
		/^http/.match(self) ? self : "http://#{self}"
	end
end