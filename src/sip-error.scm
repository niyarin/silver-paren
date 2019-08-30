(include "./niyarin-rainbow-write/niyarin-rainbow-write.scm")

(define-library (silver-paren error)
   (import (scheme base)
           (scheme write)
           (niyarin rainbow write))
   (export silver-paren-error-mes
           silver-paren-error)
   (begin
     
     (define (silver-paren-error-mes mes . opt-port)
       (let ((port (if (null? opt-port) (current-error-port) (car opt-port))))
         (display-first-color 
              "Silver-paren error: "
           port)
         (display 
           mes
           port)
         ))
     (define (silver-paren-error error-message . opt)
       (error error-message opt))
     ))
