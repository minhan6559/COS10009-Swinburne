require './input_functions'
# you could use the input functions instead of puts and gets

def display_albums
  
    # complete this code to support the 
    # menu options below - use the main menu code 
    # to guide you.
  finished = false
  begin
    puts 'Display Albums Menu:'
    puts '1 Display All Albums'
    puts '2 Display Albums by Genre'
    puts '3 Return to Main Menu'
    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      display_all_albums
    when 2
      display_all_albums_by_genre
    when 3
      finished = true
    else
      puts "Please select again"
    end
  end until finished
end

# implement stub code for each option in the Display Albums menu
def display_all_albums()
  read_string("You selected Display All Albums. Press enter to continue")
end

def display_all_albums_by_genre()
  read_string("You selected Display Albums By Genre. Press enter to continue")
end

# this is stub code for main menu option 1
def load_albums
  read_string("You selected Load Albums. Press enter to continue")
end

# complete the case statement below and
# add a stub like the one above for option 2
# of this main menu
def main()
  finished = false
  begin
    puts 'Main Menu:'
    puts '1 Load Albums'
    puts '2 Display Albums'
    puts '3 Exit'
    choice = read_integer_in_range("Please enter your choice:", 1, 3)
    case choice
    when 1
      load_albums
    when 2
      display_albums
    when 3
      finished = true
    else
      puts "Please select again"
    end
  end until finished
end

main()
