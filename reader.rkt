#lang racket/base

(require "lexer.rkt"
         "parser.rkt"
         syntax/strip-context)

(provide (rename-out [lox-read-syntax read-syntax]
                     [lox-get-info get-info]))

(define (lox-read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-context
   #`(module lox-mod lox/expander
       #,parse-tree)))

(define (lox-get-info port module line column offset)
  (λ (key default)
    (case key
      [(color-lexer) (dynamic-require 'lox/colorer 'color-lox)]
      [else default])))