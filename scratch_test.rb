#class MadeUpOf 
#  attr_accessor :dic
#
#  # Initialize will take name of a file and put it into a hash
#  def initialize(dic)
#    @dic = [] 
#    if !dic.nil? && File.exist?(dic)
#      File.open(dic,'r') do |f|
#       f.each_line do |line|
#         if line.chomp.length <= 6
#           @dic << line.chomp
#         end
#       end 
#      end
#    end
#  end
#
#  def find_words(target_length)
#    dic = []
#    @dic.each_with_index do |word, index|
#      case word.length
#       when target_length 
#        dic << word 
#      end
#    end
#    dic
#  end
#
#
#  def find_6_character_words_N4
#    # brute force method
#    # Complexity on the order of O(n^4)
#    # Takes way too long
#    @dic.map do |word|
#      puts "finding compatible words for #{word}"
#      compatible = find_words(6 - word.length)
#      m = compatible.map do |compat|
#        d = @dic.find do |f| 
#          if f.length == 6
#          puts "testing #{word + compat} with #{f}"
#          f == word + compat 
#          end
#        end 
#      end
#      puts m[-1]
#      m
#    end.flatten.compact
#  end
#
#  def find_6_character_words_N4a
#    # Lets start pruning each scan
#    # Complexity on the order of O(N^4) -> O(n^4)
#    # Also take a very long time
#    six_letter  = find_words(6)
#    @dic.map do |word|
#      if word.length < 6
#      puts "finding compatible words for #{word}"
#      compatible = find_words(6 - word.length)
#      m = compatible.map do |compat|
#        # simply find of the subset of 6 letter words
#        d = six_letter.find do |f| 
#          if f.length == 6
#          puts "testing #{word + compat} with #{f}"
#          f == word + compat 
#          end
#        end 
#        d
#      end
#      puts m[-1]
#      m
#      end
#    end.flatten.compact
#  end
#
#  def find_6_character_words_N4b
#    # Lets start pruning each scan
#    # Complexity on the order of O(N^4) -> O(n^4)
#    # Also take a very long time
#    six_letter  = find_words(6)
#    @dic.map do |word|
#      if word.length < 6
#      puts "finding compatible words for #{word}"
#      compatible = find_words(6 - word.length)
#      m = compatible.map do |compat|
#        # simply find of the subset of 6 letter words
#        d = six_letter.find do |f| 
#          if f.length == 6
#          puts "testing #{word + compat} with #{f}"
#          f == word + compat 
#          end
#        end 
#        d
#      end
#      puts m[-1]
#      m
#      end
#    end.flatten.compact
#  end
#end

class MadeUpOf2
  attr_accessor :dic

  # Initialize will take name of a file and put it into a hash
  def initialize(dic)
    @dic = {} 
    if !dic.nil? && File.exist?(dic)
      File.open(dic,'r') do |f|
       f.each_line do |line|
         sym = ("l" + line.chomp.length.to_s).to_sym
         @dic[sym] ||= []
         @dic[sym] << line.chomp
       end 
      end
    end
  end

  def find_6_character_words
    # Lets start pruning each scan
    # Complexity on the order of O(N^4) -> O(n^4)
    # Also take a very long time
    (1...5).map do |index|
      if !@dic["l#{index}".to_sym].nil?
      @dic["l#{index}".to_sym].map do |word|
        inverse_index_sym = ("l" + (6 - index).to_s).to_sym
        if !@dic[inverse_index_sym].nil?
        @dic[inverse_index_sym].map do |compat|
          @dic[:l6].find do |f|
            puts "testing #{word + compat} with #{f}"
            f == word + compat
          end
        end
        end #if exists
      end
    end
    end.flatten.compact
  end

  def find_6_character_words_fast
    # Lets start pruning each scan
    # Complexity on the order of O(N^4) -> O(n^4)
    # Also take a very long time
    @dic[:l6].map do |word|
      (1...5).map do |index|
        pre = word[0..(index-1)]
        post = word[index..-1]
        pre_test = @dic[("l" + index.to_s).to_sym].find do |p|
          p == pre 
        end
        post_test = @dic[("l" + (6-index).to_s).to_sym].find do |p|
          p == post
        end
        puts "testing #{word} pre #{pre} and post #{post}"
        word if pre_test && post_test
      end
    end.flatten.compact
  end
end

class MadeUpOf3
  attr_accessor :dic

  ## Initialize will take name of a file and put it into a hash of sets
  ## Ruby set is setup on Hash and index will make searching portion of O(1)
  
  def initialize(dic)
    @dic = {} 
    if !dic.nil? && File.exist?(dic)
      File.open(dic,'r') do |f|
       f.each_line do |line|
         sym = ("l" + line.chomp.length.to_s).to_sym
         @dic[sym] ||= Set.new
         @dic[sym].add(line.chomp)
       end 
      end
    end
  end

  def find_6_character_words

    ## Scan through 6 character words break them down and       ##
    ## check if those halves exist in their respective buckets  ##
    @dic[:l6].map do |word|

      ## Use range to provide a splitting index
      (1...5).map do |index|

        ## Split word and set tests to false
        pre = word[0..(index-1)]
        post = word[index..-1]
        pre_test = false
        post_test = false
        pre_index = ("l" + index.to_s).to_sym
        post_index = ("l" + (6-index).to_s).to_sym

        ## Handle for only indexes that exist
        if !@dic[pre_index].nil? && !@dic[post_index].nil?

          ## Utilize member method of Set to set test flags
          pre_test = @dic[pre_index].member?(pre)
          post_test = @dic[post_index].member?(post)
          #puts "testing #{word} pre #{pre} and post #{post}"
        end

        ## include word in results of both test pass        
        word if pre_test && post_test
      end

    end.flatten.compact
  end
end

if __FILE__ == $0
  require 'pry'
  require 'minitest/autorun'
  require 'set'
#  class TestMadeUpOf < Minitest::Test
#    def setup
#      `touch dic.txt; echo 'a\nlot\nalot\nlofty\nalofty' >> dic.txt` 
#      @muo = MadeUpOf.new('dic.txt')
#      @dic = ['a','lot','alot','lofty','alofty'] 
#    end
#
#    def teardown
#      `rm dic.txt`
#    end
#    
#    #def test_has_file_argument
#    #  assert_equal @muo.dic , @dic
#    #end
#
#
#    #def test_file_length
#    #  assert_operator @muo.dic.length, :== , 5 
#    #end
#   
#    #def test_find_parts_of_word
#    #  assert_equal @muo.find_words(4), ['alot']
#    #end
#
#    #def test_find_6_character_words_N4
#    #  assert_equal @muo.find_6_character_words_N4, ['alofty']
#    #end
#
#
#  end
#  class TestMadeUpOf2 < Minitest::Test
#    def setup
#      `touch dic.txt; echo 'a\nlot\nalot\nlofty\nalofty' >> dic.txt` 
#      @muo = MadeUpOf2.new('dic.txt')
#      @dic = {:l1 => ['a'],:l3 => ['lot'], :l4 => ['alot'], :l5 => ['lofty'], :l6 => ['alofty']}
#    end
#
#    def teardown
#      `rm dic.txt`
#    end
#    
#  #  def test_import_file
#  #    assert_equal @muo.dic, @dic
#  #  end
#  #  def test_find_6_character_words
#  #    puts @muo.find_6_character_words
#  #  end
#  #
#  #  def test_find_words
#  #    puts @muo.dic[:l6]
#  #  end
#  end
  class TestMadeUpOf3 < Minitest::Test
    def setup
      `touch dic.txt; echo 'a\nlot\nalot\nlofty\nalofty' >> dic.txt` 
      @muo = MadeUpOf3.new('dic.txt')
    end

    def teardown
      `rm dic.txt`
    end
    
    def test_import_file
      assert @muo.dic[:l1].member?("a")
      assert @muo.dic[:l3].member?("lot")
      assert @muo.dic[:l4].member?("alot")
      assert @muo.dic[:l5].member?("lofty")
    end

    def test_find_6_character_words
      assert_equal @muo.find_6_character_words, ['alofty']
    end
  end

  class TestActualMadeUpOf < Minitest::Test
    def setup
      @muo = MadeUpOf3.new('dictionary.txt')
    end

    def test_find_6_character_words
      puts @muo.find_6_character_words
    end
  end
end

