#lang racket

(require 2htdp/universe 2htdp/image)

;; THIS IS OUR STARTING CODE FOR THE GROUP PROJECT
;; ROB & LOKESH

(define (game start) 'foo)

;; load resources

(define default-sprite 'someimagehere)


;; entity constructor
(define (make-entity x y)
  (define xpos x)
  (define ypos y)
  (define sprite default-sprite)
  (define (change-sprite new-sprite)
    (set! sprite new-sprite))

  (define (dispatch m)
    (cond ((eq? m 'x) xpos)
          ((eq? m 'y) ypos)
          ((eq? m 'change-sprite) change-sprite)
          (else "ERROR ENTITY DISPATCH")
          ))
  dispatch  
 )

