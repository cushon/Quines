#!/usr/bin/env racket
#lang racket

(require (lib "string.ss" "srfi" "13"))

(define (twos-comp x)
  (cond
    [(= 1 (bitwise-and (arithmetic-shift x -15) 1))
     (format "-~a" (+ 1 (+ (expt 2 16) (bitwise-not x))))]
    [else x]))

(define quine
  (map (lambda (x)
         (string->number (list->string (drop (string->list x) 5))))
       (string-tokenize
        (file->string (vector-ref (current-command-line-arguments) 0)))))

(for-each
 (lambda (x)
   (local ((define o (bitwise-and (arithmetic-shift x -26) #b111111))
           (define s (bitwise-and (arithmetic-shift x -21) 31))
           (define t (bitwise-and (arithmetic-shift x -16) 31)))
     (cond
       [(zero? o)
        (local ((define d (bitwise-and (arithmetic-shift x -11) 31))
                (define f (bitwise-and x #b111111)))
          (display (match f
            [#b100000 (format "add $~a, $~a, $~a\n" d s t)]
            [#b100010 (format "sub $~a, $~a, $~a\n" d s t)]
            [#b011000 (format "mult $~a, $~a\n" s t)]
            [#b011001 (format "multu $~a, $~a\n" s t)]
            [#b011010 (format "div $~a, $~a\n" s t)]
            [#b011011 (format "divu $~a, $~a\n" s t)]
            [#b010000 (format "mfhi $~a\n" d)]
            [#b010010 (format "mflo $~a\n" d)]
            [#b010100 (format "lis $~a\n" d)]
            [#b101010 (format "slt $~a, $~a, $~a\n" d s t)]
            [#b101011 (format "sltu $~a, $~a, $~a\n" d s t)]
            [#b001000 (format "jr $~a\n" s)]
            [#b001001 (format "jalr $~a\n" s)]
            [_ (format ".word 0x~x ; dec: ~a, 0b~b\n" x x x)])))]
       [else
        (local ((define i (twos-comp (bitwise-and x #b1111111111111111))))
          (display (match o
            [#b100011 (format "lw $~a, ~a($~a)\n" t i s)]
            [#b101011 (format "sw $~a, ~a($~a)\n" t i s)]
            [#b000100 (format "beq $~a, $~a, ~a\n" s t i)]
            [#b000101 (format "bne $~a, $~a, ~a\n" s t i)]
            [_ (format ".word 0x~x ; dec: ~a, 0b~b\n" x x x)])))])))
 quine)

