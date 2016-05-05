class MadeUpOf2
  attr_accessor :dic

  ## Initialize will take name of a file and put it into a hash of arrays
  def initialize(dic)

    ## Setup variables
    @dic = {} 

    ## Check file isn't nil and that the file exists
    if !dic.nil? && File.exist?(dic)
      File.open(dic,'r') do |f|
       f.each_line do |line|

         ## Only take 6 character or less words
         if line.chomp.length <= 6

         ## create symbol index for hash, prefix with l because hash won't take numerical key
         ## use length of words to be second character in key, bucket all words here
         sym = ("l" + line.chomp.length.to_s).to_sym
         @dic[sym] ||= []
         @dic[sym] << line.chomp
         end
       end 
      end
    end
  end

  def find_6_character_words(n=-1)

    ## Scan through 6 character words allow for subsetting to test for performance of lesser number of words
    @dic[:l6][0..n].map do |word|

      ## Use an index to halve the words at differing lengths
      (1...5).map do |index|

        ## Halve words and set test flags if they exist in dictionary
        pre = word[0..(index-1)]
        post = word[index..-1]
        pre_test = @dic[("l" + index.to_s).to_sym].find do |p|
          p == pre 
        end
        post_test = @dic[("l" + (6-index).to_s).to_sym].find do |p|
          p == post
        end

        ## Output feedback
        puts "testing #{word} pre #{pre} and post #{post}"
    
        ## include word in map if both tests pass
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

         ## words less than 6 characters put in Set to be indexed
         if line.chomp.length < 6
           sym = ("l" + line.chomp.length.to_s).to_sym
           @dic[sym] ||= Set.new
           @dic[sym].add(line.chomp)
         end

         ## words 6 characters put in array to allow for scaling number of words to test
         if line.chomp.length == 6
           sym = ("l" + line.chomp.length.to_s).to_sym
           @dic[sym] ||= [] 
           @dic[sym] << line.chomp
         end
       end 
      end
    end
  end

  def loop(element)
    for elm in element 
      yield
    end
  end

  def find_6_character_words(n=-1)
    ## Result
    results = []

    ## Scan through 6 character words break them down and       ##
    ## check if those halves exist in their respective buckets  ##
    @dic[:l6][0..n].map do |word|

      ## Use range to provide a splitting index
      (1...5).each do |index|

        ## Split word and set tests to false
        pre = word[0..(index-1)]
        post = word[index..-1]
        pre_test = false
        post_test = false

        ## Create symbols
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
        entry = pre + " + " + post + " = " + word
      
        results << entry if pre_test && post_test
        break if pre_test && post_test
      end

    end
    results
  end
end

if __FILE__ == $0
  require 'pry'
  require 'minitest/autorun'
  require 'minitest/benchmark'
  require 'set'
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
      assert_equal @muo.find_6_character_words, ["a + lofty = alofty"]
    end
  end

  class TestActualMadeUpOf2 < Minitest::Test
    def setup
      @muo = MadeUpOf2.new('dictionary.txt')
    end

    def test_length_of_import
      assert_equal @muo.dic.length, 6
    end

    #def test_find_6_character_words_not_empty
    #  assert !@muo.find_6_character_words.empty?
    #end

    #def test_find_6_character_words
    #  puts @muo.find_6_character_words
    #end

   end

  class TestActualMadeUpOf3 < Minitest::Test
    def setup
      @muo = MadeUpOf3.new('dictionary.txt')
    end

    def test_length_of_import
      assert_equal @muo.dic.length, 6
    end

    def test_find_6_character_words_not_empty
      assert !@muo.find_6_character_words.empty?
    end

    def test_find_6_character_words
      puts @muo.find_6_character_words
    end

   end


  class TestBenchOfMadeUpOf < Minitest::Benchmark
    def setup
      @muo = MadeUpOf3.new('dictionary.txt')
    end
  #Override self.bench_range or default range is [1, 10, 100, 1_000, 10_000]
     def bench_madeupof
         assert_performance_linear 0.99 do |n| # n is a range value
               @muo.find_6_character_words(n)
         end
     end
  end

end

