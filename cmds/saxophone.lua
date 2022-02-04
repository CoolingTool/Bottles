local e = tles.emoji.index

local list = {
    'monkey', 'bird', 'baby_chick',
    'duck', 'dodo', 'eagle', 'bug',
    'snail', 'ant', 'cricket', 'snake',
    'lizard', 'shrimp', 'blowfish',
    'seal', 'dolphin', 'shark', 'bison',
    'dromedary_camel', 'camel', 'giraffe',
    'kangaroo', 'water_buffalo', 'ox',
    'cow2', 'racehorse', 'pig2', 'ram',
    'llama', 'goat', 'dog2', 'poodle',
    'guide_dog', 'service_dog', 'cat2'
}

return function(message)
    message:reply(e.saxophone..e[list[math.random(#list)]])
end