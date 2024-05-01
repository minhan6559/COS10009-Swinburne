require_relative './input_functions'

# It is suggested that you put together code from your 
# previous tasks to start this. eg:
# 8.1T Read Album with Tracks

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
    attr_accessor :artist, :title, :label, :genre, :tracks

    def initialize(artist, title, label, genre, tracks)
        @artist = artist
        @title = title
        @label = label
        @genre = genre
        @tracks = tracks
    end
end

class Track
    attr_accessor :name, :location

    def initialize(name, location)
        @name = name
        @location = location
    end
end

def read_track(file)
    track_name = file.gets.chomp
    track_location = file.gets.chomp
    return Track.new(track_name, track_location)
end

def read_tracks(file)
    tracks = []
    count = file.gets.to_i
    i = 0
    while i < count
        tracks << read_track(file)
        i += 1
    end
    return tracks
end

def read_album(file)
    artist = file.gets.chomp
    title = file.gets.chomp
    label = file.gets.chomp
    genre = file.gets.chomp.to_i
    tracks = read_tracks(file)
    return Album.new(artist, title, label, genre, tracks)
end

def read_albums()
    file_path = read_string("Enter the file path: ")

    while !File.exists?(file_path)
        puts "File does not exist. Please enter a valid file path."
        file_path = read_string("Enter the file path: ")
    end

    puts "Successfully read file. Press enter to continue."
    gets

    albums = []
    file = File.new(file_path, 'r')
    count = file.gets.to_i
    i = 0
    while i < count
        albums << read_album(file)
        i += 1
    end
    file.close
    return albums
end

def main()
    albums = []
    while true
        puts "Music Player Menu"
        puts "1. Read in Album"
        puts "2. Display Albums"
        puts "3. Select an album to play"
        puts "5. Exit"
        choice = read_integer_in_range("Enter your choice: ", 1, 5)

        system("clear")

        case choice
        when 1
            albums = read_albums
        when 2

        when 3

        when 4

        when 5
            break
        else
            puts "Invalid choice. Please enter a valid choice."
        end

        system("clear")
    end
end

main if __FILE__ == $0