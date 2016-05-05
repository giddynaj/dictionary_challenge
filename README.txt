Directions:
This exercise is going to process the dictionary (dictionary.txt). The goal is to find all six-letter words that are built of two concatenated smaller words. For example:

 con + vex => convex
 tail + or => tailor
 we + aver => weaver

Write the program twice:
The first time, make the code as readable as possible.
The second time, make the program run as fast as possible.

Write a single test suite that will test both algorithms. You can have additional tests for each algorithm if you deem it necessary.

You can ask questions or make assumptions on how the program should work. If you make assumptions, be sure to tell us what they are.

Assumptions:
6 letter words found in dictionary are the only 6 letter words in this universe

The list is alphabetical order is that always going to be the case?

The excercise is case-sensitive

Not sure if we want to include all combinations that make same word
This is a one-line modification if we want all combos 


scratch_test.rb:
Brute Force O(N^4)
Data Structure used Array

Brute Force (pruned iterations) O(N^4)
Data Structure used Array

Brute Force (utilizing new data structure to make smaller sets)
Data Structure used Hash of Arrays


test.rb:
Reverse Approach start with 6 character words and find if halves exist
Data Structure used Hash of Arrays

Reverse Approach start with 6 character words and find if halves exist
Data Structure used Hash of Sets

Time Used:
~ 4 Hours

Probably took an hour or two to explore using a testing library and setup
Ended up using Minitest and Filewatcher

Instructions:
ruby test.rb
Will output combos and target words as well as test suite.

