(include  "sip-log.scm")
(include  "sip-error.scm")

(define-library (silver-paren misc)
   (import (scheme base)
           (scheme write)
           (scheme case-lambda)
           (scheme process-context)
           (silver-paren log)
           (srfi 1);(scheme list)
           )

   (export silver-paren-misc-assoc-cadr-with-default 
           silver-paren-misc-object->string 
           silver-paren-misc-concatenate-path
           silver-paren-misc-tail-element-in-path 
           silver-paren-misc/create-dir
           silver-paren-misc-config-ref
           silver-paren-misc-restart-begin
           silver-paren-misc/exit-with-restart-simple)

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

      (define (silver-paren-misc-tail-element-in-path url)
         (let loop ((i 0)
                    (res-index-start 0))
           (cond
             ((= i (string-length url)) 
              (substring url res-index-start (string-length url)))
             ((char=? i #\/)
              (loop (+ i 1)  (+ i 1)))
             (else
               (loop (+ i 1) i)))))

      (define (silver-paren-misc/exit-with-restart-simple symbol outsourcing-flag)
         (when outsourcing-flag
           (silver-paren-log-out-command (string-append "restart" ">" (symbol->string symbol)))
           (exit)))

      (define (silver-paren-misc/create-dir dirname outsourcing-flag)
         (if outsourcing-flag
           (silver-paren-log-out-command (string-append "create-dir" ">" dirname))
           (silver-paren-log-message "This program doesn't support creating directories.")))

      (define (silver-paren-misc-config-ref name config)
        (cond
          ((assv name config)
           => cadr)
          (else
            (silver-paren-error
              (string-append
                "Internal error.config "
                name
                " is not supported.")))))


      (define-syntax %tail-all-cond
         (syntax-rules ()
           ((_ (test1 bodies1 ...) (test2 bodies2 ...) ...)
            (if test1
              (begin
                bodies1 ...
                (begin bodies2 ...) ...)
              (%tail-all-cond
                (test2 bodies2 ... ) ...)))
           ((_)
            #f)))
   
      (define-syntax silver-paren-misc-restart-begin
         (syntax-rules () 
            ((_ target) (begein))
            ((_ target (name1 body1 ...) (name2 body2 ...)  ...)
             (silver-paren-misc-restart-begin
               target next-name-ref
               (name1 body1 ...)
               (name2 body2 ...) ...))
            ((_ target next-name-ref (name1 body1 ...) (name2 body2 ...)  ...)
             (let* ((name-list 
                      (quote (name1 name2 ...)))
                    (%next-name-ref 
                        (lambda (name)
                          (lambda ()
                            (let ((p
                                     (memq name name-list)))
                              (cond
                                ((not p))
                                ((null? (cdr p))
                                 #f)
                                (else
                                  (cadr p))))))))

               (%tail-all-cond
                  ((or (eq? target (quote name1))
                       (not target))

                   (let ((next-name-ref
                           (%next-name-ref 'name1)))
                      body1 ... ))
                  ((eq? target (quote name2)) 
                   (let ((next-name-ref
                           (%next-name-ref 'name2)))
                   body2 ...))
                  ...
             )))))
      ))
