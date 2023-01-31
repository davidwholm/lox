#lang racket/base

(require brag/support
         racket/function)

(provide make-tokenizer)

(define-lex-abbrevs
  [punctuation (:or "(" ")" "{" "}" "," "." ";")]
  [operator (:or "!" "!=" "=" "==" ">" ">=" "<" "<=" "-" "+" "/" "*")]
  [keyword (:or "and" "class" "else" "false" "fun" "for" "if" "or" "print" "return" "super" "this" "var" "while" "true" "false" "nil")]
  [identifier (:: alphabetic (:* (:or alphabetic numeric)))]
  [string (:: #\" (:* (complement #\")) #\")]
  [number (:: (:/ "1" "9") (:* numeric))]
  [comment (:: "//" (:* (complement #\newline)) #\newline)]
  [block-comment (:: "/*" (:* (complement "*/")) "*/")])

(define lox-lexer
  (lexer-srcloc
   [(:or punctuation operator keyword) (token lexeme (string->symbol lexeme))]
   [identifier (token 'IDENTIFIER (string->symbol lexeme))]
   [string (token 'STRING (trim-ends "\"" lexeme "\""))]
   [number (token 'NUMBER (string->number lexeme))]
   [(:or comment block-comment whitespace) (lox-lexer input-port)]))

(define (make-tokenizer port [path #f])
  (port-count-lines! port)
  (lexer-file-path path)
  (thunk (lox-lexer port)))