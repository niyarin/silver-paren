(define-library (silver-paren name-list)
   (import 
     (scheme base)
     (scheme cxr)
     (only (srfi 1) fold);scheme list
     )
   (export silver-paren-name-list-valid-name-list?)

   (begin
     ;example (SOFTNAME VERSION? OPT? ...)

     (define (aux-name-list?-valid-name-list-option? option)
       (and 
         (list? option)
         (symbol? (car option))
         (or 
            (and
               (eq? (car option) 'version)
               (not (null? (cdr option)))
               (string? (cadr option)))
            (eq? (car option) 'features)
            (eq? (car option) 'edition))))

    (define (silver-paren-name-list-valid-name-list? name-list)
       (cond
         ((null? name-list) #f)
         ((and (list? name-list) 
            (string? (car name-list)))

          (or 
            (null?  (cdr name-list));NAME ONLY
            (and 
              (fold
                (lambda (option prev-result)
                  (if prev-result
                     (aux-name-list?-valid-name-list-option?
                       option)
                     #f))
                #t
                (cdr name-list)))))
         (else 
           #f)))
   ))
