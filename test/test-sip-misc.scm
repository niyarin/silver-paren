(include "../src/sip-misc.scm")

(define-library (test-silver-paren misc)
   (import 
        (scheme base)
        (srfi 78) ;Lightweight testing
        (silver-paren misc)
        )
   (export test-silver-paren-misc)

   (begin

      (define (%silver-paren-misc-assoc-cadr-with-default-test)
         (check (silver-paren-misc-assoc-cadr-with-default 
                  'a 
                  '((a 0)(b 1))
                  'default-value) 
                => 0)
         (check (silver-paren-misc-assoc-cadr-with-default 
                  'b 
                  '((a 0)(b 1)(b 100))
                  'default-value) 
                => 1)
         (check (silver-paren-misc-assoc-cadr-with-default 
                  'c
                  '((a 0)(b 1)(b 100))
                  'default-value) 
                => 'default-value)
         )

      (define (test-silver-paren-misc)
         (%silver-paren-misc-assoc-cadr-with-default-test)
        )))
