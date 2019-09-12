(define-library (silver-paren log)
   (import (scheme base)
           (scheme write))
   (export silver-paren-log-message silver-paren-display)

   (begin
     (define (silver-paren-log-message message . opt)
         (display
           (string-append 
             "Silver-paren message:"
             message))
         (newline))

     (define (silver-paren-display obj . opt)
         (display obj))
))
