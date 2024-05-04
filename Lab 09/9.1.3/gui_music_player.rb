require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BACKGROUND_COLOR = Gosu::Color.argb(0xff_252526)
ARTWORK_WIDTH = 544

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
		@big_font = Gosu::Font.new(25)
		@small_font = Gosu::Font.new(18)
		@credit_font = Gosu::Font.new(15)

		@screen_type = ScreenType::ALBUMS
		@selected_album = 0
		@selected_track = 0
		@change_track = true
		@manual_pause = false
	end
	
	def draw_albums_screen(albums)
		choose_prompt = "Choose an Album to play"
		x_choose = (500 - @big_font.text_width(choose_prompt, 1.0)) / 2
		@big_font.draw_text(choose_prompt, x_choose, 34, ZOrder::UI, 1.0, 1.0, Gosu::Color::AQUA)

		i = 0
		while i < 2
			j = 0
			while j < 2
				album = albums[i * 2 + j]
				artwork = Gosu::Image.new("images/#{album.artwork}.bmp")
				artwork.draw(24 + j * 236, 91 + i * 302, ZOrder::UI, scale_x = 0.4, scale_y = 0.4)

				x_text = 132 + j * 236
				x_minus = @small_font.text_width(album.title, 1.0) / 2.0

				y_text = 317 + i * 302

				@small_font.draw_text(album.title, x_text - x_minus, y_text, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
				j += 1
			end
			i += 1
		end
	end

	def draw_tracks_screen(album)
		home_btn = Gosu::Image.new("buttons/Home_Button.png")
		home_btn.draw(10, 9, ZOrder::UI)
		@small_font.draw_text("Back to Home", 36, 12, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		
		# Draw the album title
		x_title = 244
		x_minus = @big_font.text_width(album.title, 1.0) / 2.0
		y_title = 58
		@big_font.draw_markup("<b>#{album.title}</b>", x_title - x_minus, y_title, ZOrder::UI, 1.0, 1.0, Gosu::Color::AQUA)

		# Draw the album artwork
		artwork = Gosu::Image.new("images/#{album.artwork}.bmp")
		artwork.draw(114, 101, ZOrder::UI, scale_x = 0.5, scale_y = 0.5)

		# Draw the artist
		x_artist = 246
		x_minus = @small_font.text_width(album.artist, 1.0) / 2.0
		y_artist = 379
		@small_font.draw_text(album.artist, x_artist - x_minus, y_artist, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

		# Draw the tracks
		Gosu.draw_rect(115, 420, 272, 133, Gosu::Color.argb(0xff_8E8E93), ZOrder::PLAYER, mode=:default)

		i = 0
		while i < album.tracks.length
			track = album.tracks[i]
			y_track = 430 + i * 30

			track_title = track.title
			track_color = Gosu::Color::WHITE
			if i == @selected_track
				track_title = "<b>#{track.title}</b>"
				track_color = Gosu::Color.argb(0xff_4FCEFF)
				if @change_track
					@song = Gosu::Song.new(track.location)
					@song.play(false)
					@change_track = false
				end
			end
			@small_font.draw_markup(track_title, 128, y_track, ZOrder::UI, 1.0, 1.0, track_color)
			i += 1
		end

		if not @song.playing? and not @manual_pause
			@selected_track = (@selected_track + 1) % album.tracks.length
			@change_track = true
		end

		# Draw media buttons
		btns = Gosu::Image.new("buttons/Media_Buttons.png")
		btns.draw(161, 575, ZOrder::UI)
	end


	# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		Gosu.draw_rect(0, 0, 500, 700, BACKGROUND_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

	# Handle the button_down event
	def handle_mouse_albums(x, y)
		i = 0
		while i < 2
			j = 0
			while j < 2
				if x.between?(24 + j * 236, 24 + j * 236 + ARTWORK_WIDTH * 0.4) && y.between?(91 + i * 302, 91 + i * 302 + ARTWORK_WIDTH * 0.4)
					@selected_album = i * 2 + j
					@screen_type = ScreenType::TRACKS
				end
				j += 1
			end
			i += 1
		end
	end

	def handle_mouse_tracks(x, y)
		# Back to home
		if x.between?(10, 10 + 22 + @small_font.text_width("Back to Home", 1.0)) && y.between?(9, 9 + 22)
			@screen_type = ScreenType::ALBUMS
			@selected_track = 0
			@song.stop
			@change_track = true
			@manual_pause = false
		end

		# Select track
		i = 0
		while i < @albums[@selected_album].tracks.length
			if x.between?(115, 115 + 272) && y.between?(420 + i * 30, 420 + i * 30 + 30)
				if @selected_track != i
					@selected_track = i
					@change_track = true
				end
			end
			i += 1
		end

		# Media buttons
		# Previous
		if x.between?(161, 161 + 40) && y.between?(575, 575 + 40)
			@song.stop
			@selected_track = (@selected_track - 1) % @albums[@selected_album].tracks.length
			@change_track = true
		end

		# Play/Pause
		if x.between?(230, 230 + 40) && y.between?(575, 575 + 40)
			if @song.playing?
				@song.pause
				@manual_pause = true
			else
				@song.play
				@manual_pause = false
			end
		end

		# Next
		if x.between?(300, 300 + 40) && y.between?(575, 575 + 40)
			@song.stop
			@selected_track = (@selected_track + 1) % @albums[@selected_album].tracks.length
			@change_track = true
		end
	end

	def draw
		draw_background()

		case @screen_type
		when ScreenType::ALBUMS
			draw_albums_screen(@albums)
		when ScreenType::TRACKS
			draw_tracks_screen(@albums[@selected_album])
		end

		# Draw credit
		credit_text = "@Created by Minh An Nguyen, 2024"
		x_credit = (500 - @credit_font.text_width(credit_text, 1.0)) / 2
		@credit_font.draw_text(credit_text, x_credit, 666, ZOrder::UI, 1.0, 1.0, Gosu::Color.argb(0xff_70D7FF))
	end

 	def needs_cursor?; true; end

	def button_down(id)
		case id
	    when Gosu::MsLeft
			case @screen_type
			when ScreenType::ALBUMS
				handle_mouse_albums(mouse_x, mouse_y)
			when ScreenType::TRACKS
				handle_mouse_tracks(mouse_x, mouse_y)
			end
	    end
	end

end

MusicPlayerMain.new.show if __FILE__ == $0