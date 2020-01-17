(include "./sip-error.scm")
(include "./sip-misc.scm")

(define-library (silver-paren init)
   (import (scheme base)
           (scheme file)
           (scheme write);debug
           (silver-paren misc)
           (silver-paren error))
   (export silver-paren-init/inited? silver-paren-init/init)
   (begin
      (define (silver-paren-init/inited? silver-paren-directory-path)
        (file-exists? 
          (silver-paren-misc-concatenate-path
            silver-paren-directory-path
            "config.list")))

      (define (silver-paren-init/init config)
        (let* ((target-dir
                (cond ((assv 'silver-paren-directory-path config) => cadr)))
               (outsourcing-flag
                (cond ((assv 'silver-paren-directory-outsourcing config) => cadr )))
               (_restart-symbol
                 (cond ((assv 'silver-paren-restart-symbol config) => cadr )
                       (else  '_)))
               (restart-symbol
                 (if (eq? _restart-symbol '_)
                   'silver-paren-init:create-sip-dir
                   _restart-symbol)))
          (cond
            ((not (silver-paren-init/inited? target-dir))
             (silver-paren-misc-restart-begin 
               restart-symbol
               (silver-paren-init:create-sip-dir
                  (silver-paren-misc/create-dir target-dir outsourcing-flag)
                  (silver-paren-misc/exit-with-restart-simple
                    'silver-paren-init:create-sip-current-imprementation-dir
                    outsourcing-flag
                    ))
               (silver-paren-init:create-sip-current-imprementation-dir
                 (display "RESTART OK")(newline))))
            (else
              ))))))
