# Project Title: SpaceXplore

### Statement
We're designing a 2D space shooting game that uses graphics and sound to make it fun and interesting. The user will be able to control a spaceship and the purpose of the game is to avoid the obstacles that are ahead. 

### Analysis
To allow the user to move the spacecraft anywhere on the screen we will use cons, car and cdr. Use FoldL for handling situations when the health of the spacecraft is low or when the the spacecraft hits an object. Use recusion to create multiple obstacles. We will use inheritance and map .....................

Explain what approaches from class you will bring to bear on the project. Be explicit: e.g., will you use recursion? How? Will you use map/filter/reduce? How? Will you use data abstraction? Will you use object-orientation? Will you use functional approaches to processing your data? Will you use state-modification approaches? A combination?



### Data set or other source materials
We will be building our own simulation and creating our own data. We will however be using 2D sprits from randowm websites for our game.


### Deliverable and Demonstration
In the end we will have a fully funtional interactive game that will allow the user to contol the spacecraft and move around obstacles. The obstacles will be random so the user will not know where to move the spacecraft. 




### Evaluation of Results
We should be able to run the game without any errors till the end.


How will you know if you are successful? 

We will know if we are successful if a user is able to play the game smoothly without any errors and be able to enjoy it.

## Architecture Diagram
![finalprojdesign](https://cloud.githubusercontent.com/assets/12664198/14360127/db9d94c8-fcc2-11e5-849c-176db2a35bc4.jpg)

The way the game will work is the user will start the game and the program will then generate a random objects at random X and Y positions on the screen. These objects will vary is size and the trajectrory. The player will have to either move around or shoot the objects to avoid getting hit. The spacecraft that the user controls will have a health bar so after a certain amount of hits the game will end. 

The game runs in a big loop. It first starts off with a input. This can either be starting the game or pressing the shoot button or a collision. Once this happens, a new frame is generated based on the inputs and the game gets updated. Some things that can get updated are health and if you shoot something then that object goes away.

## Schedule
Explain how you will go from proposal to finished product. 

There are three deliverable milestones to explicitly define, below.

The nature of deliverables depend on your project, but may include things like processed data ready for import, core algorithms implemented, interface design prototyped, etc. 

You will be expected to turn in code, documentation, and data (as appropriate) at each of these stages.

Write concrete steps for your schedule to move from concept to working system. 

### First Milestone (Fri Apr 15)
A 2D world with the spacecraft being able to more around in it. 

### Second Milestone (Fri Apr 22)
Add features like health, sound, obstacles 

### Final Presentation (last week of semester)
Add more interactive things. Start page/intro.

## Group Responsibilities
Here each group member gets a section where they, as an individual, detail what they are responsible for in this project. Each group member writes their own Responsibility section. Include the milestones and final deliverable.

**Additional instructions for teams of three:** 
* Remember that you must have prior written permission to work in groups of three (specifically, an approved `FP3` team declaration submission).
* The team must nominate a lead. This person is primarily responsible for code integration. This work may be shared, but the team lead has default responsibility.
* The team lead has full partner implementation responsibilities also.
* Identify who is team lead.

In the headings below, replace the silly names and GitHub handles with your actual ones.

### Lokesh Manchi @lokeshmanchi
I will write the code that allows the user to move the spacecraft freely to avoid the obsticles and write code for sound.
For the first milestone I will create the code for allowing the user to move the spacecraft.
For the second milestone I will write code for the sound to make the game more immersive and create the health bar
For the final milestone I will help create the start page and any other small details to make the game for lively.


### Rob Russell @robdoesweb
I will work on creating the 2D world for the game, this includes obsticles 


