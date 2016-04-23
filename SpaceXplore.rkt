;; THIS IS OUR STARTING CODE FOR THE GROUP PROJECT
;; ROB & LOKESH

#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require rsound)

;;game state variables
(define window-x 600)
(define window-y 800)

;;random seed
(define random-gen (make-pseudo-random-generator))

;; load resources
(define star (circle 2 "solid" "white"))
(define player-sprite-straight (bitmap "Plane.png"))
(define asteroid-sprite (bitmap "Asteroid1.png"))
(define background (bitmap "background.jpg"))

;;all the entities in the game
(define obstacles '())
(define projectiles '())
(define ents '())


;; entity constructor
;; takes pos - (cons (x y)) and size (cons (w h)) for collision detection
;; and sprite and creates a basic entity object.
;; all objects that display on screen will inherit from
;; this entity class
(define (make-entity pos size sprite collidable)
  (define (set-x xpos) (set! pos (cons xpos (cdr pos))))
  (define (set-y ypos) (set! pos (cons (car pos) ypos)))
  (define (set-w width) (set! size (cons width (cdr size))))
  (define (set-h height) (set! size (cons (car size) height)))
  (define (set-pos new-pos) (set! pos new-pos))
  (define (set-size new-size) (set! size new-size))
  (define (change-sprite new-sprite)
    (set! sprite new-sprite))
  (define alive #t)
  (define (kill) (set! alive #f))
  (define (wake-up pos) (begin (set-pos pos) (set! alive #t)))

  (define (dispatch m)
    (cond ((eq? m 'x) (car pos))
          ((eq? m 'y) (cdr pos))
          ((eq? m 'w) (car size))
          ((eq? m 'h) (cdr size))
          ((eq? m 'set-x) set-x)
          ((eq? m 'set-y) set-y)
          ((eq? m 'set-w) set-w)
          ((eq? m 'set-h) set-h)
          ((eq? m 'set-pos) set-pos)
          ((eq? m 'set-size) set-size)
          ((eq? m 'collidable) collidable) ;;basic entities are not collidable, override in inherited classes
          ((eq? m 'pos) pos)
          ((eq? m 'size) size)
          ((eq? m 'sprite) sprite)
          ((eq? m 'alive?) alive)
          ((eq? m 'kill) (set! alive #f))
          ((eq? m 'change-sprite) change-sprite)
          (else (begin (print "Entity Dispatch") m))
          ))
  
  (set! ents (append ents (list dispatch)))
  dispatch
 )

;;find the first dead entity in a list
(define (first-dead ents)
  (if (eqv? ents '())
      #f
      (if ((car ents) 'alive?)
          (car ents)
          (first-dead (cdr ents)))))

;;obstacle constructor
(define (make-obstacle pos size sprite)
  (define entity (make-entity pos size sprite #t))
  (define (update dt)
    ((entity 'set-y) (- (entity 'y) 5)))

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          ((eq? m 'collidable) #t)
          (else (entity m))))
  dispatch
  )

;;PLAYER CLASS
;; instantiated only once
(define (make-player pos size sprite)
  (define entity (make-entity pos size sprite #f))
  (define speed 5)
  (define health 100)
  (define power 5)
  (define going-up #f)
  (define going-down #f)
  (define going-left #f)
  (define going-right #f)
  
  ;;define procedures for moving to change sprites
  (define (go-left)
    (cond ((> (entity 'x) 0)
           ((entity 'set-x) (-  (entity 'x) 10))))
    )
  (define (go-right)
    (cond ((< (entity 'x) (- window-x 50))
           ((entity 'set-x) (+ (entity 'x) 10))))
    )
  (define (go-up)
    (cond ((> (entity 'y) 0)
           ((entity 'set-y) (- (entity 'y)  speed))))
    )
  (define (go-down)
    (cond ((< (entity 'y) (- window-y 100))
           ((entity 'set-y) (+ speed (entity 'y)))))
    )
  (define (shoot)
    (if (< power 1)
        #f
        (set! projectiles (append projectiles (list (make-projectile))))
    ))
  
  (define (update dt)
    (cond (going-left (go-left)))
    (cond (going-right (go-right)))
    (cond (going-up (go-up)))
    (cond (going-down (go-down)))
  )
  
  (define (dispatch m)
    (cond ((eq? m 'update) update)
          ((eq? m 'move-right) (begin (set! going-right #t) 'move-right))
          ((eq? m 'move-left) (set! going-left #t))
          ((eq? m 'move-down) (set! going-down #t))
          ((eq? m 'move-up) (set! going-up #t))
          ((eq? m 'stop-up) (set! going-up #f))
          ((eq? m 'stop-down) (set! going-down #f))
          ((eq? m 'stop-left) (set! going-left #f))
          ((eq? m 'stop-right) (set! going-right #f))
          ((eq? m 'decrease-health) (set! health (- health 20)))
          ((eq? m 'health) health)
          ((eq? m 'shoot) (begin (shoot) (shoot2)))
          (else (entity m))))
  dispatch)

(define(full-health)
  (place-image  (overlay(rectangle 200 30 "outline" "black")
                        (rectangle 200 30 "solid" "red"))  100 100 (overlay(rectangle 200 30 "outline" "black")
                                                                           (rectangle 200 30 "solid" "red"))))
(define (hit-once)
  (overlay(text "health" 18 "black")(rectangle 200 30 "outline" "black")
          (rectangle 120 30 "solid" "red")))
(define (hit-twice)
  (overlay(text "health" 18 "black")(rectangle 200 30 "outline" "black")
          (rectangle 55 30 "solid" "red")))
(define (hit-3)
  (error "end of game"))
 
   
  
;; sounds

(define(shoot2)
  (define shoot1(rs-read "shoot.wav"))
  (play shoot1))

(define (explosion)
  (define explosion1(rs-read "explosion2.wav"))(play explosion1))

;;instantiate player object
(define player (make-player (cons 100 100) (cons 10 10) player-sprite-straight))

(define asteroids '())

(define (add-asteroids num)
  (define (asteroids-help n count)
    (cond ((> n count) (begin
                         (define new-pos (cons (random window-x) (+ window-y (random window-y))))
                         (define size (cons 50 50))
                         (set! asteroids (append asteroids (list (make-obstacle new-pos size (rotate (random 359) asteroid-sprite)))))
                         (asteroids-help n (+ 1 count))))))
  (asteroids-help num 0)    
)

;;starfield for background

(define (make-star)
  (define new-pos (cons (random window-x) (random window-y)))
  (define size (+ 1 (random 2)))
  (define entity (make-entity  new-pos (cons 3 3) (circle size "solid" "white") #f))
  (define speed (* 6 size))
  (define (update dt)
    (cond ((> (entity 'y) 0)
           ((entity 'set-y) (- (entity 'y) speed)))
          (else ((entity 'set-y) window-y))))
 

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch
  )

(define starfield (list (make-star)))
  
(define (make-starfield n)
  (define (starfield-help n count)
    (cond ((> n count) (begin
                         (set! starfield (append starfield (list (make-star))))
                         (starfield-help n (+ 1 count))))))
  (starfield-help n 0))

;;create starfield with n stars
(make-starfield 50)

(define (make-projectile)
  (define pos (cons (player 'x) (+ 50 (player 'y))))
  (define speed 15)
  (define entity (make-entity pos (cons 2 4) (rectangle 4 15 "solid" "red") #f))
  (define (update dt)
    ((entity 'set-y) (+ speed (entity 'y))))

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch)

;;collision detection

(define (collides obj1 obj2)
  (define x1 (obj1 'x))
  (define y1 (obj1 'y))
  (define h1 (obj1 'h))
  (define w1 (obj1 'w))
  (define x2 (obj2 'x))
  (define y2 (obj2 'y))
  (define h2 (obj2 'h))
  (define w2 (obj2 'w))
  (if (and (< x1 (+ x2 w2)) (< x2 (+ x1 w1)) (< y2 (+ y1 h1)) (< y1 (+ y2 h2)))
      #t
      #f))

(define (check-collisions)
  ;;get all the objects that can effect player or projectiles
  (define collidables (filter (λ (ent) (and (alive? ent) (ent 'collidable))) ents))
  ;;check if the collidable hit the player
  (map
   (λ (collidable) (if (collides player collidable)
                       (begin (collidable 'kill) (player 'decrease-health))
                       #f)) collidables)
  ;;check if the projectiles hit the collidables (double map, cool shit but maybe not most effecient)
  (map
   (λ (collidable) (map
                    (λ (projectile) (if (collides collidable projectile)
                                        (begin (projectile 'kill) (collidable 'kill) (remove projectile projectiles) (remove collidable ents) (explosion))
                                        #f)) (filter alive? projectiles))) collidables))

;;clean up erases asteroids and projectiles that go off screen
;; (stars are not cleaned up because they are reused)
(define (clean-up)
  (define collidables (filter (λ (ent) (and (alive? ent) (ent 'collidable))) ents))
  (map (λ (collidable) (if (or (not (alive? collidable)) (< (collidable 'y) 0))
                           (begin (remove collidable ents) (remove collidable asteroids))
                           #f)) collidables)
  (map (λ (projectile) (if (or (not (alive? projectile)) (> (projectile 'y) window-y))
                           (remove projectile projectiles)
                           #f)) projectiles)
  )


;;update calls

(define ticks 0)
(define seconds 1)

(define (update dt)
  ;;update player positions
  ((player 'update) dt)

  ;;update asteroids
  (map (λ (asteroid) ((asteroid 'update) 0)) asteroids)
  ;;update starfield
  (map (λ (star) ((star 'update) 0)) starfield)
  ;;update projectiles
  (map (λ (proj) ((proj 'update) 0)) projectiles)

  (set! ticks (+ 1 ticks))
  (set! seconds (+ 1/28 seconds))
  (if (eq? (modulo ticks 140) 0)
      (add-asteroids 5)
      #f
  )

  ;;check collisions
  (check-collisions)

  ;;get rid of unused entities
  (clean-up)
)

(define (handle-key-down world key)
  (cond
    [(key=? key "left") (player 'move-left)]
    [(key=? key "right") (player 'move-right)]
    [(key=? key "up") (player 'move-up)]
    [(key=? key "down") (player 'move-down)]
    [(key=? key " ") (player 'shoot)]
    [else world]
    )
)

(define (handle-key-up world key)
  (cond
    [(key=? key "left") (player 'stop-left)]
    [(key=? key "right") (player 'stop-right)]
    [(key=? key "up") (player 'stop-up)]
    [(key=? key "down") (player 'stop-down)]
    [else world]
    )
)

;;to filter if enemies should be rendered
(define (alive? ent)
  (eq? (ent 'alive?) #t))

(define (render x)
;  (define asteroids-pos (map (λ (asteroid) (make-posn (asteroid 'x) (asteroid 'y))) (filter alive? asteroids)))
;  (define asteroids-sprites (map (λ (asteroid) (asteroid 'sprite)) (filter alive? asteroids)))
;  (define stars-pos (map (λ (star) (make-posn (star 'x) (star 'y))) starfield))
;  (define stars-sprites (map (λ (star) (star 'sprite)) starfield))
;  (define projectile-pos (map (λ (proj) (make-posn (proj 'x) (proj 'y))) (filter alive? projectiles)))
;  (define projectile-sprites (map (λ (proj) (proj 'sprite)) (filter alive? projectiles)))
;  (define bg background)
;  (define rec(rectangle 400 500 "solid" "red"))
;  (define stars-bg (place-images stars-sprites stars-pos bg))
;  (define player-stars-bg (underlay/xy stars-bg (player 'x) (player 'y) (player 'sprite)))
;  ;(define player-health(underlay/xy player-stars-bg))
;  (define player-stars-bg-proj (place-images projectile-sprites projectile-pos player-stars-bg))
  ;(define player-stars-bg-proj-ui (underlay/xy player-stars-bg-proj x y sprite)
  (define ents-pos (map (λ (entity) (make-posn (entity 'x) (entity 'y))) (filter alive? ents)))
  (define ents-sprites (map (λ (entity) (entity 'sprite)) (filter alive? ents)))
  (place-images ents-sprites ents-pos background)
)
  
;  (define scene (underlay/xy (rectangle 600 800 "solid" "black") (player 'x) (player 'y) (player 'sprite)))
;  (map (λ (asteroid)
;  (set! scene underlay/xy (underlay/xy (rectangle 600 800 "solid" "black") (player 'x) (player 'y) (player 'sprite))
;               (asteroid 'x) (asteroid 'y) (asteroid 'sprite))) asteroids)
  
  


;;game initialization
(big-bang 0
          (on-tick update)
          (on-key handle-key-down)
          (on-release handle-key-up)
          (to-draw render))

