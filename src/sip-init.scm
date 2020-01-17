(include "./sip-error.scm")
(include "./sip-misc.scm")

(define-library (silver-paren init)
   (import (scheme base)
           (scheme file)
           (scheme write);debug
           (silver-paren misc)
           (silver-paren error))
   (export silver-paren-inited? silver-paren-init)
   (begin
      (define (silver-paren-inited? silver-paren-directory-path)
        (file-exists? 
          (silver-paren-misc-concatenate-path
            silver-paren-directory-path
            "config.list")))

      (define (silver-paren-init config)
        (let ((target-dir
                (cond ((assv 'silver-paren-directory-path config) => cadr)))
              (outsourcing-flag
                (cond ((assv 'silver-paren-directory-outsourcing config) => cadr )))
              (restart-symbol 'silver-paren-init:create-sip-dir))
          (cond
            ((not (silver-paren-inited? target-dir))
             (silver-paren-misc-restart-begin 
               restart-symbol
               (silver-paren-init:create-sip-dir
                  (silver-paren-misc/create-dir target-dir outsourcing-flag)
                  (silver-paren-misc/exit-with-restart-simple
                    'silver-paren-init:create-sip-current-imp-dir
                    outsourcing-flag
                    ))))
            (else
              )
        )))
     ))
