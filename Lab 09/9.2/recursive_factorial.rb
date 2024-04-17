# Recursive Factorial

# Complete the following
def factorial(n)
  if n <= 1
    return 1
  end
  return n * factorial(n - 1)
end

def main
  input_string = ARGV[0]
  input_int = input_string.to_i
  if input_int.to_s == input_string and input_int >= 0
    puts factorial(input_int)
  else
    puts("Incorrect argument - need a single argument with a value of 0 or more.\n")
  end
end

main
