(include "../src/sip-name-list.scm")

(define-library (test-silver-paren name-list)
   (export test-silver-paren-name-list)
   (import 
        (scheme base)
        (srfi 78) ;Lightweight testing
        (silver-paren name-list))

   (begin

      (define (%valid-name-list?-test)
         (check (silver-paren-name-list-valid-name-list? '("PIYO")) => #t)
         (check (silver-paren-name-list-valid-name-list? '()) => #f)
         (check (silver-paren-name-list-valid-name-list? '(3)) => #f)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" piiii)) => #f)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" (version "0.1.0"))) => #t)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" (version))) => #f)
         (check (silver-paren-name-list-valid-name-list? '("PIYO" (version 'abc))) => #f)
        )

      (define (%silver-paren-name-list-generate-name-list-list-from-option-test)
         (check (silver-paren-name-list-generate-name-list-list-from-option '("piyo" ":edition" "foo") ":edition")
            =>  '(("piyo" (edition "foo"))))
         (check (silver-paren-name-list-generate-name-list-list-from-option '("piyo" ":edition" "foo" "boo" "var") ":edition")
            =>  '(("piyo" (edition "foo"))("boo") ("var")))
         )

      (define (test-silver-paren-name-list)
         (%valid-name-list?-test)
         (%silver-paren-name-list-generate-name-list-list-from-option-test)
        )))
