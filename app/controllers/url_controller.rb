class UrlController < ApplicationController

	# fetch by alias and redirect to URL
	def show
		url = Url.where(alias: params[:alias])
		if url.length > 0
			# alias exists in db
			redirect_to url.first.url
		else
			render plain: 'Invalid redirect.'
		end
	end

	def new
	end

	# Takes a valid url and creates a shortened url from it.
	def create

		# ensure url is valid
		new = Url.new(params.require(:shortener).permit(:url, :alias))
		if (!new.valid?(:url))
			render plain: new.errors.messages and return
		end

		# ensure url does not already exist
		url = Url.where(url: params[:shortener][:url])
		if url.length > 0
			render plain: 'URL already shortened. See: ' + url_for(controller: 'url', action: 'create') + '/' + url.first.alias
			return
		end

		# check if user specified custom alias
		if params[:shortener][:alias] && params[:shortener][:alias].length > 0
			# check if alias has been used
			_alias = Url.where(alias: params[:shortener][:alias])
			if _alias.length == 0
				# alias has not been chosen
				new.save
				render plain: 'Success! See it here: ' + url_for(controller: 'url', action: 'create') + '/' +  params[:shortener][:alias]
			else
				render plain: 'Alias already exists :( Try again.'
			end
		else
			# generate random alias: id + 3 char random string
			new.save
			new.update(alias: new.id.to_s + (0...3).map { (65 + rand(26)).chr }.join)
			render plain: 'Here is your shortened URL: ' + url_for(controller: 'url', action: 'create') + '/' + new.alias
		end
	end
end
