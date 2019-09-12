(define-library (silver-paren misc)
   (import (scheme base)
           (scheme write)
           (scheme case-lambda))

   (export silver-paren-misc-assoc-cadr-with-default silver-paren-misc-object->string)

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

      (define (silver-paren-misc-object->string obj)
        (let ((output-string (open-output-string)))
          (display obj output-string)
          (get-output-string output-string)))
   ))
