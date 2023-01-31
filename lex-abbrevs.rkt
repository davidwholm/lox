#lang racket/base

(require brag/support)

(provide parenthesis
         punctuation
         operator
         keyword
         identifier
         string
         number
         comment
         block-comment)

(define-lex-abbrevs
  [parenthesis (:or "(" ")" "{" "}")]
  [punctuation (:or "," "." ";")]
  [operator (:or "!" "!=" "=" "==" ">" ">=" "<" "<=" "-" "+" "/" "*")]
  [keyword (:or "and" "class" "else" "false" "fun" "for" "if" "or" "print" "return" "super" "this" "var" "while" "true" "false" "nil")]
  [identifier (:: alphabetic (:* (:or alphabetic numeric)))]
  [string (from/to "\"" "\"")]
  [number (:: (:/ "1" "9") (:* numeric))]
  [comment (from/to "//" "\n")]
  [block-comment (from/to "/*" "*/")])