require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BACKGROUND_COLOR = Gosu::Color.argb(0xff_70d7ff)
SCALE_FACTOR = 0.4

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

module ScreenType
	ALBUMS, TRACKS = *0..1
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

# Put your record definitions here
class Album
	attr_accessor :title, :artist, :genre, :artwork, :tracks

	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
	end
end

class Track
	attr_accessor :title, :location

	def initialize (title, location)
		@title = title
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
    title = file.gets.chomp
    artist = file.gets.chomp
	artwork_name = file.gets.chomp
    tracks = read_tracks(file)
    return Album.new(title, artist, artwork_name, tracks)
end

def read_albums()
    albums = []
    file = File.new('albums.txt', 'r')
    count = file.gets.to_i

    i = 0
    while i < count
        albums << read_album(file)
        i += 1
    end

    file.close
    return albums
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 500, 700
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		@albums = read_albums()
		@big_font = Gosu::Font.new(20)
		@small_font = Gosu::Font.new(10)

		@screen_type = ScreenType::ALBUMS
		@selected_album = 0
		@selected_track = 0
	end
	
  def draw_albums(albums)

  end

  def area_clicked(leftX, topY, rightX, bottomY)

  end


  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos)
  	@small_font.draw(title, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		Gosu.draw_rect(0, 0, 500, 700, BACKGROUND_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

	def update
	end

	def draw
		# Complete the missing code
		draw_background()
		img = Gosu::Image.new("images/" + "After_Hours.bmp")
		# draw img with scale of 0.5
		img.draw(0, 0, ZOrder::PLAYER, scale_x = 0.4, scale_y = 0.4)
	end

 	def needs_cursor?; true; end

	def button_down(id)
		case id
	    when Gosu::MsLeft

	    end
	end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0