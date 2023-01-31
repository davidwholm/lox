#lang racket/base

(require brag/support
         racket/function
         (prefix-in a: "lex-abbrevs.rkt"))

(provide make-tokenizer)

(define lox-lexer
  (lexer-srcloc
   [(:or a:punctuation a:parenthesis a:operator a:keyword) (token lexeme (string->symbol lexeme))]
   [a:identifier (token 'IDENTIFIER (string->symbol lexeme))]
   [a:string (token 'STRING (trim-ends "\"" lexeme "\""))]
   [a:number (token 'NUMBER (string->number lexeme))]
   [(:or a:comment a:block-comment whitespace) (lox-lexer input-port)]))

(define (make-tokenizer port [path #f])
  (port-count-lines! port)
  (lexer-file-path path)
  (thunk (lox-lexer port)))