require './input_functions'
# put your code here - make sure you use the input_functions to read strings and integers

# This function reads in the components of user's address and return the formatted address
def read_address()
  house_number = read_string("Please enter the house or unit number:")
  street = read_string("Please enter the street name:")
  suburb = read_string("Please enter the suburb:")
  postcode = read_integer_in_range("Please enter a postcode (0000 - 9999)", 0, 9999)

  formatted_address = "#{house_number} #{street}\n#{suburb} #{postcode}"

  return formatted_address
end

# This function reads in the components of user's name and return the formatted name
def read_name()
  title = read_string("Please enter your title: (Mr, Mrs, Ms, Miss, Dr)")
  first_name = read_string("Please enter your first name:")
  last_name = read_string("Please enter your last name:")

  formatted_name = "#{title} #{first_name} #{last_name}"

  return formatted_name
end

# This function reads in user's name and address and then returns the formatted label
def read_label()
  name = read_name()
  address = read_address()

  formatted_label = "#{name}\n#{address}"

  return formatted_label
end

# This function reads in the subject line and content of the message and then returns the formatted message
def read_message()
  subject_line = read_string("Please enter your message subject line:")
  content = read_string("Please enter your message content:")

  formatted_message = "RE: #{subject_line}\n\n#{content}"

  return formatted_message
end

# This function takes label and message as the arguments and then prints the letter to the terminal
def print_letter(label, message)
  formatted_letter = "#{label}\n#{message}"
  puts(formatted_letter)
end

def main()
  label = read_label()
  message = read_message()
  print_letter(label, message)
end

main()
