(include "./sip-feature-libraries.scm")

(define-library (silver-paren features)
   (import (scheme base)
           (scheme cxr)
           (scheme case-lambda)
           (scheme write);for debug
           (silver-paren  features-libraries))
   (export silver-paren-features)
   (begin

     (define (%generate-default-features)
        (let loop ((features-srfi (silver-paren-features-srfi))
                   (features-r7rs (silver-paren-features-r7rs))
                   (res '()))
          (cond 
            ((and (null? features-srfi) (null? features-r7rs))
             res)
            ((not (null? features-srfi))
             (loop 
               (cdr features-srfi)
               features-r7rs
               (cons
                  (string->symbol
                     (string-append 
                       (symbol->string (caar features-srfi))
                       "-"
                       (if (number? (cadar features-srfi))
                          (number->string (cadar features-srfi))
                          (symbol->string (cadar features-srfi)))))
                  res)))
            (else
              (loop
                '()
                (cdr features-r7rs)
                (cons
                   (string->symbol
                     (string-append
                       (symbol->string (caar features-r7rs))
                       "-"
                       (symbol->string (cadar features-r7rs))))
                   res))))))

     (define silver-paren-features
       (case-lambda
         (()
          (%generate-default-features))
         ((sub-feature-name))))
     ))

(import (silver-paren features) (scheme base) (scheme write))
(display
  (silver-paren-features))(newline)
