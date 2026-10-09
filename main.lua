local love = require("love")
-- Colors
local background_color = {0.1, 0.2, 0.3}
local player_color = {1, 0.8, 0.2}
local coin_color = {1, 1, 0}

-- Game objects
local player
local coin
local score
local font

-- Helpers
local function normalize(v)
    local len = math.sqrt(v.x^2 + v.y^2)
    if len > 0 then
        v.x = v.x / len
        v.y = v.y / len
    end
end

-- Update functions
local function move(dt)
    -- Reset direction
    player.dir.x = 0
    player.dir.y = 0

    -- input to direction vector
    if love.keyboard.isDown('right', 'd') then player.dir.x = player.dir.x + 1 end
    if love.keyboard.isDown('left', 'q')  then player.dir.x = player.dir.x - 1 end
    if love.keyboard.isDown('down', 's')  then player.dir.y = player.dir.y + 1 end
    if love.keyboard.isDown('up', 'z')    then player.dir.y = player.dir.y - 1 end
    
    normalize(player.dir)

    -- Set velocity
    player.velocity.x = player.velocity.x + (player.dir.x * player.speed * dt)
    player.velocity.y = player.velocity.y + (player.dir.y * player.speed * dt)

    -- set friction
    local friction = 0.95

    player.velocity.x = player.velocity.x * friction
    player.velocity.y = player.velocity.y * friction
    -- Apply velocity
    player.x = player.x + player.velocity.x
    player.y = player.y + player.velocity.y
end

local function keep_in_bounds()
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()

    if player.x - player.radius < 0 then
        player.x = player.radius
    elseif player.x + player.radius > screen_width then
        player.x = screen_width - player.radius
    end

    if player.y - player.radius < 0 then
        player.y = player.radius
    elseif player.y + player.radius > screen_height then
        player.y = screen_height - player.radius
    end
end

local function check_coin_collision()
    -- touch ?
    local dx = player.x - coin.x
    local dy = player.y - coin.y
    local distance = math.sqrt(dx^2 + dy^2)

    if distance < player.radius + coin.radius then
        -- move coin to random position
        coin.x = math.random(coin.radius, love.graphics.getWidth() - coin.radius)
        coin.y = math.random(coin.radius, love.graphics.getHeight() - coin.radius)
        -- add score
        score = score + 1
    end
end





-- LÖVE callbacks
function love.load()
    score = 0
    
    font = love.graphics.newFont("fonts/JetBrainsMono-Regular.ttf", 24)
    love.graphics.setLineStyle("smooth")

    --musics
    local intro_sound = love.audio.newSource("assets/sound_effects/intro.mp3", "static")
    intro_sound:play()
    
    local bg_music = love.audio.newSource("assets/music/time_for_adventure.mp3", "static")
    bg_music:setLooping(true)
    bg_music:play()

    
    
    player = {
        x = 100,
        y = 100,
        radius = 25,
        speed = 60,
        velocity = { x = 0, y = 0 },
        dir = { x = 0, y = 0 }
    }

    coin = {
        x = 300,
        y = 200,
        radius = 10
    }
end

function love.update(dt)
    move(dt)
    keep_in_bounds()
    check_coin_collision()
end

function love.draw()
    love.graphics.setBackgroundColor(background_color)

    -- player
    love.graphics.setColor(player_color)
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- coin
    love.graphics.setColor(coin_color)
    love.graphics.circle("fill", coin.x, coin.y, coin.radius)

    -- score
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.print("Score: " .. score, 20, 20)
end