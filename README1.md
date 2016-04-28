# FP7-webpage SpaceXplore

##Authors
Lokesh Manchi (@lokeshmanchi)

Rob Russell(@robdoesweb)

##Overview
We're designing a 2D space shooting game that uses graphics and sound to make it fun and interesting. The user will be able to control a spaceship and the purpose of the game is to avoid the obstacles that are ahead.

##Screenshot
![screenshot showing game-start](startpage-everything.png)
![screenshot showing game-play](game-play.png)


##Concepts Demonstrated
Identify the OPL concepts demonstrated in your project. Be brief. A simple list and example is sufficient. 
* **Data abstraction** is used to provide access to the elements of the RSS feed.
* The objects in the OpenGL world are represented with **recursive data structures.**
* **Symbolic language processing techniques** are used in the parser.

##External Technology and Libraries
Briefly describe the existing technology you utilized, and how you used it. Provide a link to that technology(ies).

##Favorite Scheme Expressions
####Lokesh Manchi (a team member)
Each team member should identify a favorite expression or procedure, written by them, and explain what it does. Why is it your favorite? What OPL philosophy does it embody?
Remember code looks something like this:
```scheme
(map (lambda (x) (foldr compose functions)) data)
```
####Rob Russell (another team member)
This expression reads in a regular expression and elegantly matches it against a pre-existing hashmap....
```scheme
(let* ((expr (convert-to-regexp (read-line my-in-port)))
             (matches (flatten
                       (hash-map *words*
                                 (lambda (key value)
                                   (if (regexp-match expr key) key '()))))))
  matches)
```

##Additional Remarks
Anything else you want to say in your report. Can rename or remove this section.

#How to Download and Run
You may want to link to your latest release for easy downloading by people (such as Mark).

The file you should run is called SpaceXplore.rxt
When you run the program a window will pop up (first image on the screenshot section of this file) you have to press the right arrow key. This will then start the game. You can move the spaceship around by using the arrow keys and the space to shoot. The point of the game is to avoid the asteriods by shooting them of moving around them. Just don't get hit!

