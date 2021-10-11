 dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit", 'even', 'evening']


main_input = "Howdy partner, sit down! How's it going?"

def substrings (input, dictionary)
    split_input = input.downcase.split('').delete_if {|char| char.ord > 'z'.ord || char.ord < 'a'.ord}
    
    hash_count = match_characters(split_input, dictionary)
    puts hash_count
    hash_count
end

def match_characters(input, dictionary)
    matched_words = {}

    dictionary.each do |word|
        matched_words["#{word}"] = 0
        split_word = word.split('')
        i = 0

        input.each do |index|
            if index == split_word[i]
                i += 1
                if (i == split_word.length)
                    matched_words["#{word}"] += 1
                end
            else
                i = 0
            end
        end
    end
    matched_words.select {|key, value| value != 0}
end

substrings(main_input, dictionary)