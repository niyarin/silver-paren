(include "./optparse/niyarin_optparse.scm")
(include "./sip-error.scm")
(include "./sip-command.scm")
(include "./sip-config.scm")

(define-library (silver-paren main)
   (import (scheme base)
           (scheme write)
           (scheme process-context)
           (silver-paren error)
           (silver-paren command)
           (silver-paren config)
           (niyarin optparse))
   (export silver-paren-main)

   (begin 
     (define ARG-CONFIG
       `(("--help" "-h" (help "Display a help message and exit."))
         ("--version" "-v" (help "Display Silver-paren's version and exit."))
         ("--network-outsourcing" (nargs 0))
         ("--directory-outsourcing" 
          (nargs 0)
          (silver-paren-config-name silver-paren-directory-outsourcing)
          (silver-paren-config-type ,(lambda x #t)))
         ("--edition-delimiter"  
             (help "Set edition delimiter.(default :edition)") 
             (nargs 1)
             (silver-paren-config-name edition-delimiter) 
             (silver-paren-config-type ,cadr))
         ("--restart-symbol"
             (help "Hidden option")
             (nargs 1)
             (silver-paren-config-name silver-paren-restart-symbol)
             (silver-paren-config-type ,(lambda (x) (string->symbol (cadr x)))))
         ("implementation" 
          (help "Set using implementation.") 
          (nargs 1)
          (silver-paren-config-name implementation)
          (silver-paren-config-type ,cadr))
         ("command" (nargs 1) (default "none"))
         ("options" (nargs *))))

     (define (%port-selector port-opt)
       (if (null? port-opt) (current-error-port) (car port-opt)))

     (define (%print-help . port-opt)
        (let ((port (%port-selector port-opt)))
         (display
                (niyarin-optparse-generate-help-text ARG-CONFIG '(program-name "Silver-paren")) port)))

     (define (%print-version . port-opt)
        (let ((port (%port-selector port-opt)))
            (display
                'DEVELOP port)))

     (define (%no-command-error . port-opt)
       (let ((port (%port-selector port-opt)))
         (silver-paren-error-mes "no command error." port)
         (newline port)
         (%print-help port)
         (exit #f)))

     (define (silver-paren-main . opt)
       (let ((parsed-option 
               (if (null? opt)
                   (niyarin-optparse-optparse ARG-CONFIG)
                   (niyarin-optparse-optparse ARG-CONFIG (car opt)))))
         (let ((command (cond ((assoc "command" parsed-option) => cadr)))
               (config
                 (silver-paren-config-apply-command-line-option
                     (silver-paren-config/default-config)
                     ARG-CONFIG
                     parsed-option)))
           (cond
            ((assoc "--help" parsed-option string=?) (%print-help))
            ((assoc "--version" parsed-option string=?) (%print-version))
            ((string=? command "none")
             (%no-command-error))
            (#t (silver-paren-command command parsed-option config));for debug
            (else 
              (with-exception-handler
                (lambda (ex)
                  (silver-paren-error-mes 
                    (error-object-message ex))
                  (exit #f))
                (lambda ()
                  (silver-paren-command command parsed-option config))))
            ))))))

(import 
  (silver-paren main))

(silver-paren-main)
