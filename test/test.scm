(include "./test-sip-name-list.scm")

(import 
  (scheme base)
  (srfi 78) ;Lightweight testing
  (test-silver-paren name-list)) 

(begin
   (test-silver-paren-name-list)


   (check-report)
   )

