
# put the genre names array here:
$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

def main()
    for i in 1..4 do
        puts(i.to_s() + " " + $genre_names[i])
    end
end

main()
