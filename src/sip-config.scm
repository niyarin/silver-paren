(define-library (silver-paren config)
   (import (scheme base)
           (srfi 1));scheme list

   (export silver-paren-default-config silver-paren-config-apply-command-line-option)

   (begin
      (define INTERNAL-DEFAULT-CONFIG
        '((edition-delimiter ":edition")
          ))

      (define (silver-paren-default-config)
        (list-copy INTERNAL-DEFAULT-CONFIG))

      (define (silver-paren-config-apply-command-line-option base-config arg-config option)
        ;TODO! ERROR CHECK => (config-type opt) 
         (let ((fold-fun
                 (lambda (opt res)
                   (let* ((is-config-option 
                            (cond
                              ((assoc (car opt) arg-config))
                              (else #f)))
                          (config-name
                            (if is-config-option
                              (cond 
                                ((not is-config-option)
                                 #f)
                                ((assq 'silver-paren-config-name is-config-option)
                                 => cadr)
                                (else
                                  #f))))
                          (config-type
                            (if is-config-option
                              (cond 
                                ((not is-config-option)
                                 #f)
                                ((assq 'silver-paren-config-type is-config-option)
                                 => cadr)
                                (else 
                                  #f)))))
                         (if config-name
                            (cons 
                              (list 
                                config-name
                                (config-type opt))
                              res)
                            res)
                         ))))
         (fold
           fold-fun
           '()
           option)))

      ))
