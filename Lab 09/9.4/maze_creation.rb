require 'gosu'

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

MAP_WIDTH = 200
MAP_HEIGHT = 200
CELL_DIM = 20

class Cell
  # have a pointer to the neighbouring cells
  attr_accessor :north, :south, :east, :west, :vacant, :visited, :on_path

  def initialize()
    # Set the pointers to nil
    @north = nil
    @south = nil
    @east = nil
    @west = nil
    # record whether this cell is vacant
    # default is not vacant i.e is a wall.
    @vacant = false
    # this stops cycles - set when you travel through a cell
    @visited = false
    @on_path = false
  end
end

# Instructions:
# Left click on cells to create a maze with at least one path moving from
# left to right.  The right click on a cell for the program to find a path
# through the maze. When a path is found it will be displayed in red.
class GameWindow < Gosu::Window

  # initialize creates a window with a width an a height
  # and a caption. It also sets up any variables to be used.
  # This is procedure i.e the return value is 'undefined'
  def initialize
    super MAP_WIDTH, MAP_HEIGHT, false
    self.caption = "Map Creation"
    @path = nil

    x_cell_count = MAP_WIDTH / CELL_DIM
    y_cell_count = MAP_HEIGHT / CELL_DIM

    @columns = Array.new(x_cell_count)
    column_index = 0

    # first create cells for each position
    while (column_index < x_cell_count)
      row = Array.new(y_cell_count)
      @columns[column_index] = row
      row_index = 0
      while (row_index < y_cell_count)
        cell = Cell.new()
        @columns[column_index][row_index] = cell
        row_index += 1
      end
      column_index += 1
    end

    # now set up the neighbour links
    # You need to do this using a while loop with another
    # nested while loop inside.
    x = 0
    while (x < x_cell_count)
      y = 0
      while (y < y_cell_count)
        # North
        if y > 0
          @columns[x][y].north = @columns[x][y-1]
        end

        # South
        if y < y_cell_count - 1
          @columns[x][y].south = @columns[x][y+1]
        end

        # East
        if x < x_cell_count - 1
          @columns[x][y].east = @columns[x+1][y]
        end

        # West
        if x > 0
          @columns[x][y].west = @columns[x-1][y]
        end

        y += 1
      end
      x += 1
    end
  end

  # this is called by Gosu to see if should show the cursor (or mouse)
  def needs_cursor?
    true
  end

  # Returns an array of the cell x and y coordinates that were clicked on
  def mouse_over_cell(mouse_x, mouse_y)
    if mouse_x <= CELL_DIM
      cell_x = 0
    else
      cell_x = (mouse_x / CELL_DIM).to_i
    end

    if mouse_y <= CELL_DIM
      cell_y = 0
    else
      cell_y = (mouse_y / CELL_DIM).to_i
    end

    [cell_x, cell_y]
  end

  # start a recursive search for paths from the selected cell
  # it searches till it hits the East 'wall' then stops
  # it does not necessarily find the shortest path

  # Completing this function is NOT NECESSARY for the Maze Creation task
  # complete the following for the Maze Search task - after
  # we cover Recusion in the lectures.

  # But you DO need to complete it later for the Maze Search task
  def search(cell_x ,cell_y)

    if cell_x < 0 or cell_x >= (MAP_WIDTH / CELL_DIM) or cell_y < 0 or cell_y >= (MAP_HEIGHT / CELL_DIM)
      return nil
    end

    cell = @columns[cell_x][cell_y]
    if not cell.vacant or cell.visited
      return nil
    end

    dead_end = false
    path_found = false

    if (cell_x == ((MAP_WIDTH / CELL_DIM) - 1))
      if (ARGV.length > 0) # debug
        puts "End of one path x: " + cell_x.to_s + " y: " + cell_y.to_s
      end
      [[cell_x,cell_y]]  # We are at the east wall - exit
    else

      if (ARGV.length > 0) # debug
        puts "Searching. In cell x: " + cell_x.to_s + " y: " + cell_y.to_s
      end

      # INSERT MISSING CODE HERE!! You need to have 4 'if' tests to
      # check each surrounding cell. Make use of the attributes for
      # cells such as vacant, visited and on_path.
      # Cells on the outer boundaries will always have a nil on the
      # boundary side

      cell.visited = true
      directions = [[0,-1],[0,1],[1,0],[-1,0]]
      path = nil
      
      i = 0
      while i < directions.length
        next_x = cell_x + directions[i][0]
        next_y = cell_y + directions[i][1]
        next_path = search(next_x, next_y)
        if next_path != nil
          path = next_path
          break
        end
        i += 1
      end

      cell.visited = false
      # pick one of the possible paths that is not nil (if any):

      # A path was found:
      if (path != nil)
        if (ARGV.length > 0) # debug
          puts "Added x: " + cell_x.to_s + " y: " + cell_y.to_s
        end
        return [[cell_x,cell_y]].concat(path)
      else
        if (ARGV.length > 0) # debug
          puts "Dead end x: " + cell_x.to_s + " y: " + cell_y.to_s
        end
        return nil  # dead end
      end
    end
  end

  # Reacts to button press
  # left button marks a cell vacant
  # Right button starts a path search from the clicked cell
  def button_down(id)
    case id
      when Gosu::MsLeft
        cell = mouse_over_cell(mouse_x, mouse_y)
        if (ARGV.length > 0) # debug
          puts("Cell clicked on is x: " + cell[0].to_s + " y: " + cell[1].to_s)
        end
        @columns[cell[0]][cell[1]].vacant = true
      when Gosu::MsRight
        cell = mouse_over_cell(mouse_x, mouse_y)
        @path = search(cell[0],cell[1])
      end
  end

  # This will walk along the path setting the on_path for each cell
  # to true. Then draw checks this and displays them a red colour.
  def walk(path)
      index = path.length
      count = 0
      while (count < index)
        cell = path[count]
        @columns[cell[0]][cell[1]].on_path = true
        count += 1
      end
  end

  # Put any work you want done in update
  # This is a procedure i.e the return value is 'undefined'
  def update
    if (@path != nil)
      if (ARGV.length > 0) # debug
        puts "Displaying path"
        puts @path.to_s
      end
      walk(@path)
      @path = nil
    end
  end

  # Draw (or Redraw) the window
  # This is procedure i.e the return value is 'undefined'
  def draw
    index = 0
    x_loc = 0;
    y_loc = 0;

    x_cell_count = MAP_WIDTH / CELL_DIM
    y_cell_count = MAP_HEIGHT / CELL_DIM

    column_index = 0
    while (column_index < x_cell_count)
      row_index = 0
      while (row_index < y_cell_count)

        if (@columns[column_index][row_index].vacant)
          color = Gosu::Color::YELLOW
        else
          color = Gosu::Color::GREEN
        end
        if (@columns[column_index][row_index].on_path)
          color = Gosu::Color::RED
        end

        Gosu.draw_rect(column_index * CELL_DIM, row_index * CELL_DIM, CELL_DIM, CELL_DIM, color, ZOrder::TOP, mode=:default)

        row_index += 1
      end
      column_index += 1
    end
  end
end

window = GameWindow.new
window.show