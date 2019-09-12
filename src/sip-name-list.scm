(include "./sip-error.scm")

(define-library (silver-paren name-list)
   (import 
     (scheme base)
     (scheme write)
     (scheme cxr)
     (only (srfi 1) fold);scheme list
     (silver-paren error)
     )
   (export silver-paren-name-list-valid-name-list?
           silver-paren-name-list-name 
           silver-paren-name-list-generate-name-list-list-from-option 
           )

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

    (define (silver-paren-name-list-name name-list)
      (car name-list))

    (define (%edition-delimiter? object edition-delimiter)
      (and
        (eq? object edition-delimiter )))

    (define (silver-paren-name-list-generate-name-list-list-from-option 
              option edition-delimiter)
         (let loop ((current-package-name '())
                    (current-package-modifications '())
                    (option option)
                    (res '()))
           (cond 
             ((and (null? option) (null? current-package-name)) (reverse res))
             ((null? option)
              (reverse
                (cons 
                  (cons current-package-name
                        current-package-modifications)
                  res)))
             ((equal? (car option) edition-delimiter)
               (when (null? (cdr option))
                  (silver-paren-error  
                    (string-append 
                      "Edition delimiter "
                      (symbol->string edition-delimiter)
                      "requires argument.")))
               (loop
                 current-package-name
                 (cons 
                   (list
                     'edition
                     (cadr option))
                   current-package-modifications)
                 (cddr option)
                 res))

             ((null? current-package-name)
              (loop 
                (car option)
                '()
                (cdr option)
                res))
             (else
               (loop
                 (car option)
                 '()
                 (cdr option)
                 (cons 
                   (cons
                     current-package-name
                     current-package-modifications)
                   res))))))
    ))
