(include "./sip-error.scm")

(define-library (silver-paren install)
   (import (scheme base)
           (scheme write)
           (silver-paren error))

   (export silver-paren-install)
   (begin

     (define (silver-paren-install targets . opt)
         (silver-paren-error "not impremented."))
     ))
