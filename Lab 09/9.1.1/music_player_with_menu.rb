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

def draw_dividing_line()
    puts "\n" + "-" * 80
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
        puts "File does not exist. Please enter a valid file path. \n"
        file_path = read_string("Enter the file path: ")
    end

    puts "Successfully read file. Back to main menu."

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

# Display Album Menu
def display_albums_menu(albums)
    if albums.length == 0
        puts "No albums to display. Please read in albums first."
        return
    end
    
    while true
        puts "Display Album Menu"
        puts "1. Display all albums"
        puts "2. Display albums by genre"
        puts "3. Exit"

        choice = read_integer_in_range("Enter your choice: ", 1, 3)
        draw_dividing_line()

        case choice
        when 1
            display_albums(albums)
        when 2
            display_albums_by_genre(albums)
        when 3
            puts "Back to main menu."
            break
        else
            puts "Invalid choice. Please enter a valid choice."
        end
        draw_dividing_line()
    end
end

def display_albums(albums)
    puts "ID".ljust(5) + "Title".ljust(20) + "Artist".ljust(20) + "Label".ljust(20) + "Genre".ljust(20)
    i = 0
    while i < albums.length
        album = albums[i]
        puts i.to_s.ljust(5) + album.title.ljust(20) + album.artist.ljust(20) + album.label.ljust(20) + $genre_names[album.genre].ljust(20)
        i += 1
    end
end

def display_albums_by_genre(albums)
    i = 1
    while i < $genre_names.length
        puts "#{i}. #{$genre_names[i]}"
        i += 1
    end

    genre = read_integer_in_range("Enter the genre: ", 1, 4)

    draw_dividing_line()
    puts "Title".ljust(20) + "Artist".ljust(20) + "Label".ljust(20) + "Genre".ljust(20)
    i = 0
    while i < albums.length
        album = albums[i]
        if album.genre == genre
            puts album.title.ljust(20) + album.artist.ljust(20) + album.label.ljust(20) + $genre_names[album.genre].ljust(20)
        end
        i += 1
    end
end

# Select Album Menu
def select_album_menu(albums)
    if albums.length == 0
        puts "No albums to display. Please read in albums first."
        return
    end

    display_albums(albums)
    album_id = read_integer_in_range("Enter the album ID: ", 0, albums.length - 1)
    album = albums[album_id]

    draw_dividing_line()
    select_track_menu(album)
end

def select_track_menu(album)
    puts "Title".ljust(20) + "Artist".ljust(20) + "Label".ljust(20) + "Genre".ljust(20)
    puts album.title.ljust(20) + album.artist.ljust(20) + album.label.ljust(20) + $genre_names[album.genre].ljust(20)

    if album.tracks.length == 0
        puts "\nThere are no tracks in this album."
        return
    end

    puts "\nList of Tracks"
    i = 0
    while i < album.tracks.length
        puts "#{i}. #{album.tracks[i].name}"
        i += 1
    end

    track_id = read_integer_in_range("Enter the track ID: ", 0, album.tracks.length - 1)
    track = album.tracks[track_id]

    draw_dividing_line()
    puts "Playing \"#{track.name}\" from \"#{album.title}\""
end

def main()
    albums = []
    while true
        puts "Main Menu"
        puts "1. Read in Album"
        puts "2. Display Albums"
        puts "3. Select an album to play"
        puts "5. Exit"
        choice = read_integer_in_range("Enter your choice: ", 1, 5)

        draw_dividing_line()
        case choice
        when 1
            albums = read_albums()
        when 2
            display_albums_menu(albums)
        when 3
            select_album_menu(albums)
        when 5
            puts "BYE !!!!"
            break
        else
            puts "Invalid choice. Please enter a valid choice."
        end

        draw_dividing_line()
    end
end

main if __FILE__ == $0