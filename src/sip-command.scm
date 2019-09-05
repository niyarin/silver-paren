(include "./sip-error.scm")
(include "./sip-install.scm")

(define-library (silver-paren command)
  (import 
    (scheme base)
    (scheme write)
    (silver-paren install)
    (silver-paren error))
  (export silver-paren-command)
   
  (begin
    (define (silver-paren-command command opt)
      (cond
        ((equal? command "install")
         (let ((target-packages (cond ((assoc "options" opt) => cdr) (else '()))))
           (when (null? target-packages)
               (silver-paren-error "No package is selected."))
           (silver-paren-install target-packages opt)))
        (else 
            (silver-paren-error 
              (string-append 
                "undefined command \""  
                command
                "\"")))
      ))
    ))
