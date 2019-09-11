(define-library (silver-paren misc)
   (import (scheme base)
           (scheme case-lambda))

   (export silver-paren-misc-assoc-cadr-with-default)

   (begin
      (define silver-paren-misc-assoc-cadr-with-default 
        (case-lambda 
           ((key-object alist default compare)
              (cond 
                ((assoc  key-object alist compare)
                 => cadr)
                (else
                  default)))
           ((key-object alist default)
            (silver-paren-misc-assoc-cadr-with-default
              key-object
              alist
              default
              equal?))))
   ))
