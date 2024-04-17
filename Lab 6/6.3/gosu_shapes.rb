require 'rubygems'
require 'gosu'
require_relative './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  WIDTH = 640
  HEIGHT = 400

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "GOSU Simple Cup"
  end

  def draw
    draw_quad(0, 0, 0xff_ffffff, 640, 0, 0xff_ffffff, 0, 400, 0xff_ffffff, 640, 400, 0xff_ffffff, ZOrder::BACKGROUND)
    # Body
    body_width = 150
    body_length = 200
    body_x = (WIDTH - body_length) / 2
    body_y = (HEIGHT - body_width) / 2
    Gosu.draw_rect(body_x, body_y, body_length, body_width, Gosu::Color::CYAN, ZOrder::MIDDLE, mode=:default)

    # Handle outside
    handle_width = 100
    handle_length = 50
    handle_x = body_x + body_length
    handle_y = body_y + (body_width - handle_width) / 2
    Gosu.draw_rect(handle_x, handle_y, handle_length, handle_width, Gosu::Color::CYAN, ZOrder::MIDDLE, mode=:default)
    
    # Handle inside
    handle_inside_width = 60
    handle_inside_length = 30
    handle_inside_x = body_x + body_length
    handle_inside_y = body_y + (body_width - handle_inside_width) / 2
    Gosu.draw_rect(handle_inside_x, handle_inside_y, handle_inside_length, handle_inside_width, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)

    #Eyes
    eye1_x = body_x + 30
    eye1_y = body_y + 30
    circle_drawer = Gosu::Image.new(Circle.new(20))
    circle_drawer.draw(eye1_x, eye1_y, ZOrder::MIDDLE, 1.0, 1.0, Gosu::Color::BLACK)

    eye2_x = body_x + 130
    eye2_y = body_y + 30
    circle_drawer.draw(eye2_x, eye2_y, ZOrder::MIDDLE, 1.0, 1.0, Gosu::Color::BLACK)

    # Mouth
    mouth1_x = body_x + body_length / 2 - 20
    mouth1_y = body_y + 100

    mouth2_x = body_x + body_length / 2 + 20
    mouth2_y = body_y + 100

    mouth3_x = body_x + body_length / 2
    mouth3_y = body_y + 120
    draw_triangle(mouth1_x, mouth1_y, Gosu::Color::WHITE, mouth2_x, mouth2_y, Gosu::Color::WHITE, mouth3_x, mouth3_y, Gosu::Color::WHITE, ZOrder::MIDDLE)
  end
end

DemoWindow.new.show


