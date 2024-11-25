;; Test case using map
(define (delayed-double x)
   ((mu () (* x 2))))  ; Returns Unevaluated

;; Map the delayed-double function over a list
(define doubled-list (map delayed-double '(1 2 3 4 5)))
doubled-list
; expect (2 4 6 8 10)

;; Test that map correctly handles Unevaluated results
(define (delayed-square x)
   ((mu () (* x x))))

(map delayed-square '(1 2 3))
; expect (1 4 9)