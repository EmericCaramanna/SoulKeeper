require "piege"
require "conf"
require "game"
require "actor"

game = Game.new()

function love.load()
    -- Creates the main game var. Global.
end

function love.run()
    love.window.setTitle("Soul Keeper - GDP #4")
    -- The main function
    while game.state ~= GameState.QUITTING do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            -- computes the delta
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.graphics then
			love.graphics.clear()
			if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
			if love.draw then love.draw() end
		end

		-- don't consume 100% of cpu, sleep!
		if love.timer then love.timer.sleep(0.001) end
		if love.graphics then love.graphics.present() end
	end
end

function love.draw()
    game:draw()
    love.graphics.print(game.menu.str, 10, 200)
end

-- The main loop update which take care of updating
-- the entities.
function love.update(delta)
	game:update(delta)
end

function love.keypressed(key, unicode)
    -- quit on escape
    if key == 'f' then
        -- FIXME Causes problem with the background
            love.graphics.toggleFullscreen()
	    game.level:generateBackground()
	else
		game:keypressed(key, unicode)
	end
end

function love.mousereleased(x, y, button, isTouch)
	game:mousereleased(x, y, button)
end

