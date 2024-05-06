require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BACKGROUND_COLOR = Gosu::Color.argb(0xff_252526)
ARTWORK_WIDTH = 544

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

module ScreenType
	ALBUMS, TRACKS = *0..1
end

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

def read_albums(file_name)
    albums = []
    file = File.new(file_name, 'r')
    count = file.gets.to_i

    i = 0
    while i < count
        albums << read_album(file)
        i += 1
    end

    file.close
    return albums
end

def read_artworks(albums)
	artworks = []
	i = 0

	while i < albums.length
		artworks << Gosu::Image.new("images/#{albums[i].artwork}.png")
		i += 1
	end
	return artworks
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 500, 700
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		@albums = read_albums('albums.txt')
		@artworks = read_artworks(@albums)

		# Fonts
		@big_font = Gosu::Font.new(25)
		@small_font = Gosu::Font.new(18)
		@credit_font = Gosu::Font.new(15)

		@screen_type = ScreenType::ALBUMS
		@selected_album = 0
		@selected_track = 0
		@volume = 1.0
		@song = nil

		# Flags
		@change_track = true
		@manual_pause = false
		@mute = false
		@is_dragging_volume = false # For volume bar

		# Buttons Images
		@home_btn = Gosu::Image.new("elements/Home_Button.png")
		@media_btns_play = Gosu::Image.new("elements/Media_Buttons_Play.png")
		@media_btns_pause = Gosu::Image.new("elements/Media_Buttons_Pause.png")
		@speaker = Gosu::Image.new("elements/Speaker.png")
		@speaker_mute = Gosu::Image.new("elements/Speaker_Mute.png")
		@slider_border = Gosu::Image.new("elements/Slider_Border.png")
		@slider_inner = Gosu::Image.new("elements/Slider_Inner.png")
		@slider_background = Gosu::Image.new("elements/Slider_Background.png")
		@track_box = Gosu::Image.new("elements/Track_Box.png")
	end
	
	def draw_albums_screen(albums)
		choose_prompt = "Choose an Album to play"
		x_choose = (500 - @big_font.text_width(choose_prompt, 1.0)) / 2
		@big_font.draw_text(choose_prompt, x_choose, 34, ZOrder::TOP, 1.0, 1.0, Gosu::Color::AQUA)

		i = 0
		while i < 2
			j = 0
			while j < 2
				index = i * 2 + j
				album = albums[index]
				@artworks[index].draw(24 + j * 236, 91 + i * 302, ZOrder::TOP, scale_x = 0.4, scale_y = 0.4)

				x_text = 132 + j * 236
				x_minus = @small_font.text_width(album.title, 1.0) / 2.0

				y_text = 317 + i * 302

				@small_font.draw_text(album.title, x_text - x_minus, y_text, ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)
				j += 1
			end
			i += 1
		end
	end

	def draw_tracks_screen(album)
		@home_btn.draw(10, 9, ZOrder::TOP)
		@small_font.draw_text("Back to Home", 36, 12, ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)
		
		# Draw the album title
		x_title = 244
		x_minus = @big_font.text_width(album.title, 1.0) / 2.0
		y_title = 58
		@big_font.draw_markup("<b>#{album.title}</b>", x_title - x_minus, y_title, ZOrder::TOP, 1.0, 1.0, Gosu::Color::AQUA)

		# Draw the album artwork
		@artworks[@selected_album].draw(114, 101, ZOrder::TOP, scale_x = 0.5, scale_y = 0.5)

		# Draw the artist
		x_artist = 246
		x_minus = @small_font.text_width(album.artist, 1.0) / 2.0
		y_artist = 379
		@small_font.draw_text(album.artist, x_artist - x_minus, y_artist, ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)

		# Draw the tracks
		@track_box.draw(115, 418, ZOrder::MIDDLE)

		i = 0
		while i < album.tracks.length
			track = album.tracks[i]
			y_track = 430 + i * 30

			track_title = track.title
			track_color = Gosu::Color::WHITE
			if i == @selected_track
				track_title = "<b>#{track.title}</b>"
				track_color = Gosu::Color.argb(0xff_4FCEFF)
			end
			@small_font.draw_markup(track_title, 128, y_track, ZOrder::TOP, 1.0, 1.0, track_color)
			i += 1
		end

		# Draw media elements
		if @manual_pause
			@media_btns_play.draw(161, 575, ZOrder::TOP)
		else
			@media_btns_pause.draw(161, 575, ZOrder::TOP)
		end

		if @song.volume == 0
			@speaker_mute.draw(120, 622, ZOrder::TOP)
		else
			@speaker.draw(120, 622, ZOrder::TOP)
		end

		# Draw the volume bar
		@slider_background.draw(162, 629, ZOrder::MIDDLE)
		if @song.volume > 0
			slider_inner = @slider_inner.subimage(0, 0, (176 * @song.volume).to_i, 13)
			slider_inner.draw(162, 629, ZOrder::TOP)
		end
		@slider_border.draw(162, 629, ZOrder::TOP)
	end

	def draw_background
		Gosu.draw_rect(0, 0, 500, 700, BACKGROUND_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

	def draw_credit
		credit_text = "@Created by Minh An Nguyen, 2024"
		x_credit = (500 - @credit_font.text_width(credit_text, 1.0)) / 2
		@credit_font.draw_text(credit_text, x_credit, 666, ZOrder::TOP, 1.0, 1.0, Gosu::Color.argb(0xff_70D7FF))
	end

	# Handle the button_down event
	def handle_mouse_albums_screen(x, y)
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

	def handle_mouse_tracks_screen(x, y)
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
			if x.between?(115, 115 + 272) && y.between?(430 + i * 30, 430 + i * 30 + 30)
				if @selected_track != i
					@selected_track = i
					@change_track = true
				end
			end
			i += 1
		end

		# Media elements
		# Previous
		if x.between?(161, 161 + 40) && y.between?(575, 575 + 40)
			@selected_track = (@selected_track - 1) % @albums[@selected_album].tracks.length
			@change_track = true
		end

		# Play/Pause
		if x.between?(230, 230 + 40) && y.between?(575, 575 + 40)
			if @song.playing?
				@song.pause
			else
				@song.play(false)
			end
			@manual_pause = (not @manual_pause)
		end

		# Next
		if x.between?(300, 300 + 40) && y.between?(575, 575 + 40)
			@selected_track = (@selected_track + 1) % @albums[@selected_album].tracks.length
			@change_track = true
		end

		# Speaker
		if x.between?(120, 120 + 40) && y.between?(622, 622 + 40)
			if not @mute and @song.volume == 0
				@mute = true
				@volume = 1.0
			end
			@mute = (not @mute)
		end

		# Volume bar
		if mouse_x.between?(162, 162 + 176) && mouse_y.between?(629, 629 + 13)
			@is_dragging_volume = true
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
		draw_credit()
	end

 	def needs_cursor?; true; end

	def update

		case @screen_type
		when ScreenType::TRACKS
			# Handle the song
			album = @albums[@selected_album]
			if @change_track
				if @song != nil
					@song.stop
				end
				@song = Gosu::Song.new(album.tracks[@selected_track].location)
				@song.play(false)
				@change_track = false
			end

			if (not @song.playing?) and (not @manual_pause)
				@selected_track = (@selected_track + 1) % album.tracks.length
				@change_track = true
			end

			if @mute
				@song.volume = 0
			else
				@song.volume = @volume
			end

			# Handle the volume bar
			if @is_dragging_volume
				if mouse_x < 162
					@volume = 0
				elsif mouse_x > 338
					@volume = 1.0
				else
					@volume = (mouse_x - 162) / 176.0
				end
				@mute = false
			end
		end
	end

	def button_down(id)
		case id
	    when Gosu::MsLeft
			case @screen_type
			when ScreenType::ALBUMS
				handle_mouse_albums_screen(mouse_x, mouse_y)
			when ScreenType::TRACKS
				handle_mouse_tracks_screen(mouse_x, mouse_y)
			end
	    end
	end

	def button_up(id)
		case id
	    when Gosu::MsLeft
			@is_dragging_volume = false
	    end
	end
end

MusicPlayerMain.new.show if __FILE__ == $0