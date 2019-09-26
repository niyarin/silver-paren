(include  "sip-log.scm")

(define-library (silver-paren misc)
   (import (scheme base)
           (scheme write)
           (scheme case-lambda)
           (silver-paren log)
           (srfi 1);(scheme list)
           )

   (export silver-paren-misc-assoc-cadr-with-default 
           silver-paren-misc-object->string 
           silver-paren-misc-concatenate-path
           silver-paren-misc-tail-element-in-path 
           silver-paren-misc-create-dir)

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

      (define (silver-paren-misc-create-dir dirname out-sourcing-flag)
         (if out-sourcing-flag
           (silver-paren-log-out-command (string-append "create-dir" ">" dirname))
           (silver-paren-log-message "This program doesn't support creating directories.")))
        ))
