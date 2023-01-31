#lang racket/base

(require syntax/parse/define
         (for-syntax racket/base
                     racket/function))

(provide (rename-out [lox-module-begin #%module-begin]) #%datum #%top
         program literal binary unary binary-operator unary-operator)

(begin-for-syntax
  (define operator-table
    (hash '! not
          '+ +
          '- -
          '* *
          '/ /
          '< <
          '> >
          '<= <=
          '>= >=
          '!= (negate equal?)
          '== equal?)))

(define-syntax-parser define-passthrough-parser
  [(_ name:id input)
   (syntax/loc this-syntax
     (define-syntax-parser name
       [(_ input)
        (syntax/loc this-syntax
          input)]))])

(define-syntax-parser define-passthrough-parsers
  [(_ (name:id input)
      ...+)
   (syntax/loc this-syntax
     (begin
       (define-passthrough-parser name input)
       ...))])

(define-syntax-parser define-syntax-parsers
  [(_ (parser ...+)
      parse-spec ...+)
   (syntax/loc this-syntax
     (begin
       (define-syntax-parser parser
         parse-spec ...)
       ...))])

(define-syntax-parser lox-module-begin
  [(_ expr)
   #'(#%module-begin
      expr)])

(define-syntax-parser program
  [(_ expr:expr ...)
   (syntax/loc this-syntax
     (begin
       expr ...))])

(define-syntax-parser literal
  [(_ (~or e:number
           e:string))
   (syntax/loc this-syntax
     e)]
  [(_ (~datum true))
   (syntax/loc this-syntax
     #t)]
  [(_ (~datum false))
   (syntax/loc this-syntax
     #f)]
  [(_ (~datum nil))
   (syntax/loc this-syntax
     'nil)])

(define-syntax-parser binary
  [(_ rand1:expr rator:expr rand2:expr)
   (syntax/loc this-syntax
     (rator rand1 rand2))])

(define-syntax-parser unary
  [(_ rator:expr rand:expr)
   (syntax/loc this-syntax
     (rator rand))])

(define-syntax-parsers (binary-operator unary-operator)
  [(_ op)
   (define op-trans (hash-ref operator-table (syntax-e #'op)))
   (quasisyntax/loc this-syntax
     #,op-trans)])