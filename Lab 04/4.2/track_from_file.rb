class Track
    attr_accessor :name, :location
end

def read_track(a_file)
    name = a_file.gets()
    location = a_file.gets()

    track = Track.new()
    track.name = name
    track.location = location
    return track
end

def print_track(track)
    puts("Track name: " + track.name)
    puts("Track location: " + track.location)
end

def main()
    a_file = File.new('track.txt', 'r')
    track = read_track(a_file)
    a_file.close()
    print_track(track)
end

# leave this line
main() if __FILE__ == $0
