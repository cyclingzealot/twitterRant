#!/bin/ruby

require 'set'
require 'pathname'
require 'byebug'

charLimit = 140
finishSentenceAt = 4/5

if ARGV[2].nil?
    puts "Give me prefix, path to text, suffix, [debug]"
    exit 1
end


#print "What is your prefix? "
prefix = ARGV[0]

puts

#print "What is your suffix? "
suffix = ARGV[2]

debug = FALSE
debug = TRUE if ! ARGV[3].nil?

puts

charsLeft = charLimit - (prefix+' '+' '+suffix).length - ' 1/10 '.length

puts "You have #{charsLeft} chars left"
puts '=' *charLimit

if File.exist?(File.expand_path(ARGV[1]))
    text = File.read(File.expand_path(ARGV[1])).strip
else
    text = ARGV[1]
end

text = text.gsub(/([\r\n]+)/, "\r\n")

text = text.gsub(/(\r\n)/, ' (newline) ')

debugger if debug


tweet = prefix + ' '
tweetNum = 1
words = text.split(' ')
tweets = []
endOfRant = FALSE
words.each_with_index { |word, i|
    endofCurrentTweet = FALSE
    sentenceContinue = FALSE
    endOfRant = TRUE if i == words.size - 1

    nextLength = "#{tweet} #{word} #{tweetNum}/nn #{suffix}".length

    print word + ' ' if debug

    if word == '(newline)'
        ## We met a new line token
        print __LINE__.to_s + ' ' if debug
        endOfCurrentTweet = TRUE
    elsif nextLength >= charLimit
        ## We are beyond the space alloted for the size of the tweet
        print __LINE__.to_s + ' ' if debug
        endOfCurrentTweet = TRUE
        sentenceContinue = TRUE
    elsif tweet.length >= charLimit*finishSentenceAt and ['!', '?', '.', ','].member?(tweet[-1, 1])
        ## We have reached the end of the sentence within the
        print __LINE__.to_s + ' ' if debug
        endOfCurrentTweet = TRUE
    else
        ## We still got space, keep building the tweet,
        print __LINE__.to_s + ' ' if debug
        tweet += word + ' '
    end

    sentenceCutDots = ''
    sentenceCutDots = '..' if sentenceContinue

    # Generate and save the current tweet
    if endOfRant
        debugger if debug
        if endOfCurrentTweet
            tweets.push("#{tweet} #{tweetNum}/n #{suffix}")
            tweetNum += 1
            tweet = "#{prefix} #{sentenceCutDots}#{word}"
            tweets.push("#{tweet} #{tweetNum}/#{tweetNum} #{suffix}")
        else
            tweets.push("#{tweet} #{tweetNum}/#{tweetNum} #{suffix}")
        end
    else
        if endOfCurrentTweet
            tweets.push("#{tweet} #{tweetNum}/n #{suffix}")
            tweetNum += 1
            wordForNewTweet = word + ' '
            wordForNewTweet = '' if word == '(newline)'
            tweet = "#{prefix} #{sentenceCutDots}#{wordForNewTweet}"
        end
    end


}

puts ; puts;
tweets.each  {|t|
    puts t.strip
    puts
}



