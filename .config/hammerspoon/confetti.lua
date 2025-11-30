-- Hammerspoon Confetti Animation
-- Press Cmd+Shift+C to trigger confetti!

confetti = {}

-- Configuration
local config = {
    particleCount = 200,
    colors = {
        {red = 1.0, green = 0.2, blue = 0.2, alpha = 0.95},  -- Red
        {red = 0.2, green = 0.5, blue = 1.0, alpha = 0.95},  -- Blue
        {red = 1.0, green = 0.8, blue = 0.2, alpha = 0.95},  -- Yellow
        {red = 0.3, green = 0.9, blue = 0.3, alpha = 0.95},  -- Green
        {red = 1.0, green = 0.4, blue = 0.8, alpha = 0.95},  -- Pink
        {red = 0.6, green = 0.3, blue = 0.9, alpha = 0.95},  -- Purple
        {red = 1.0, green = 0.6, blue = 0.2, alpha = 0.95},  -- Orange
    },
    gravity = 0.6,
    windVariance = 0.2,
    duration = 5.0,  -- seconds
    particleSize = {min = 10, max = 20},
}

-- Particle system
local particles = {}
local canvas = nil
local animationTimer = nil

-- Helper function to get random number in range
local function randomRange(min, max)
    return min + math.random() * (max - min)
end

-- Create a single particle
local function createParticle(screenFrame)
    local startX = randomRange(screenFrame.w * 0.2, screenFrame.w * 0.8)
    local startY = -20
    
    return {
        x = startX,
        y = startY,
        velocityX = randomRange(-18, 18),
        velocityY = randomRange(-12, 8),
        rotation = randomRange(0, 360),
        rotationSpeed = randomRange(-20, 20),
        size = randomRange(config.particleSize.min, config.particleSize.max),
        color = config.colors[math.random(#config.colors)],
        life = 1.0,
        shape = math.random(1, 3),  -- 1: circle, 2: square, 3: triangle
    }
end

-- Draw a single particle element
local function createParticleElement(particle, index)
    local alpha = particle.color.alpha * particle.life
    
    if particle.shape == 1 then
        -- Circle
        return {
            id = "particle_" .. index,
            type = "circle",
            center = {x = particle.x, y = particle.y},
            radius = particle.size / 2,
            fillColor = {
                red = particle.color.red,
                green = particle.color.green,
                blue = particle.color.blue,
                alpha = alpha
            },
            strokeColor = {alpha = 0},
        }
    elseif particle.shape == 2 then
        -- Rectangle with rotation
        return {
            id = "particle_" .. index,
            type = "rectangle",
            frame = {
                x = particle.x - particle.size/2,
                y = particle.y - particle.size/2,
                w = particle.size,
                h = particle.size
            },
            fillColor = {
                red = particle.color.red,
                green = particle.color.green,
                blue = particle.color.blue,
                alpha = alpha
            },
            strokeColor = {alpha = 0},
            transformation = hs.canvas.matrix.translate(particle.x, particle.y)
                :rotate(math.rad(particle.rotation))
                :translate(-particle.x, -particle.y),
        }
    else
        -- Triangle
        local halfSize = particle.size / 2
        return {
            id = "particle_" .. index,
            type = "segments",
            closed = true,
            coordinates = {
                {x = particle.x, y = particle.y - halfSize},
                {x = particle.x + halfSize, y = particle.y + halfSize},
                {x = particle.x - halfSize, y = particle.y + halfSize},
            },
            fillColor = {
                red = particle.color.red,
                green = particle.color.green,
                blue = particle.color.blue,
                alpha = alpha
            },
            strokeColor = {alpha = 0},
            transformation = hs.canvas.matrix.translate(particle.x, particle.y)
                :rotate(math.rad(particle.rotation))
                :translate(-particle.x, -particle.y),
        }
    end
end

-- Initialize confetti
function confetti.start()
    -- Clean up any existing animation
    confetti.stop()
    
    -- Get main screen frame
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()
    
    -- Create particles
    particles = {}
    for i = 1, config.particleCount do
        particles[i] = createParticle(screenFrame)
    end
    
    -- Create single canvas for all particles
    canvas = hs.canvas.new({
        x = screenFrame.x,
        y = screenFrame.y,
        w = screenFrame.w,
        h = screenFrame.h
    })
    canvas:level(hs.canvas.windowLevels.overlay)
    canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
    canvas:clickActivating(false)
    
    -- Initialize canvas with all particle elements
    local initialElements = {}
    for i = 1, config.particleCount do
        table.insert(initialElements, createParticleElement(particles[i], i))
    end
    canvas:replaceElements(initialElements)
    canvas:show()
    
    -- Start animation timer (60 FPS)
    local startTime = hs.timer.secondsSinceEpoch()
    animationTimer = hs.timer.doEvery(1/60, function()
        local elapsed = hs.timer.secondsSinceEpoch() - startTime
        
        if elapsed > config.duration then
            confetti.stop()
            return
        end
        
        -- Update each particle and its canvas element in place
        for i, particle in ipairs(particles) do
            -- Physics update
            particle.velocityY = particle.velocityY + config.gravity
            particle.velocityX = particle.velocityX + randomRange(-config.windVariance, config.windVariance) * 0.5
            
            particle.x = particle.x + particle.velocityX
            particle.y = particle.y + particle.velocityY
            particle.rotation = particle.rotation + particle.rotationSpeed
            
            -- Fade out based on time
            particle.life = 1.0 - (elapsed / config.duration)
            
            -- Update the canvas element directly by index
            local alpha = particle.color.alpha * particle.life
            
            if particle.shape == 1 then
                -- Circle - update position and alpha
                canvas[i].center = {x = particle.x, y = particle.y}
                canvas[i].fillColor.alpha = alpha
            elseif particle.shape == 2 then
                -- Rectangle - update position, rotation, and alpha
                canvas[i].frame = {
                    x = particle.x - particle.size/2,
                    y = particle.y - particle.size/2,
                    w = particle.size,
                    h = particle.size
                }
                canvas[i].transformation = hs.canvas.matrix.translate(particle.x, particle.y)
                    :rotate(math.rad(particle.rotation))
                    :translate(-particle.x, -particle.y)
                canvas[i].fillColor.alpha = alpha
            else
                -- Triangle - update coordinates, rotation, and alpha
                local halfSize = particle.size / 2
                canvas[i].coordinates = {
                    {x = particle.x, y = particle.y - halfSize},
                    {x = particle.x + halfSize, y = particle.y + halfSize},
                    {x = particle.x - halfSize, y = particle.y + halfSize},
                }
                canvas[i].transformation = hs.canvas.matrix.translate(particle.x, particle.y)
                    :rotate(math.rad(particle.rotation))
                    :translate(-particle.x, -particle.y)
                canvas[i].fillColor.alpha = alpha
            end
        end
    end)
end

-- Stop animation and clean up
function confetti.stop()
    if animationTimer then
        animationTimer:stop()
        animationTimer = nil
    end
    
    if canvas then
        canvas:delete()
        canvas = nil
    end
    
    particles = {}
end

return confetti


--
-- -- Bind hotkey (Cmd+Shift+C)
-- hs.hotkey.bind({"cmd", "shift"}, "C", function()
--     confetti.start()
-- end)
--
-- -- Show notification on load
-- hs.notify.new({
--     title = "Confetti Loaded!",
--     informativeText = "Press Cmd+Shift+C to celebrate! 🎉"
-- }):send()
--
-- print("Confetti animation loaded! Press Cmd+Shift+C to trigger.")
