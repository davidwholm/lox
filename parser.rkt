#lang brag

program : expression

@expression : literal | unary | binary | grouping
literal : NUMBER | STRING | "true" | "false" | "nil"
@grouping : /"(" expression /")"
unary : unary-operator expression
unary-operator : "-" | "!"
binary : expression binary-operator expression
binary-operator : "==" | "!=" | "<" | "<=" | ">" | ">=" | "+" | "-" | "*" | "/"