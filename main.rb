#!/bin/ruby

require 'set'

charLimit = 140
finishSentenceAt = 4/5

print "What is your prefix? "
prefix = $stdin.gets.chomp.strip

puts

print "What is your suffix? "
suffix = $stdin.gets.chomp.strip

puts

charsLeft = charLimit - (prefix+' '+' '+suffix).length - ' 1/10 '.length

puts "You have #{charsLeft} chars left"
puts '=' *charsLeft


print "What is your text? "
text = $stdin.gets.chomp.strip


tweet = prefix + ' '
tweetNum = 1
startNextTweet = FALSE
sentenceContinue = FALSE
words = text.split(' ')
tweets = []
words.each_with_index { |word, i|

    nextLength = "#{tweet} #{word} #{tweetNum}/nn #{suffix}".length

    if nextLength >= charsLeft
        ## We are beyond the space alloted for the size of the tweet
        startNextTweet = TRUE
        sentenceContinue = TRUE
    elsif tweet.length >= charsLeft*finishSentenceAt and ['!', '?', '.'].member?(tweet[-1, 1])
        ## We have reached the end of the sentence within the
        startNextTweet = TRUE
        sentenceContinue = FALSE
    elsif i == words.size - 1
        ## We are at the last word of the entire text
        tweets.push("#{tweet} #{word} #{tweetNum}/#{tweets.size+1} #{suffix}")
        startNextTweet = FALSE
    else
        ## We still got space, keep building the tweet,
        tweet += word + ' '
        startNextTweet = FALSE
        sentenceContinue = FALSE
    end

    if startNextTweet
        sentenceCutDots = ''
        sentenceCutDots = '..' if sentenceContinue

        # Generate and save the current tweet
        tweets.push("#{tweet} #{tweetNum}/n #{suffix}")
        tweetNum += 1

        # Start the next tweet with the current word
        tweet = "#{prefix} #{sentenceCutDots}#{word} "
    end

}

tweets.each  {|t|
    puts t
    puts
}



