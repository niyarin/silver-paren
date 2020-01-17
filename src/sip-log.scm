(define-library (silver-paren log)
   (import (scheme base)
           (scheme write))
   (export silver-paren-log-message silver-paren-display silver-paren-log-out-command)

   (begin
     (define (silver-paren-log-message message . opt)
         (display
           (string-append 
             "Silver-paren message:"
             message))
         (newline))

     (define (silver-paren-display obj . opt)
         (display obj))

     (define (silver-paren-log-out-command message)
         (display 
           (string-append
             "Silver-paren-out-command:"
             message))
        (newline))
))
