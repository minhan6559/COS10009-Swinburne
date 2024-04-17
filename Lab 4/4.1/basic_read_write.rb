# writes the number of lines then each line as a string.

def write_data_to_file(file_name)
   a_file = File.new(file_name, "w") # open for writing
   a_file.puts('5')
   a_file.puts('Fred')
   a_file.puts('Sam')
   a_file.puts('Jill')
   a_file.puts('Jenny')
   a_file.puts('Zorro')
   a_file.close()
end

# reads in each line.
# Do the following in WEEK 5
# you need to change the following code
# so that it uses a loop which repeats
# acccording to the number of lines in the File
# which is given in the first line of the File
def read_data_from_file(file_name)
  a_file = File.new(file_name, "r") # open for reading
  count = a_file.gets.to_i()
  i = 0
  while i < count
    puts a_file.gets()
    i += 1
  end
  a_file.close()
end

# Do the following in WEEK 4
# writes data to a file then reads it in and prints
# each line as it reads.
# you should improve the modular decomposition of the
# following by moving as many lines of code
# out of main as possible.
def main
  write_data_to_file('my_data.txt')
  read_data_from_file('my_data.txt')
end

main

