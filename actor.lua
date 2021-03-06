require "indian"
require "soul"
require "tourist"
require "utils"

--

ActorDrawables = {
    ["Indian"] = love.graphics.newImage("sprites/indian.png"),
    ["Soul"] = love.graphics.newImage("sprites/ghost.png"),
    ["Tourist"] = love.graphics.newImage("sprites/tourist.png"),
    ["Dead"] = love.graphics.newImage("sprites/dead.png"),
}

-- ---
-- Actors definition
-- ---

Actor = {
    -- class members
    visible = true,
    health = 1,
    area = 1,
    forceMoveX = 0, -- modified by a trap when the actor MUST move
    forceMoveY = 0, -- modified by a trap when the actor MUST move
    class = "Actor",

	lastUpdate = 0, -- time spend this the last update
	timeToUpdate = 0.25, -- time to wait between an update (different for each type of Actors)

	tourist_terror = 0, -- 	Know if the tourist is in terror

	action = nil,
	isBlocked = false,-- setting up wether the actor is able to move or not

    posX = 0,
    posY = 0,

    -- --------
    -- function shared with implentations
    -- --------
    draw = function(self)
        love.graphics.draw(game.actorDrawables[self.class], self.posX, self.posY)
    end,

    -- force the movement if a trap have ordered to
    forceTrapMovement = function(self)
        local dx = 0
        local dy = 0
        if self.forceMoveX ~= 0 then
            dx = self.forceMoveX/self.forceMoveX
            self.forceMoveX = self.forceMoveX - dx
        end
        if not game.level:isBlocking(self.posX+dx, self.posY) then
            self.posX = self.posX + dx 
        end

        if self.forceMoveY ~= 0 then
            dy = self.forceMoveY/self.forceMoveY
            self.forceMoveY = self.forceMoveY - dy
        end
        if not game.level:isBlocking(self.posX, self.posY+dy) then
            self.posY = self.posY + dy
        end
    end,

    contains = function(self, other)
        if math.abs(self.posX - other.posX)  < self.area then
            if math.abs(self.posY - other.posY) < self.area then
                return true
            end
        end
        return false
    end,

    touch = function(self, other)
        if math.abs(actor.posX - other.posX) < 1 then
            if math.abs(actor.posY - other.posY) < 1 then
                return true
            end
        end
        return false
    end,

    -- function to implements
    update = nil,
    move = nil,
    die = nil,
}

-- ---
-- Methods
-- ---

-- Constructor

function Actor.new(actorType)
    -- simple inheritance system
    local actor = deepcopy(Actor)

    if actorType.class ~= "Actor" then
        actor.class  = deepcopy(actorType.class)
        actor.update = deepcopy(actorType.update)
        actor.move = deepcopy(actorType.move)
        -- special case for Tourists
        if actorType.class == "Tourist" then
			actor.timeCaged = deepcopy(actorType.timeCaged)
            actor.afraid = deepcopy(actorType.afraid)
			actor.cage = actorType.cage
        elseif actorType.class == "Soul" or actorType.class == "Dead" then
            actor.health = deepcopy(actorType.health)
        end
        actor.action = deepcopy(actorType.action)
    end

    return actor
end
