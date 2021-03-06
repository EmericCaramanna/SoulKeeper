Gameplay = {
    seconds = 0,
    lastTime = 0,
	timeToWave = 5,
}

--

-- update the seconds
function Gameplay:update(delta)
    self:updateTime(delta)
    -- TODO vague must be configurable or read in the game state
    if self:timeToNextWave() <= 0 then
        self:newWave()
        self.seconds = 0
    end

    -- update every actors
	for k,person in ipairs(game.level.persons) do
        person:update(delta)
	end

	if game.level:getNumTypePerson("Indian") == 0 then
		--GAME OVER !!!
		print("GAME OVER !!")
		game.started = 0
		game.state = GameState.GAME_OVER
	end
end

function Gameplay:timeToNextWave()
	return math.ceil(self.timeToWave - self.seconds)
end

function Gameplay:updateTime(delta)
    local currentTime = love.timer.getTime()
    local delta = currentTime - self.lastTime
    if delta >= 1 then
        self.seconds = self.seconds + delta
        self.lastTime = currentTime
    end
end

function Gameplay:newWave()
    -- put tourists on the road
    local result = game.level:findRoad()
    tourist = Actor.new(Tourist)
    tourist.posX = result.findX
    tourist.posY = result.findY
    game.level:addPerson(tourist)      
end

-- Constructor
function Gameplay.new()
    local gameplay = Gameplay
    return gameplay
end

