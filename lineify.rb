#!/usr/bin/env ruby

parseExpressions = []
parser = File.new('parsers/mailq', 'r')
parser.each do |line|
	# If a line contains only whitespace and [...], it's a wildcard that matches
	# any number of lines.  Leave it as nil for now so we can deal with it
	# later.
	if line =~ /\s*\[\.\.\.\]\s*/
		parseExpressions << nil
	# Blank lines should match only blank lines.
	elsif line =~ /^\s*$/
		parseExpressions << /^\s*$/
	else
		parseExpressions << Regexp.new('^'+line.strip+'$')
	end
end

index = 0
ignore = false
ARGF.each do |line|
	line.strip!
	# TODO: This whole thing needs to be rewritten.  The logic is butt-ugly.
	#puts 'line: '+line
	#puts 'regex: '+parseExpressions[index].to_s
	if parseExpressions[index].nil?
		print line
		ignore = true
		index += 1
		if index == parseExpressions.size
			index = 0
			puts
		else
			print '|||'
		end
	elsif line =~ parseExpressions[index]
		print line
		ignore = false
	else
		$stderr.puts 'Skipping unmatching line' if !ignore
		print line if ignore
	end
	
	if !ignore
		index += 1
		if index == parseExpressions.size
			index = 0
			puts
		else
			print '|||'
		end
	end
	#puts '-'*80
end

