
// Project: My First Game 
// Created by zMews (Gustavo Fagundes Vicente)

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "A Lenda de Fumiko - devolupted by zMews.ltda" )
SetWindowSize( 900, 700, 0 )
SetWindowAllowResize( 0 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 900, 700 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 60, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

//Variaveis a parte
tempo=0
placar=0
maiorplacar=0
increasespeed=10
fim=0

//Paralax
SetDefaultWrapU(1)

//Background
background= LoadImage("BG.jpg")
BG= CreateSprite(background)
SetPhysicsGravity(0,300)

//Sprite do Chão/parede (para a personagem não cair ou virar)
	
createsprite(1,0)
createsprite(2,0)
setspritesize(1,1000,25)
setspritesize(2,10,100)
SetSpriteColor(1,255,255,255,0)
SetSpriteColor(2,255,255,255,0)
SetSpritePosition(1,0,640)
SetSpritePosition(2,65,550)
SetSpritePhysicsOn(1,1)
SetSpritePhysicsOn(2,1)

//Sprites da Fumiko (Main Character)
createsprite(3,0)
AddSpriteAnimationFrame (3,LoadImage("Fumiko05.png"))
AddSpriteAnimationFrame (3,LoadImage("Fumiko06.png"))
AddSpriteAnimationFrame (3,LoadImage("Fumiko07.png"))

//Movimentação da Fumiko (Main Character)
playsprite(3,7,1,1,3)
SetSpriteSize(3,60,90)
SetSpritePosition(3,0,550)
SetSpritePhysicsOn(3,2)

//Sprites dos Monstros
createsprite(5,0)
createsprite(6,0)
AddSpriteAnimationFrame (5,loadimage("bee.png"))
AddSpriteAnimationFrame (5,loadimage("bee_fly.png"))
AddSpriteAnimationFrame (6,loadimage("ladyBug.png"))
AddSpriteAnimationFrame (6,LoadImage("ladyBug_fly.png"))

//Movimentação da Abelha 1
speedabelha=-150
PlaySprite(5,5,1,1,3)
setspritesize(5,45,45)
SetSpritePosition(5,1000,500)
SetSpritePhysicsOn(5,3)
SetSpritePhysicsVelocity(5,speedabelha,0)

//Movimentação da Joaninha 1
speedjoaninha=-150
PlaySprite(6,5,1,1,3)
setspritesize(6,30,30)
SetSpritePosition(6,700,620)
SetSpritePhysicsOn(6,3)

//Play/Exit
createsprite(7,0)
createsprite(8,0)
AddSpriteAnimationFrame(7,LoadImage("play.jpg"))
AddSpriteAnimationFrame(8,LoadImage("exit.jpg"))
SetSpritePosition(7,325,250)
SetSpritePosition(8,330,350)
SetSpriteColorAlpha(7,255)
SetSpriteColorAlpha(8,255)

//música
LoadSound(1,"jump.wav")
LoadSound(2,"queda.wav")
LoadSound(3,"death.wav")
LoadMusic(5,"Sakkijarven-polkka.wav")
PlayMusic(5,1)
SetMusicFileVolume(5,10)

do
	
	//Prints
	print("Score:")
	print(placar)
	print("High Score:")
	print(maiorplacar)
	tempo= tempo + 1
	
	//Aumentar velocidade
	if placar = increasespeed
		speedjoaninha = speedjoaninha - 20
		speedabelha = speedabelha - 20
		increasespeed = increasespeed + 5
	endif
	
	if GetSpriteCollision(3,5) or GetSpriteCollision(3,6)
		
		PlaySound(3,80,0,0)
		speedjoaninha=0
		speedabelha=0
		increasespeed=10
		SetSpritePosition(3,0,550)
		SetSpritePosition(5,0,1000)
		SetSpritePosition(6,0,1000)
		StopSprite(5)
		StopSprite(6)
		
		// Start/Exit
		SetSpriteColorAlpha(7,255)
		SetSpriteColorAlpha(8,255)
		fim=0
		if placar>maiorplacar
		maiorplacar=placar
		endif
	endif
		
	if fim=0
		print("")
		print("                                         Pressione setinha para cima para pular")
		print("                                         Pressione setinha para baixo para cair")
		SetSpritePosition(5,0,1000)
		SetSpritePosition(6,0,1000)
		xscroll#=xscroll#+.002
		setspriteuvoffset(BG,xscroll#,0)
		if GetRawMouseLeftPressed()
			if GetSpriteHitTest(7,GetPointerX(),GetPointerY())
				playsprite(3,7,1,1,3)
				PlaySprite(5,5,1,1,3)
				PlaySprite(6,5,1,1,3)
				SetSpritePosition(5,1000,500)
				SetSpritePosition(6,600,620)
				placar=0
				tempo=0
				speedabelha= -150
				speedjoaninha= -150
				SetSpriteColorAlpha(7,0)
				SetSpriteColorAlpha(8,0)
				SetPhysicsGravity(0,300)
				fim=1
				
			elseif GetSpriteHitTest(8,GetPointerX(),GetPointerY())
				end
			endif
		endif
		else
			//background se mover
			xscroll#=xscroll#+.002
			setspriteuvoffset(BG,xscroll#,0)
			
			//placar
			if tempo=60
    		tempo=0
			placar= placar + 1
			endif
			
		//pulo da Fumiko (Main Character)
		if GetRawKeyPressed(38) and GetSpriteCollision(3,1)
			PlaySound(1,80,0,0)
			SetSpritePhysicsVelocity(3,0,-200)
		endif
	
		//Queda da Fumiko (Main Character)
		if GetRawKeyPressed(40)
			PlaySound(2,80,0,0)
			SetSpritePhysicsVelocity(3,0,200)
		endif
	
		//Velocidade dos monstros
		SetSpritePhysicsVelocity(5,speedabelha,0)
		SetSpritePhysicsVelocity(6,speedjoaninha,0)
		
		//Respawn dos monstros
		if GetSpriteX(6) < 0 and GetSpriteX(5) < 0
			tipodemonstro= Random (5,6)
			if tipodemonstro=5
				SetSpritePosition(5,1000,500)
			endif
			if tipodemonstro=6
				SetSpritePosition(6,800,620)
			endif
		endif
	endif
	
    Sync()
loop
