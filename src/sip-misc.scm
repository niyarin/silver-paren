(define-library (silver-paren misc)
   (import (scheme base)
           (scheme write)
           (scheme case-lambda)
           (srfi 1);(scheme list)
           )

   (export silver-paren-misc-assoc-cadr-with-default silver-paren-misc-object->string silver-paren-misc-concatenate-path)

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


      (define (%concatenate-path2-rev path2 path1)
         (if (char=? (string-ref path1 (- (string-length path1)1))
                     #\/)
           (string-append path1 path2)
           (string-append path1 "/" path2)))

      (define (silver-paren-misc-concatenate-path path1 path2 . pathn)
        (fold 
          %concatenate-path2-rev 
          (%concatenate-path2-rev path2 path1)
          pathn))
        ))
