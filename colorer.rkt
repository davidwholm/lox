#lang racket/base

(require brag/support
         (prefix-in a: "lex-abbrevs.rkt")
         racket/match)

(provide color-lox)

(define (lexeme->parenthesis-type lexeme)
  (match lexeme
    [(or "(" "{") '|(|]
    [(or ")" "}") '|)|]))

(define color-lox
  (lexer
   [(eof) (values lexeme 'eof #f #f #f)]
   [(:or a:identifier
         a:operator
         a:keyword) (values lexeme 'symbol #f (pos lexeme-start) (pos lexeme-end))]
   [(:or a:comment a:block-comment) (values lexeme 'comment #f (pos lexeme-start) (pos lexeme-end))]
   [(:or a:number a:string) (values lexeme 'constant #f (pos lexeme-start) (pos lexeme-end))]
   [a:punctuation (values lexeme 'other #f (pos lexeme-start) (pos lexeme-end))]
   [a:parenthesis (values lexeme 'parenthesis (lexeme->parenthesis-type lexeme) (pos lexeme-start) (pos lexeme-end))]
   [whitespace (values lexeme 'white-space #f (pos lexeme-start) (pos lexeme-end))]))