(include "../src/sp-name-list.scm")

(define-library (test-silver-paren name-list)
   (export test-silver-paren-name-list)
   (import 
        (scheme base)
        (srfi 78) ;Lightweight testing
        (silver-paren name-list)
        )

   (begin

      (define (internal-valid-name-list?-test)
         (check (silver-paren-name-list-valid-name-list? '("PIYO")) => #t)
         (check (silver-paren-name-list-valid-name-list? '()) => #f)
         (check (silver-paren-name-list-valid-name-list? '(3)) => #f)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" piiii)) => #f)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" (version "0.1.0"))) => #t)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" (version))) => #f)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" (version 'abc))) => #f)
        )

      (define (test-silver-paren-name-list)
         (internal-valid-name-list?-test)
        )))
