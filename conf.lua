
game = { }
game.w = 720
game.h = 540
game.title = "Hello World"

function love.conf( t )
	t.screen.w = game.w
	t.screen.h = game.h
	t.title = game.title
end