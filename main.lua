--love2d.org--

function love.load() 
    target = {}
    target.x = 100
    target.y = 100
    target.radius = 50

    score = 0
    timer = 0

    gameState = 1

    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')
end

function love.update(dt)
    if timer > 0 and gameState == 2 then
        timer = timer - dt
    end
    
    if timer < 0 then
        timer = 0
        gameState = 1
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, 5, 5)
    love.graphics.printf("Time: " .. math.ceil(timer), 0, 5, love.graphics.getWidth()-5, "right")

    if gameState == 1 then
        love.graphics.printf("Click to start", 0, 250, love.graphics.getWidth(), "center")
    end

    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)

    love.mouse.setVisible(false)
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and gameState == 2 then
        local mouseToTarget = distBetween(x,y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 1
            setNewTargetPosition()
        else 
            score = math.max(0, score - 1)
        end
    end

    if button == 2 and gameState == 2 then 
        local mouseToTarget = distBetween(x,y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 2
            timer = timer - 1
            setNewTargetPosition()
        else 
            score = math.max(0, score - 2)
            timer = timer - 1
        end
    end
        
    if gameState == 1 then 
        gameState = 2
        score = 0
        timer = 10
    end
end

function setNewTargetPosition() 
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end

function distBetween( x1, y1, x2, y2 )
   a = (x2 - x1)^2
   b = (y2 - y1)^2 
   return math.sqrt(a + b)
end