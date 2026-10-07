local love = require("love")
function love.conf(t)
    t.window.title = "Mon jeu"
    t.window.width = 800
    t.window.height = 600
    t.window.msaa = 4   -- anticrénelage : 0 (désactivé), 2, 4 ou 8
end