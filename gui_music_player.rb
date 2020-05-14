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
    @image_color = Gosu::Color.new(0xffffffff)
    @info_font = Gosu::Font.new(20)
    @background1 = Gosu::Color.new(0xff181818)

    @background = Gosu::Color.new(0xff181818)
    @background3 = Gosu::Color.new(0xff282828)
    @choice = 0
    @track_result = 0
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
    i = 0
    x1 = 50
    y1 = 100
    x2 = 250
    y2 = 300
    while i < albums.length
      if i == 1
        x1 += 220
        x2 += 220
      elsif i == 2
        x1 = 50
        x2 = 250
        y1 += 220
        y2 += 220
      elsif i==3
        x1+=220
        x2+=220
      end 
      albums[i].artfile.bmp.draw_as_quad(x1, y1, @image_color, x2, y1, @image_color, x1, y2, @image_color, x2, y2, @image_color,ZOrder::UI)
      i+=1
    end
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

 
  def area_clicked(leftX, topY, rightX, bottomY)
    if @albums.length == 1
      if leftX > 50 and topY > 100 and rightX < 250 and bottomY < 300
        @choice = 1
      end
    elsif @albums.length == 2
      if ((leftX > 50 and rightX < 250) and (topY > 100 and bottomY < 300))
        @choice = 0
      elsif((leftX > 270 and rightX < 470) and (topY > 100 and bottomY < 300))
        @choice = 1
      end  
    elsif @albums.length == 3
      if ((leftX > 50 and rightX < 250) and (topY > 100 and bottomY < 300))
        @choice = 0
      elsif((leftX > 270 and rightX < 470) and (topY > 100 and bottomY < 300))
        @choice = 1
      elsif ((leftX > 50 and rightX < 250) and (topY > 350 and bottomY < 520))
        @choice = 2
      end  
    elsif @albums.length == 4
      if ((leftX > 50 and rightX < 250) and (topY > 100 and bottomY < 300))
        @choice = 0
      elsif((leftX > 270 and rightX < 470) and (topY > 100 and bottomY < 300))
        @choice = 1
      elsif ((leftX > 50 and rightX < 250) and (topY > 350 and bottomY < 520))
        @choice = 2
      elsif((leftX > 270 and rightX < 470) and (topY > 350 and bottomY < 520))
        @choice = 3
      end  
    end
    return @choice
  end

  def track_area_clicked(leftX, topY, rightX, bottomY)
    i = 0
    x1 = 690
    x2 = 1000
    y1 = 0
    y2 = 40
    while i < @albums[@choice].tracks.length
        if((leftX > x1) and (topY > y1) and (rightX < x2) and (bottomY < y2))
          return i.to_i
        end
        y1+=35
        y2+=35
        i+=1
      end
  end  
 
  def draw_btns()
    play = Gosu::Image.new('images/last.png')
    play.draw(160 , 530, ZOrder::UI)
  end  
  def btn_click(x1,x2,y1,y2)
    if((x1 > 200 and x2 < 235 ) and (y1 > 530 and y2 < 574))
      @song.play
    end
    if((x1 > 274 and x2 < 328 ) and (y1 > 530 and y2 < 574))
      @song.pause
    end   
  end  
  # Takes a String title and an Integer ypos
  # You may want to use the following:cx
  def display_track(title, ypos)
    #TrackLeftX
    @track_font.draw(title,735 , ypos, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end
  def display_tracks()
    i = 0
    x = 0
    ypos = 12
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
    draw_line(690 ,0, Gosu::Color::RED, 690, 600, Gosu::Color::RED, ZOrder::PLAYER, mode=:default)#Person's torso
    Gosu.draw_rect(0, 0, 1000, 600, @background1 , ZOrder::BACKGROUND, mode = :default)
  end

  # Not used? Everything depends on mouse actions.

  def update
  end

  def draw_stuff()
    i = 0
    x1 = 0 
    x2 = 60
    while i < 15
      draw_quad(690,x1, @background ,1000,x1, @background ,690,x2,@background ,1000,x2, @background , ZOrder::PLAYER)#House
      x1+=35
      x2+=35
      draw_quad(690,x1, @background3 ,1000,x1, @background3 ,690,x2,@background3 ,1000,x2, @background3 , ZOrder::PLAYER)#House
      x1+=35
      x2+=35
      i+=1
    end  

  end  
  # Draws the album images and the track list for the selected album

  def draw
    unless @track_result.nil?
      draw_play()
    end  
    draw_btns()
    draw_stuff()
    draw_background()
    draw_albums(@albums)
    display_tracks()
    @info_font.draw("mouse_x: #{mouse_x}", 200, 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @info_font.draw("mouse_y: #{mouse_y}", 350, 50, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def needs_cursor?
    true
  end

  def draw_play()
    y1 = 10
    y2 = 30
    i = 0
    spam = @track_result
    spam+=1
    while i < @track_result
      y1 += 35
      y2 += 35
      i+=1
    end  
    mp = Gosu::Image.new('images/try.png')
    mp.draw_as_quad(695, y1, @image_color, 715, y1, @image_color, 695, y2, @image_color, 715, y2, @image_color,ZOrder::UI)
  end  

  def button_down(id)
    area_clicked(mouse_x, mouse_y, mouse_x, mouse_y)
    @track_result=track_area_clicked(mouse_x, mouse_y, mouse_x, mouse_y)
    btn_click(mouse_x, mouse_x, mouse_y, mouse_y)
    case id
    when Gosu::MsLeft
      unless (@track_result.nil?)
      play_track(@track_result, @albums[@choice])
      puts(@track_result)
      end
    end
  end
end
# Show is a method that loops through update and draw

MusicPlayerMain.new.show 
