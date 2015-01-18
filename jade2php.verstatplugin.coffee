module.exports = (next) ->
	jade2php = require 'jade2php'
	fs = require 'fs'
	rimraf = require 'rimraf'
	mkdirp = require 'mkdirp'
	path = require 'path'

	out = @config.jade2php

	if out
		rimraf out, =>
			@on 'readFile', (file) =>
				if file.srcExtname is '.jade'
					try
						phpCode = jade2php file.source,
							omitPhpRuntime: yes
						outFilePath = "#{out}/#{file.fullname}.php"
						mkdirp path.dirname(outFilePath), (err) =>
							throw err if err
							fs.writeFile outFilePath, phpCode, (err) =>
								throw err if err
					catch e
						@log "ERROR", "jade2php failed"
						console.log e.message
			next()
	else
		@log "ERROR", "jade2php plugin is not configured properly!"
		next()
