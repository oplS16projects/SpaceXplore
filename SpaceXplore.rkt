#lang racket

(require 2htdp/universe 2htdp/image)

;; THIS IS OUR STARTING CODE FOR THE GROUP PROJECT
;; ROB & LOKESH

(define (game start) 'foo)

;; load resources

(define default-sprite (circle 10 "solid" "green"))
(define player-sprite-straight (rotate 180 (bitmap "Plane.png")))


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
          ((eq? m 'change-sprite) change-sprite)
          (else "ERROR ENTITY DISPATCH")
          ))
  dispatch
 )

(define (obstacle x y)
  (define entity (make-entity x y))
  (define (update dt)
    ((entity 'set-y) (+ (* -5 dt) (entity 'x))))

  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch
  )

(define (player pos size sprite)
  (define entity (make-entity pos size sprite))
  (define going-right #f)
  (define going-left #f)
  (define going-up #f)
  (define going-down #f)
  (define (update dt)
    'update-function-for-player)
  
  (define (dispatch m)
    (cond ((eq? m 'update) update)
          (else (entity m))))
  dispatch)

(define (update dt)
  ;;call update on all entities
  'call-update-on-all-entities
  )


(define (render)
  'render-function
  )

