(define-library (niyarin optparse)
      (import (scheme base)
              (scheme cxr)
              (scheme process-context)
              (scheme write))

      (export niyarin-optparse-optparse niyarin-optparse-generate-help-text)
      
      (begin 

        (define (optparse-aux input optional-arguments positional-arguments)

          (define (state-nargs-zero? state)
              (eqv? (cadr state) 0))

          (define (state-current-argument state)
            (car state))

          (define (state-nargs state)
              (cadr state))
          (define (state-values state)
            (cadddr state))

          (define (state-default state)
            (caddr state))

          (define (state-create-new-state  option current-argument . opt-default-nargs)
            (let ((default-nargs (if (null? opt-default-nargs) 0 (car opt-default-nargs))))
               (let ((nargs (cond ((assv 'nargs (cdr option)) => cadr) (else default-nargs)))
                     (default (cond ((assv 'default (cdr option)) => (lambda (x) (list (cadr  x))))(else #f))))
                 (list current-argument  nargs default (list (car option))))))


          (define (state-decrement-and-push-val state val)
            (let ((nargs (state-nargs state))
                  (vals (state-values state)))
              (cond 
                ((and (integer? nargs) (> nargs 0))
                  (list-set! state 1 (- nargs 1))))

              (list-set! state 3 (cons val vals))))

          (define (restore-current-argument! option)
               (let ((argument-data 
                       `(,(car (state-values option)) 
                         ,(list 'nargs (state-nargs option)) 
                         .
                         ,(if (state-default option) (list (list 'default (car (state-default option)))) '() ))))
                 (set-car! option (cons argument-data (car option)))
                 (set-car! (cdr option) 0)
                 (set-car! (cddr option) #f)
                 (set-car! (cdddr option) '())))

          (define (loop-end input res positional-state optional-state)
            (when (and (not (null? (state-values positional-state)))
                       (not (null? (cdr (state-values positional-state)))))

                  (unless (or (state-nargs-zero? positional-state)
                               (eqv? (state-nargs positional-state) '*))
                     (error "not match" (car (reverse (cadddr positional-state)))))
                  (set! res (cons (reverse (state-values positional-state)) res))
                  (when (not (null? (car positional-state)))
                     (set-car! positional-state (cdar positional-state))))

            (when (null? (cdr (state-values positional-state)))
               (restore-current-argument! positional-state))

            (let loop ((ps (car positional-state)))
              (unless (null? ps)
                  (let ((default (assv 'default (car ps)))
                        (nargs (cond ((assv 'nargs (cdr (car ps))) => cadr) (else 1))))
                    (cond
                      ((and (not default) (not (eqv? nargs '*))) (error "not match" (caar ps)))
                      ((not default) '())
                      (else (set! res (cons (list (caar ps)(cadr default)) res))))
                  (loop (cdr ps)))))

            (when (state-values optional-state)
               (cond 
                 ((or (state-nargs-zero? optional-state)
                      (and (not (null?  (cdr (state-values optional-state))))
                           (eqv? (state-nargs optional-state) '*)))
                      
                      (set! res (cons (reverse (state-values optional-state)) res)))
                 ((and (or (eqv? (state-nargs optional-state) '*) 
                           (eqv? (state-nargs optional-state) 1))
                       (null? (cdr (state-values optional-state)))
                       (assv 'default optional-state))
                     (set! res (cons (list (car (state-values optional-state)) (cadr (assv 'default optional-state)))  res)))
                 (else (error "not match" (car optional-state)))))
            res)

          (let loop ((input input)
                     (res '())
                     (positional-state
                       (if (null? positional-arguments)
                         (list '() '() '() '())
                         (state-create-new-state (car positional-arguments) (cdr positional-arguments) 1));current positional-argument, nargs ,default , values
                       )
                     (optional-state (list #f #f #f #f)));current optional-argument , nargs ,default , values
            (if (null? input)
              (loop-end input res positional-state optional-state)
              (let ((is-optional (assoc (car input) optional-arguments string=?)))
                (cond 
                  ((and is-optional 
                        (not (state-current-argument optional-state)))
                    (loop (cdr input) res positional-state (state-create-new-state is-optional (car is-optional))))
                  ((and  (>= (string-length (car input)) 3)
                         (char=? (string-ref (car input) 0) #\-)
                         (not (char=? (string-ref (car input) 1) #\-))
                         (assoc (string #\- (string-ref (car input ) 1))
                                optional-arguments string=?))
                   => (lambda (is-optional)
                        (loop (cons
                                (substring (car input) 2 (string-length (car input)))
                                (cdr input))
                              res
                              positional-state
                              (state-create-new-state
                                is-optional
                                (car is-optional)))))
                  
                  ((or (and (integer? (state-nargs optional-state))
                            (> (state-nargs optional-state) 0)
                            (not (state-default optional-state)))
                       (and (not is-optional) (not (state-nargs-zero? optional-state)) (car optional-state) ))
                   (state-decrement-and-push-val optional-state (car input))
                   (loop (cdr input) res positional-state optional-state))

                  ((and (or (eqv? (state-nargs optional-state) 1)
                            (eqv? (state-nargs optional-state) '*)) 
                         (null? (cdr (state-values optional-state)))
                         is-optional
                         (state-default optional-state))
                     (state-decrement-and-push-val optional-state (car (state-default optional-state)))
                     (loop input res positional-state optional-state))
                   

                  ((or (and (state-values optional-state)
                            (state-nargs-zero? optional-state))
                       (and (eqv? (state-nargs optional-state) '*) 
                            is-optional))
                     (loop input (cons (reverse (state-values optional-state)) res) positional-state '(#f #f #f #f)))

                  ((and (null? (car positional-state)) (state-nargs-zero? positional-state))
                     (error "not match" (car input)))

                  ((state-nargs-zero? positional-state)
                    (let ((new-res (cons (reverse  (state-values positional-state)) res))
                          (new-state (state-create-new-state (caar positional-state) (cdar positional-state) 1)))
                      (loop input new-res  new-state optional-state)
                      ))
                  
                  (else 
                    (state-decrement-and-push-val positional-state (car input))
                    (loop (cdr input) res positional-state optional-state))
                  )))))


        (define (check-optparse-option option)

            (let ((head-cell-positional-arguments (list '())))
             (let loop ((option option)
                        (optional-arguments '())
                        (positional-arguments head-cell-positional-arguments))
               (cond ((null? option) (values optional-arguments (cdr head-cell-positional-arguments)))
                 ((or (not (string? (caar option)))
                      (zero? (string-length (caar option))))
                     (error "invalid option" (car option)))

                 ((not (char=? (string-ref (caar option) 0) #\-))
                       (set-cdr! positional-arguments (list (car option)))
                       (loop (cdr option)
                             optional-arguments
                             (cdr positional-arguments)))
                 ((and (string? (cadar option))
                       (char=? (string-ref (cadar option) 0) #\-))
                     (let ((opt1 (cons (caar option) (cons (list 'short-option-string (cadar option)) (cddar option))))
                           (opt2 (cons (cadar option) (cddar option))))
                        (loop (cdr option)
                              (cons opt1 (cons opt2 optional-arguments))
                              positional-arguments)))
                 
                 (else 
                   (loop (cdr option) 
                         (cons (cons (caar option) (cons (list 'short-option-string "   ") (cdar option))) optional-arguments)
                         positional-arguments)
                 )))))
                     

        (define (niyarin-optparse-optparse option . opt-input)
          (let-values (((optional-arguments positional-arguments) (check-optparse-option option)))
             (let ((input 
                     (if (null? opt-input)
                       (cdr (command-line))
                       (car opt-input))))
               (optparse-aux input optional-arguments positional-arguments))))



        (define (generate-destination-words option)
          (let ((destination-word 
                   (cond 
                     ((assv 'destination option)  => cadr) 
                     ((and (char=? (string-ref (car option) 0) #\-)
                           (char=? (string-ref (car option) 1) #\-))
                      (substring (car option) 2 (string-length (car option))))
                     ((char=? (string-ref (car option) 0) #\-) 
                      (substring (car option) 1 (string-length (car option))))
                     (else (car option))))
                (nargs (cond ((assv 'nargs option) => cadr) (else 0))))
            (cond 
              ((eqv? nargs 0) "")
              ((eqv? nargs '*) (string-append "[" destination-word " ..." "]"))
              (else 
                (let loop ((i nargs)(res ""))
                  (if (zero? i)
                    res
                    (loop (- i 1) (string-append destination-word " " res))))))))
                          

        (define (niyarin-optparse-generate-help-text option .  args)
          (let-values (((optional-arguments positional-arguments) (check-optparse-option option)))
            (let ((res ""))

               (set! res (string-append res "USAGE:"))

               (let ((program-name (cond ((assv 'program-name args) => cadr)(else #f))))
                 (when program-name
                    (set! res (string-append res program-name ))
                    (set! res (string-append res " "))
                    (let loop ((ps positional-arguments))
                      (unless (null? ps)
                           (let ((destination (generate-destination-words (car ps))))
                              (set! res (string-append res destination " ")))
                           (loop (cdr ps))))
                    (when (not (null? positional-arguments))
                        (set! res (string-append res "  [option] ... ")))
                    (set! res (string-append res "\n"))
                 ))

               (set! res (string-append res "positional arguments\n"))
               (let loop ((positional-arguments positional-arguments))
                    (unless (null? positional-arguments)
                        (set! res (string-append res "  "))
                        (set! res (string-append res (caar positional-arguments)))
                        (set! res (string-append res ":"))
                        (cond ((assv 'help (cdar positional-arguments)) => 
                                 (lambda (x) 
                                   (set! res (string-append res "    " ))
                                   (set! res (string-append res (cadr x))))))
                     (set! res (string-append res "\n"))
                     (loop (cdr positional-arguments))
                     ))


               (set! res (string-append res "optional arguments\n"))
               (let loop ((optional-arguments optional-arguments))
                 (unless (null? optional-arguments)
                     (let ((short-option-string (assv 'short-option-string (cdar optional-arguments))))
                       (when short-option-string
                           (set! res (string-append res "  "))
                           (set! res (string-append res (caar optional-arguments)))

                           (set! res (string-append res "  " (cadr short-option-string)))
                           (set! res (string-append res " " (generate-destination-words (car optional-arguments))))
                           (set! res (string-append res " :"))
                           (cond ((assv 'help (cdar optional-arguments)) => 
                                       (lambda (x) 
                                         (set! res (string-append res "    " ))
                                         (set! res (string-append res (cadr x))))))
                           (set! res (string-append res "\n"))
                           ))
                     (loop (cdr optional-arguments))))
               res
            )))))
