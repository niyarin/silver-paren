(define-library (niyarin rainbow write)
   (import (scheme base)
           (srfi 1)
           (scheme write))

   (export write-rainbow display-rainbow rainbow-write-current-color  rainbow-write-theme-test
           write-first-color display-first-color write-second-color display-second-color)

   (begin

     (define color-list
        (circular-list
            "\x1b[31m"
            "\x1b[32m"
            "\x1b[33m"
            "\x1b[34m"
            "\x1b[35m"
            "\x1b[36m"))

     (define rainbow-write-current-color
       (make-parameter color-list))

     (define default-color
        "\x1b[39m")

     (define (write-display-rainbow obj write/display . opt-port)
       (let ((port (if (null? opt-port) (current-input-port) (car opt-port))))
         (let loop ((obj obj)
                    (color-list (rainbow-write-current-color)))
           (cond
             ((and (list? obj) (not (null?  obj)))
                 (display (car color-list) port)
                 (display "(" port)
                 (display default-color port)


                 (let loop2 ((ls obj))
                   (cond
                     ((null? (cdr ls))
                        (loop (car ls) (cdr color-list)))
                     (else
                       (loop (car ls) (cdr color-list))
                       (display " " port)
                       (loop2 (cdr ls)))))

                 (display (car color-list) port)
                 (display ")" port)
                 (display default-color) port)

             ((vector? obj)
                 (display "#(" port)

                  (unless (zero? (vector-length obj))
                     (let loop2 ((index 0))
                        (if (= index (- (vector-length obj) 1))
                          (loop (vector-ref obj index) color-list)
                          (begin
                             (loop (vector-ref obj index) color-list)
                             (loop2 (+ index 1))))))

                 (display ")" port))
             (else
               (write/display obj port))))))

      (define (write-display-nth-color obj write/display caxr port)
        (display (caxr (rainbow-write-current-color)) port)
        (write/display obj port)
        (display default-color port))

      (define (write-rainbow obj . opt-port)
       (let ((port (if (null? opt-port) (current-output-port) (car opt-port))))
         (write-display-rainbow obj write port)))

      (define (display-rainbow obj . opt-port)
       (let ((port (if (null? opt-port) (current-output-port) (car opt-port))))
         (write-display-rainbow obj display port)))


      (define (write-first-color obj . opt-port)
         (let ((port (if (null? opt-port) (current-output-port) (car opt-port))))
           (write-display-nth-color obj write car port)))

      (define (display-first-color obj . opt-port)
         (let ((port (if (null? opt-port) (current-output-port) (car opt-port))))
           (write-display-nth-color obj display car port)))

      (define (write-second-color obj . opt-port)
         (let ((port (if (null? opt-port) (current-output-port) (car opt-port))))
           (write-display-nth-color obj write cadr port)))

      (define (display-second-color obj . opt-port)
         (let ((port (if (null? opt-port) (current-output-port) (car opt-port))))
           (write-display-nth-color obj display cadr port)))
      
      ))


;example
;
;(import (scheme base)
;        (scheme write)
;        (niyarin rainbow write))
;
;(display-rainbow '((list (list (list (list (list (list (list "123" "456")))))))))
;(newline)
