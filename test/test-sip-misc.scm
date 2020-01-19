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

      (define (%silver-paren-misc/concatenate-path-test)
         (check (silver-paren-misc/concatenate-path
                  "aaa/bbb/ccc"
                  "ddd.eeee")
                => "aaa/bbb/ccc/ddd.eeee")

         (check (silver-paren-misc\concatenate-path
                  "aaa/bbb/ccc/"
                  "ddd.eeee")
                => "aaa/bbb/ccc/ddd.eeee")
         (check (silver-paren-misc/concatenate-path
                  "aaa/bbb/ccc/"
                  "ddd"
                  "eee"
                  "fff")
                => "aaa/bbb/ccc/ddd/eee/fff"))

      (define (%silver-paren-misc-restart-begin-test)
        (map
          (lambda (check-res)
            (check
              (let ((tmp '()))
                 (silver-paren-misc-restart-begin 
                   (car check-res)
                     (a (set! tmp (cons 'a tmp)))
                     (b (set! tmp (cons 'b tmp)))
                     (c (set! tmp (cons 'c tmp)))
                     (d (set! tmp (cons 'd tmp)))))
              => (cadr check-res)))
         '((a (d c b a)) (b (d c b)) (d (d))))

         (silver-paren-misc-restart-begin
           'a
           next-name-ref
           (a (check (next-name-ref) => 'b))
           (b (check (next-name-ref) => 'c))
           (c (check (next-name-ref) => #f))))

      (define (test-silver-paren-misc)
         (%silver-paren-misc-assoc-cadr-with-default-test)
         (%silver-paren-misc-concatenate-path-test)
         (%silver-paren-misc-restart-begin-test)
         )
      ))
