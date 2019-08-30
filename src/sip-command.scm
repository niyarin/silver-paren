(include "./sip-error.scm")

(define-library (silver-paren command)
  (import 
    (scheme base)
    (scheme write)
    (silver-paren error))
  (export silver-paren-command)
   
  (begin
    (define (silver-paren-command command opt)
      (cond
        ((equal? command "install")
         )
        (else 
            (silver-paren-error 
              (string-append 
                "undefined command \""  
                command
                "\"")))
      ))
    ))
