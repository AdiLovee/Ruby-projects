class Caesar
 def setup_lookup_tables(decrypted_alphabet, encrypted_alphabet)
   @encryption_hash = {}
   @decryption_hash = {}
   0.upto(decrypted_alphabet.size) do |index|
     @encryption_hash[decrypted_alphabet[index]] = encrypted_alphabet[index]
     @decryption_hash[encrypted_alphabet[index]] = decrypted_alphabet[index]
   end
 end
 def encrypt(string)
   result = []
   string.each_char do |c|
     if @encryption_hash[c]
       result << @encryption_hash[c]
     else
       result << c
     end
   end
   result.join
 end
 def decrypt(string)
   result = []
   string.each_char do |c|
     if @decryption_hash[c]
       result << @decryption_hash[c]
     else
       result << c
     end
   end
   result.join
 end
 def initialize(shift)
   alphabet_lower = 'abcdefghijklmnopqrstuvwxyz'
   alphabet_upper = alphabet_lower.upcase
   alphabet = alphabet_lower + alphabet_upper
   index = shift % alphabet.size
   encrypted_alphabet = alphabet[index..-1] + alphabet[0...index]
   setup_lookup_tables(alphabet, encrypted_alphabet)
 end
# code will go here
end
