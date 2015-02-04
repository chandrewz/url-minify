class Url < ActiveRecord::Base

	validates :url, :presence => true
	validates_format_of :url, :with => URI::regexp(%w(http https)), :message => 'Invalid URL format. Please use ex. "http://www.google.com"'

end
