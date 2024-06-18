function love.load()
    love.window.setTitle("Flocking Boids")
    love.window.setMode(1920, 1080, {})
end

function love.draw()
    love.graphics.rectangle("fill", 100, 200, 50, 80)
end
