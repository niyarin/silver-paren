(include "./optparse/niyarin_optparse.scm")
(include "./sp-error.scm")

(define-library (silver-paren main)
   (import (scheme base)
           (scheme write)
           (scheme process-context)
           (silver-paren error)
           (niyarin optparse))
   (export silver-paren-main)

   (begin 
     (define *ARG-CONFIG*
       '(("--help" "-h" (help "Display a help message and exit."))
         ("--version" "-v" (help "Display Silver-paren's version and exit."))
         ("command" (nargs 1) (default "none")
         ("options" (nargs *)))))

     (define (internal-port-selector port-opt)
       (if (null? port-opt) (current-error-port) (car port-opt)))

     (define (internal-print-help . port-opt)
        (let ((port (internal-port-selector port-opt)))
         (display
                (niyarin-optparse-generate-help-text *ARG-CONFIG* '(program-name "Silver-paren")) port)))

     (define (internal-print-version . port-opt)
        (let ((port (internal-port-selector port-opt)))
            (display
                'DEVELOP port)))

     (define (internal-no-command-error . port-opt)
       (let ((port (internal-port-selector port-opt)))
         (silver-paren-error-mes "no command error." port)
         (newline port)
         (internal-print-help port)
         (exit #f)))

     (define (silver-paren-main . opt)
       (let ((parsed-option 
               (if (null? opt)
                   (niyarin-optparse-optparse *ARG-CONFIG*)
                   (niyarin-optparse-optparse *ARG-CONFIG* (car opt)))))
         (let ((command (cond ((assoc "command" parsed-option) => cadr))))
           (cond
            ((assoc "--help" parsed-option string=?) (internal-print-help))
            ((assoc "--version" parsed-option string=?) (internal-print-version))
            ((string=? command "none")
             (internal-no-command-error))))))))

(import 
  (silver-paren main))

(silver-paren-main)
