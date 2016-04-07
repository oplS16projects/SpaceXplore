# Project Title: SpaceXplore

### Statement
We're designing a 2D space shooting game that uses graphics and sound to make it fun and interesting. The user will be able to control a spaceship and the purpose of the game is to avoid the obstacles that are ahead. 

### Analysis
To allow the user to move the spacecraft anywhere on the screen we will use cons, car and cdr. Use FoldL for handling situations when the health of the spacecraft is low or when the the spacecraft hits an object. Use recusion to create multiple obstacles. We will use inheritance and map .....................


### Data set or other source materials
We will be building our own simulation and creating our own data. We will however be using 2D sprits from randowm websites for our game.


### Deliverable and Demonstration
In the end we will have a fully funtional interactive game that will allow the user to contol the spacecraft and move around obstacles. The obstacles will be random so the user will not know where to move the spacecraft. 




### Evaluation of Results
The game should play through with the described gameplay without errors until the player reaches 0 health.


How will you know if you are successful? 

We will know if we are successful if a user is able to play the game smoothly without any errors and be able to enjoy it.

## Architecture Diagram
![finalprojdesign](https://cloud.githubusercontent.com/assets/12664198/14360127/db9d94c8-fcc2-11e5-849c-176db2a35bc4.jpg)

The way the game will work is the user will start the game and the program will then generate a random objects at random X and Y positions off-screen. These objects will vary is size and trajectrory. The player will have to either move around or shoot the objects to avoid getting hit. The spacecraft that the user controls will have a health bar so after a certain amount of hits the game will end.

The game runs in a loop.  Every 1/28 seconds (default of 2htdp/Universe) the game updates the positions of the objects based on time and velocity, updates the player position based on input, checks for collisions, and then renders a new frame.  This continues until the player's health gets to 0.

The game objects are a hierarchy of entity objects.  Each entity has a position, sprite, and flag for death (whether or not to render the sprite or check it's coordinates).  Every other object in the game will inherit from this class.  The game loop knows how to render each object based on it's members it inherits from the entity class.

## Schedule
### First Milestone (Fri Apr 15)
A 2D world that accepts input to move a spaceship sprite around the screen.  This signifies the core engine is complete and our concept works. 

### Second Milestone (Fri Apr 22)
Add features like health, sound, obstacles.  Fleshing out the features of the game, at this point we should have solid gameplay.

### Final Presentation (last week of semester)
Add more interactive things. Start page/intro.

## Group Responsibilities

### Lokesh Manchi @lokeshmanchi
I will write the code that allows the user to move the spacecraft freely to avoid the obsticles and write code for sound.
For the first milestone I will create the code for allowing the user to move the spacecraft.
For the second milestone I will write code for the sound to make the game more immersive and create the health bar
For the final milestone I will help create the start page and any other small details to make the game for lively.


### Rob Russell @robdoesweb
I'm writing the main game loop and hierarchy for objects.  I'll create the update loop and make design decisions for collision detection and rendering.  I'll focus on creating a clear set of classes that can be reused to expand the game and add more features and content easily.

