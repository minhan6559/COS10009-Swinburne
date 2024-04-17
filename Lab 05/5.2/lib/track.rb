class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end


# reads in a single track from the given file.
def read_track(a_file)
  # complete this function
	# you need to create a Track here.
  name = a_file.gets 
  loc = a_file.gets 
  track = Track.new(name, loc)
  return track
end

# Takes a single track and prints it to the terminal
def print_track(track)
    puts("Track name: #{track.name}")
    puts("Track location: #{track.location}")
end

# Open the file and read in the tracks then print them
def main()
  file = File.new("track.txt", "r")
  track = read_track(file)
  file.close
  print_track(track)
end

main if __FILE__ == $0 # need this for the testing
