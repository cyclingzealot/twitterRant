#!/bin/ruby

require 'set'
require 'pathname'

charLimit = 140
finishSentenceAt = 4/5

if ARGV[2].nil?
    puts "Give me prefix, path to text suffix"
    exit 1
end

if ! File.exist?(File.expand_path(ARGV[1]))
    puts "#{ARGV[1]} does not seem to be a path"
end

#print "What is your prefix? "
prefix = ARGV[0]

puts

#print "What is your suffix? "
suffix = ARGV[2]

puts

charsLeft = charLimit - (prefix+' '+' '+suffix).length - ' 1/10 '.length

puts "You have #{charsLeft} chars left"
puts '=' *charsLeft

text = File.read(File.expand_path(ARGV[1]))


tweet = prefix + ' '
tweetNum = 1
startNextTweet = FALSE
sentenceContinue = FALSE
pushCurrentTweet = FALSE
words = text.split(' ')
tweets = []
words.each_with_index { |word, i|

    nextLength = "#{tweet} #{word} #{tweetNum}/nn #{suffix}".length

    if  /\n\s*\n/.match(word)
        ## We have one or more new lines
        startNextTweet  = FALSE
        sentenceContinue = FALSE
        pushCurrentTweet = TRUE
    elsif nextLength >= charsLeft
        ## We are beyond the space alloted for the size of the tweet
        startNextTweet = TRUE
        sentenceContinue = TRUE
        pushCurrentTweet = TRUE
    elsif tweet.length >= charLimit*finishSentenceAt and ['!', '?', '.', ','].member?(tweet[-1, 1])
        ## We have reached the end of the sentence within the
        startNextTweet = TRUE
        sentenceContinue = FALSE
        pushCurrentTweet = TRUE
    elsif i == words.size - 1
        ## We are at the last word of the entire text
        tweets.push("#{tweet} #{word} #{tweetNum}/#{tweets.size+1} #{suffix}")
        startNextTweet = FALSE
        pushCurrentTweet = FALSE
    else
        ## We still got space, keep building the tweet,
        tweet += word + ' '
        startNextTweet = FALSE
        sentenceContinue = FALSE
        pushCurrentTweet = FALSE
    end

    sentenceCutDots = ''
    sentenceCutDots = '..' if sentenceContinue

    # Generate and save the current tweet
    if pushCurrentTweet
        tweets.push("#{tweet} #{tweetNum}/n #{suffix}")
        tweetNum += 1
    end

    # Start the next tweet with the current word
    if startNextTweet
        tweet = "#{prefix} #{sentenceCutDots}#{word} "
    end

}

tweets.each  {|t|
    puts t
    puts
}


