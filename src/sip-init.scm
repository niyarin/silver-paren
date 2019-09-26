(include "./sip-error.scm")
(include "./sip-misc.scm")

(define-library (silver-paren init)
   (import (scheme base)
           (scheme file)
           (scheme write);debug
           (silver-paren misc)
           (silver-paren error))
   (export silver-paren-inited? silver-paren-init)
   (begin
      (define (silver-paren-inited? silver-paren-directory-path)
        (file-exists? 
          (silver-paren-misc-concatenate-path
            silver-paren-directory-path
            "config.list")))

      (define (silver-paren-init config)
         ;TBA
        )

     ))
