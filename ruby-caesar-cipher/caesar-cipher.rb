require 'pry-byebug'
def caesar_cipher(string, shift_factor)

    split_string = string.split('').map do |value|

        if value.ord.between?(65,90)

            aligned_num = return_shifted_code_cap(value.ord, 65)
            shifted_val = (aligned_num + shift_factor) % 26
            (shifted_val + 65).chr

        elsif value.ord.between?(97, 122)

            aligned_num = return_shifted_code(value.ord, 97)
            shifted_val = (aligned_num + shift_factor) % 26
            (shifted_val + 97).chr

        else
            value
        end
    end
    p split_string.join

end


def return_shifted_code (value, mod_by)
    value = value % mod_by

    value
end

caesar_cipher('a to z !!! 123', 26)