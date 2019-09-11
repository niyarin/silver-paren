(include "./test-sip-name-list.scm")
(include "./test-sip-misc.scm")

(import 
  (scheme base)
  (srfi 78) ;Lightweight testing
  (test-silver-paren name-list)
  (test-silver-paren misc)
  ) 

(begin
   (test-silver-paren-name-list)
   (test-silver-paren-misc)


   (check-report)
   )

