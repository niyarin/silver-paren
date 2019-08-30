(include "./niyarin-rainbow-write/niyarin-rainbow-write.scm")

(define-library (silver-paren error)
   (import (scheme base)
           (niyarin rainbow write))
   (export silver-paren-error-mes)
   (begin
     
     (define (silver-paren-error-mes mes . opt-port)
       (let ((port (if (null? opt-port) (current-error-port) (car opt-port))))
         (display-first-color mes port)
         ))
     ))
