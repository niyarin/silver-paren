(include "./sip-error.scm")
(include "./sip-misc.scm")

(define-library (silver-paren init)
   (import (scheme base)
           (scheme file)
           (scheme write);debug
           (silver-paren misc)
           (silver-paren error)
           (silver-paren log))
   (export silver-paren-init/inited? silver-paren-init/init)
   (begin
      (define (silver-paren-init/inited? silver-paren-directory-path)
        (file-exists?
          (silver-paren-misc/concatenate-path
            silver-paren-directory-path
            "config.list")))

      (define (%create-imprementation-config filepath)
        (call-with-output-file
          filepath
          (lambda (port)
            (display
              '((updated '()))
              port))))

      (define (silver-paren-init/init config)
        (let* ((target-dir
                (cond ((assv 'silver-paren-directory-path config) => cadr)))
               (outsourcing-flag
                (cond ((assv 'silver-paren-directory-outsourcing config)
                       => cadr)))
               (_restart-symbol
                 (cond ((assv 'silver-paren-restart-symbol config) => cadr)
                       (else  '_)))
               (imprementation-name
                 (cond ((assv 'implementation config)
                        => cadr)
                       (else "default")))
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
                  (silver-paren-log-message
                    (string-append "(mkdir " target-dir ")"))
                  (silver-paren-misc/exit-with-restart-simple
                    'silver-paren-init:create-sip-current-imprementation-dir
                    outsourcing-flag))
               (silver-paren-init:create-sip-current-imprementation-dir
                 (let ((imp-dir
                         (silver-paren-misc/concatenate-path
                                 target-dir
                                 imprementation-name)))
                    (silver-paren-misc/create-dir imp-dir outsourcing-flag)
                    (silver-paren-log-message
                       (string-append "(mkdir " imp-dir ")")))
                 (silver-paren-misc/exit-with-restart-simple
                   'silver-paren-init:create-current-imprementation-config-file
                   outsourcing-flag))
               (silver-paren-init:create-current-imprementation-config-file
                 (%create-imprementation-config
                     (silver-paren-misc/concatenate-path
                       target-dir
                       imprementation-name
                       "config.list")))))
            (else))))))
