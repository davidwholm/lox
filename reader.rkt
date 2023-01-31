#lang racket/base

(require "lexer.rkt"
         "parser.rkt"
         syntax/strip-context)

(provide (rename-out [lox-read-syntax read-syntax]))

(define (lox-read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-context
   #`(module lox-mod lox/expander
       #,parse-tree)))