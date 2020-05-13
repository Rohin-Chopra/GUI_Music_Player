require 'rubygems'
require 'gosu'
require 'audioinfo'
$GENRE_NAMES = %w[Null Pop Classic Jazz Rock]
TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

# Defines the Zorder for the gosu
module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

# Defines the Genre for the gosu
module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

# Defines the Genre for the gosu
class Track
  attr_accessor :name, :location, :track_key

  def initialize(name, location, track_key)
    @name = name
    @location = location
    @track_key = track_key
  end
end
# This is a class for an album
class Album
  attr_accessor :title, :artist, :genre, :tracks, :key, :artfile

  def initialize(title, artist, genre, tracks, key, artfile)
    @title = title
    @artist = artist
    @genre = genre
    @tracks = tracks
    @key = key
    @artfile = artfile
  end
end

# This is a class for an album
class ArtWork
  attr_accessor :bmp

  def initialize(file)
    @bmp = Gosu::Image.new(file)
  end
end

# Put your record definitions here
class MusicPlayerMain < Gosu::Window
  def initialize
    super 1000, 600
    self.caption = 'Music Player'
    music_file = File.new('file.txt', 'r')
    albums = read_albums(music_file)
    @albums = albums
    @track_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @image_color = Gosu::Color.new(0xffffffff )

    @choice = 3
    # Reads in an array of albums from a file
  end

  def read_albums(file)
    @album_key = 1
    number_of_albums = file.gets.to_i
    albums = []
    i = 0
    while i < number_of_albums
      albums << read_album(file)
      i += 1
      @album_key += 1
    end
    albums
  end

  def read_album(file)
    album_title = file.gets
    album_artist = file.gets
    album_genre = file.gets
    get_album_artfile = file.gets.chomp
    album_artfile = ArtWork.new(get_album_artfile)
    album_tracks = read_tracks(file)
    album_kay = @album_key
    album = Album.new(album_title, album_artist, album_genre, album_tracks, album_kay, album_artfile) 
    album
  end

  def read_tracks(file)
    @index_track_key = 1
    @count = file.gets.to_i
    tracks = []
    i = 0
    while i < @count
      track = read_track(file)
      tracks << track
      i += 1
      @index_track_key+=1
    end
    return tracks
  end

  # reads in a single track from the given file.
  def read_track(file)
    name = file.gets
    location = file.gets
    track_kay = @index_track_key
    Track.new(name, location, track_kay)
  end
  # Draws the artwork on the screen for all the albums

  def draw_albums(albums)
    if albums.length == 1
      albums[0].artfile.bmp.draw_as_quad(50, 100, @image_color, 250, 100, @image_color, 50, 300, @image_color, 250, 300, @image_color,ZOrder::UI)
    elsif albums.length == 2
      albums[0].artfile.bmp.draw_as_quad(50, 100, @image_color, 250, 100, @image_color, 50, 300, @image_color, 250, 300, @image_color,ZOrder::UI)
      albums[1].artfile.bmp.draw_as_quad(270, 100, @image_color, 470, 100, @image_color, 270, 300, @image_color, 470, 300, @image_color, ZOrder::UI)
    elsif albums.length == 3
      albums[0].artfile.bmp.draw_as_quad(50, 100, @image_color, 250, 100, @image_color, 50, 300, @image_color, 250, 300, @image_color,ZOrder::UI)
      albums[1].artfile.bmp.draw_as_quad(270, 100, @image_color, 470, 100, @image_color, 270, 300, @image_color, 470, 300, @image_color, ZOrder::UI)
      albums[2].artfile.bmp.draw_as_quad(50, 350, @image_color, 250, 350, @image_color, 50, 550, @image_color, 250, 550, @image_color, ZOrder::UI)
    elsif albums.length == 4
      albums[0].artfile.bmp.draw_as_quad(50, 100, @image_color, 250, 100, @image_color, 50, 300, @image_color, 250, 300, @image_color,ZOrder::UI)
      albums[1].artfile.bmp.draw_as_quad(270, 100, @image_color, 470, 100, @image_color, 270, 300, @image_color, 470, 300, @image_color, ZOrder::UI)
      albums[2].artfile.bmp.draw_as_quad(50, 350, @image_color, 250, 350, @image_color, 50, 550, @image_color, 250, 550, @image_color, ZOrder::UI)
      albums[3].artfile.bmp.draw_as_quad(270, 350, @image_color, 470, 350, @image_color, 270, 550, @image_color, 470, 550, @image_color, ZOrder::UI)
    end
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
    if @albums.length == 1
      if leftX > 50 and topY > 100 and rightX < 250 and bottomY < 300
        message = 'Album1'
      end
    elsif @albums.length == 2
      if ((leftX > 50 and rightX < 250) and (topY > 100 and bottomY < 300))
        message = 'Album1'
      elsif((leftX > 270 and rightX < 470) and (topY > 100 and bottomY < 300))
        message = 'Album2'
      end  
    elsif @albums.length == 3
      if ((leftX > 50 and rightX < 250) and (topY > 100 and bottomY < 300))
        message = 'Album1'
      elsif((leftX > 270 and rightX < 470) and (topY > 100 and bottomY < 300))
        message = 'Album2'  
      elsif ((leftX > 50 and rightX < 250) and (topY > 350 and bottomY < 550))
        message = 'Album3'
      end  
    elsif @albums.length == 4
      if ((leftX > 50 and rightX < 250) and (topY > 100 and bottomY < 300))
        message = 'Album1'
      elsif((leftX > 270 and rightX < 470) and (topY > 100 and bottomY < 300))
        message = 'Album2'  
      elsif ((leftX > 50 and rightX < 250) and (topY > 350 and bottomY < 550))
        message = 'Album3'
      elsif((leftX > 270 and rightX < 470) and (topY > 350 and bottomY < 550))
        message = 'Album4'
      end  
    end
    return message  
  end

  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos)
    #TrackLeftX
    @track_font.draw(title,700 , ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::WHITE)
  end
  def display_tracks()
    i = 0
    x = 0
    ypos = 30
      while x < @albums[@choice].tracks.length
        display_track(@albums[@choice].tracks[x].name, ypos)
        ypos += 35
        x += 1
      end  
  end  
  # Takes a track index and an Album and plays the Track from the Album
 
  def play_track(track, album)
      @song = Gosu::Song.new(album.tracks[track].location.chomp)
      @song.play(false)
  end


  # Draw a coloured background using TOP_COLOR and BOTTOM_/COLOR

  def draw_background
    Gosu.draw_rect(0, 0, 1000, 600, Gosu::Color::BLACK, ZOrder::BACKGROUND, mode = :default)
  end

  # Not used? Everything depends on mouse actions.

  def update
  end

  def draw_buttons
    
  end  
  # Draws the album images and the track list for the selected album

  def draw
    draw_background()
    draw_albums(@albums)
    display_tracks()
  end

  def needs_cursor?
    true
  end

  # If the button area (rectangle) has been clicked on change the background color
  # also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
  # you will learn about inheritance in the OOP unit - for now just accept that
  # these are available and filled with the latest x and y locations of the mouse click.

  def button_down(id)
    result  = area_clicked(mouse_x, mouse_y, mouse_x, mouse_y)
    case id
    when Gosu::MsLeft
      if result == 'Album1'
        @choice = 0
        play_track(0, @albums[@choice])
      elsif result == 'Album2'
        @choice = 1
        play_track(0, @albums[@choice])
      elsif result == 'Album3'
        @choice = 2
        play_track(0, @albums[@choice])
      elsif result == 'Album4'
        @choice = 3      
        play_track(0, @albums[@choice])
      end
    end
  end
end
# Show is a method that loops through update and draw

MusicPlayerMain.new.show 
