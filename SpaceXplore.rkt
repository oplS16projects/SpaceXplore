;; THIS IS OUR STARTING CODE FOR THE GROUP PROJECT
;; ROB & LOKESH

#lang racket

(require 2htdp/universe 2htdp/image lang/posn)

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

;; entity constructor
;; takes pos - (cons (x y)) and size (cons (w h)) for collision detection
;; and sprite and creates a basic entity object.
;; all objects that display on screen will inherit from
;; this entity class
(define (make-entity pos size sprite)
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
          ((eq? m 'pos) pos)
          ((eq? m 'size) size)
          ((eq? m 'sprite) sprite)
          ((eq? m 'alive?) alive)
          ((eq? m 'change-sprite) change-sprite)
          (else (begin (print "Entity Dispatch") m))
          ))
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
  (define entity (make-entity pos size sprite))
  (define (update dt)
    ((entity 'set-y) (- (entity 'y) 5)))

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch
  )

(define projectiles '())
;;PLAYER CLASS
;; instantiated only once
(define (make-player pos size sprite)
  (define entity (make-entity pos size sprite))
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
           ((entity 'set-x) (-  (entity 'x) speed))))
    )
  (define (go-right)
    (cond ((< (entity 'x) (- window-x 50))
           ((entity 'set-x) (+ (entity 'x) speed))))
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
    )
  
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
          ((eq? m 'shoot) (shoot))
          (else (entity m))))
  dispatch)

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

(define (make-star)
  (define new-pos (cons (random window-x) (random window-y)))
  (define size (+ 1 (random 2)))
  (define entity (make-entity  new-pos (cons 3 3) (circle size "solid" "white")))
  (define speed (* 6 size))
  (print new-pos)
  (define (update dt)
    (cond ((> (entity 'y) 0)
           ((entity 'set-y) (- (entity 'y) speed)))
          (else ((entity 'set-y) window-y))))
 

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch
  )

;if (rect1.x < rect2.x + rect2.width &&
;   rect1.x + rect1.width > rect2.x &&
;   rect1.y < rect2.y + rect2.height &&
;   rect1.height + rect1.y > rect2.y) {
;    // collision detected!
;}

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

(define starfield (list (make-star)))
  
(define (make-starfield n)
  (define (starfield-help n count)
    (cond ((> n count) (begin
                         (set! starfield (append starfield (list (make-star))))
                         (starfield-help n (+ 1 count))))))
  (starfield-help n 0))

;;create starfield with n stars
(make-starfield 50)

;;add asteroids - this needs to be updated to create asteriods at specific intervals
(add-asteroids 5)

(define (make-projectile)
  (define pos (cons (+ 25 (player 'x)) (+ 50 (player 'y))))
  (define speed 15)
  (define entity (make-entity pos (cons 2 4) (rectangle 4 15 "solid" "red")))
  (define (update dt)
    ((entity 'set-y) (+ speed (entity 'y))))

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch)
  

(define (update dt)
  ;;update player positions
  ((player 'update) dt)

  ;;update asteroids
  (map (λ (asteroid) ((asteroid 'update) 0)) asteroids)
  ;;update starfield
  (map (λ (star) ((star 'update) 0)) starfield)
  ;;update projectiles
  (map (λ (proj) ((proj 'update) 0)) projectiles)

  ;;check collisions

  

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

(define (alive? ent)
  (eq? (ent 'alive?) #t))

(define (render x)
  (define asteroids-pos (map (λ (asteroid) (make-posn (asteroid 'x) (asteroid 'y))) asteroids))
  (define asteroids-sprites (map (λ (asteroid) (asteroid 'sprite)) asteroids))
  (define stars-pos (map (λ (star) (make-posn (star 'x) (star 'y))) starfield))
  (define stars-sprites (map (λ (star) (star 'sprite)) starfield))
  (define projectile-pos (map (λ (proj) (make-posn (proj 'x) (proj 'y))) projectiles))
  (define projectile-sprites (map (λ (proj) (proj 'sprite)) projectiles))
  (define bg background)
  (define stars-bg (place-images stars-sprites stars-pos bg))
  (define player-stars-bg (underlay/xy stars-bg (player 'x) (player 'y) (player 'sprite)))
  (define player-stars-bg-proj (place-images projectile-sprites projectile-pos player-stars-bg))
  ;(define player-stars-bg-proj-ui (underlay/xy player-stars-bg-proj x y sprite)
  (place-images asteroids-sprites asteroids-pos player-stars-bg-proj)
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

