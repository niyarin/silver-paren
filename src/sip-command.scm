(include "./sip-error.scm")
(include "./sip-install.scm")
(include "./sip-name-list.scm")
(include "./sip-misc.scm")
(include "./sip-features.scm")
(include "./sip-log.scm")

(define-library (silver-paren command)
  (import 
    (scheme base)
    (scheme write)
    (silver-paren install)
    (silver-paren name-list)
    (silver-paren features)
    (silver-paren misc)
    (silver-paren log)
    (silver-paren error))
  (export silver-paren-command)
   
  (begin


   (define (%run-install-command command opt config)

       (let ((target-packages (cond ((assoc "options" opt) => cdr) (else '())))
             (edition-delimiter
               (silver-paren-misc-assoc-cadr-with-default
                 'edition-delimiter
                 config
                 ":edition")))
         (let ((package-name-list
                  (silver-paren-name-list-generate-name-list-list-from-option 
                    target-packages
                    edition-delimiter
                    )))

           (when (null? package-name-list)
               (silver-paren-error "No package is selected."))
           (silver-paren-install package-name-list edition-delimiter))))
    (define (%run-feature-command command opt config)
      (let* ((options
               (silver-paren-misc-assoc-cadr-with-default
                 'option
                 opt
                 '()))
             (sip-features 
              (if (null? options)
                (silver-paren-features)
                (silver-paren-features (car options)))))
        (silver-paren-display sip-features)))
      
    (define (silver-paren-command command opt config)
      (cond
        ((equal? command "install")
         (%run-install-command command opt config))
        ((equal? command "features")
          (%run-feature-command command opt config))
        (else 
            (silver-paren-error 
              (string-append 
                "undefined command \""  
                command
                "\"")))
      ))
    ))
