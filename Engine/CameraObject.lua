
game.newCameraObject = function( )
	local t = { }
	t.x, t.y = 1, 1
	t.w, t.y = 2, 2
	t.link = false
	t.majorType = "Camera"

	t.move = function( self, x, y )
		self.x, self.y = x, y
		if self.link then
			self.x, self.y = self.link.x, self.link.y
			self.w, self.h = self.link.w, self.link.h
		end
	end

	t.linkTo = function( self, link )
		if self.link then
			self.link.link = false
		end
		self.link = link
		if self.link then
			self.link.link = self
		end
	end

	t.render = function( self, map, entities )
		-- local canvas = love.graphics.newCanvas( )
		-- love.graphics.setCanvas( canvas )
		if self.link then
			self.x, self.y = self.link.x, self.link.y
			self.w, self.h = self.link.w, self.link.h
			self.map = self.link.map
			map = self.map
		end
		local w, h = self.map.blockCountX, self.map.blockCountY
		local cx, cy = love.graphics.getWidth( ) / 2, love.graphics.getHeight( ) / 2
		local xo, yo = self.x - cx + self.w / 2, self.y - cy + self.h / 2
		love.graphics.translate( -xo, -yo )
		for x = math.floor( self.x / self.map.blockSize - w/2 ), math.ceil( self.x / self.map.blockSize + w/2 ) + 2 do
			for y = math.floor( self.y / self.map.blockSize - h/2 ), math.ceil( self.y / self.map.blockSize + h/2 ) + 2 do
				if map.blocks[x] and map.blocks[x][y] then
					local lightlevel = map.blocks[x][y].light
					love.graphics.setColor( lightlevel * 17, lightlevel * 17, lightlevel * 17 )
					local rx, ry = map.blocks[x][y].block:getRealXY( )
					map.blocks[x][y].block:render( rx, ry, map )
					local damage = math.floor( ( map.blocks[x][y].block.damage / map.blocks[x][y].block.maxDamage ) * #game.data["Breaking Animation"] )
					if damage > 0 then
						local damage = damage > 10 and 10 or damage
						love.graphics.draw( game.data["Breaking Animation"][damage].image, rx, ry )
					end
				end
			end
		end
		for i = 1,#map.entities do
			map.entities[i]:render( )
		end
		love.graphics.translate( xo, yo )
		love.graphics.setColor( 255, 255, 255 )
		-- love.graphics.setCanvas( )
		-- love.graphics.draw( canvas )
	end
	
	t.renderCollisionMap = function( self, map, entities )
		if self.link then
			self.x, self.y = self.link.x, self.link.y
			self.w, self.h = self.link.w, self.link.h
			self.map = self.link.map
			map = self.map
		end
		local w, h = map.blockCountX, map.blockCountY
		local cx, cy = love.graphics.getWidth( ) / 2, love.graphics.getHeight( ) / 2
		local xo, yo = self.x - cx + self.w / 2, self.y - cy + self.h / 2
		love.graphics.translate( -xo, -yo )
		for x = math.floor( self.x / map.blockSize - w/2 ), math.ceil( self.x / map.blockSize + w/2 ) + 2 do
			for y = math.floor( self.y / map.blockSize - h/2 ), math.ceil( self.y / map.blockSize + h/2 ) + 2 do
				if map.blocks[x] and map.blocks[x][y] then
					map.blocks[x][y].block:renderCollisionMap( map.blocks[x][y].block:getRealXY( ) )
				end
			end
		end
		for i = 1,#map.entities do
			map.entities[i]:renderCollisionMap( )
		end
		love.graphics.translate( xo, yo )
	end
	
	t.getLeftClipping = function( self )
		if self.link then
			self.x, self.y = self.link.x, self.link.y
			self.w, self.h = self.link.w, self.link.h
			self.map = self.link.map
			map = self.map
		end
		return math.floor( ( self.x - love.graphics.getWidth( ) / 2 ) / self.map.blockSize )
	end
	
	t.getRightClipping = function( self )
		if self.link then
			self.x, self.y = self.link.x, self.link.y
			self.w, self.h = self.link.w, self.link.h
			self.map = self.link.map
			map = self.map
		end
		return math.ceil( ( self.x + love.graphics.getWidth( ) / 2 ) / self.map.blockSize ) + 1
	end
	
	t.getClickPosition = function( self, ox, oy )
		if self.link then
			self.x, self.y = self.link.x, self.link.y
			self.w, self.h = self.link.w, self.link.h
			self.map = self.link.map
			map = self.map
		end
		local cx, cy = love.graphics.getWidth( ) / 2, love.graphics.getHeight( ) / 2
		local x, y = self.x + ( ox - cx ) + self.w / 2, self.y + ( oy - cy ) + self.h / 2
		return math.floor( x / self.map.blockSize ), math.floor( y / self.map.blockSize ), ox + self.w / 2 < cx and "right" or "left", oy + self.h / 2 < cy and "up" or "down"
	end
	
	return t
end