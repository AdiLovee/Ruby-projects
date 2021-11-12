#
# Ruby For Kids Project 8: Code Breaker
# Programmed By: Chris Haupt
# A program yhat will encryot and decrypt another document using the Caesar cipher
#

require_relative "codebreaker"

puts "Code Breaker will encrypt or decrypt a file of your choice"
puts ""

codebreaker = CodeBreaker.new
if codebreaker.run
 puts "All done!"
else
 puts "Didn't work!"
end
