require_relative 'yacht'

def main()
    yacht = Yatch.new()
    yacht.name = "Omen"
    yacht.hull = Hull::Round
    yacht.construction = "wood"
    yacht.rig = Rig::Gaff

    puts yacht.name
    puts Hull_names[yacht.hull]
    puts yacht.construction
    puts Rig_names[yacht.rig]
end

main()