
;; MODULE MAIN

(defmodule MAIN 
    (export deftemplate status)
)

(deftemplate MAIN::status 
    (slot shore-1-miss  (type INTEGER)             (range 0 ?VARIABLE))
    (slot shore-1-cann  (type INTEGER)             (range 0 ?VARIABLE))
    (slot shore-2-miss  (type INTEGER)             (range 0 ?VARIABLE))
    (slot shore-2-cann  (type INTEGER)             (range 0 ?VARIABLE))
    (slot boat-location (type SYMBOL)              (allowed-values shore-1 shore-2))
    (slot search-depth  (type INTEGER)             (range 1 ?VARIABLE)) 
    (slot parent        (type FACT-ADDRESS SYMBOL) (allowed-symbols no-parent)) 
    (slot last-move     (type STRING))
)

(defglobal MAIN
   ?*initial-missionaries* = 3
   ?*initial-cannibals* = 3
)

(deffacts MAIN::boat-information 
   (boat-can-hold 2)
)

(deffacts MAIN::initial-positions
    (status
        (shore-1-miss ?*initial-missionaries*)
        (shore-1-cann ?*initial-cannibals*)
        (shore-2-miss 0)
        (shore-2-cann 0)
        (boat-location shore-1)
        (search-depth 1)
        (parent no-parent)
        (last-move "No move.")
    )
)


(deffunction MAIN::move-string (?miss ?cann ?shore)
    (switch ?miss
        (case 0 then
            (if (eq ?cann 1) 		
                then (format nil "Move 1 cannibal to %s.%n" ?shore)
                else (format nil "Move %d cannibals to %s.%n" ?cann ?shore)))
        (case 1 then
            (switch ?cann		
                (case 0 then			
                    (format nil "Move 1 missionary to %s.%n" ?shore))
                (case 1 then
                    (format nil "Move 1 missionary and 1 cannibal to %s.%n" ?shore))
                (default then
                    (format nil "Move 1 missionary and %d cannibals to %s.%n"
                ?cann ?shore))))
        (default
            (switch ?cann
                (case 0 then
                    (format nil "Move %d missionaries to %s.%n" ?miss ?shore))
                (case 1 then
                    (format nil "Move %d missionaries and 1 cannibal to %s.%n" ?miss ?shore))
                (default then
                    (format nil "Move %d missionary and %d cannibals to %s.%n" ?miss ?cann ?shore))))))

(defrule MAIN::shore-1-move
    ?node <- (status
        (shore-1-miss ?s1m)
        (shore-1-cann ?s1c)
        (shore-2-miss ?s2m)
        (shore-2-cann ?s2c)
        (boat-location shore-1)
        (search-depth ?sd)
    )
    (boat-can-hold ?limit)
    =>
    (bind ?max-miss (min ?s1m ?limit))
    (loop-for-count (?miss 0 ?max-miss)
        (bind ?min-cann (max 0    (- 1 ?miss)))
        (bind ?max-cann (min ?s1c (- ?limit ?miss)))
        (loop-for-count (?cann ?min-cann ?max-cann)
            (duplicate ?node
                (shore-1-miss  (- ?s1m ?miss))
                (shore-1-cann  (- ?s1c ?cann))
                (shore-2-miss  (+ ?s2m ?miss))
                (shore-2-cann  (+ ?s2c ?cann))
                (boat-location shore-2)
                (search-depth  (+ ?sd 1))
                (parent        ?node)
                (last-move     (move-string ?miss ?cann shore-2))
            )
        )
    )
)

(defrule MAIN::shore-2-move
    ?node <- (status
        (shore-1-miss ?s1m)
        (shore-1-cann ?s1c)
        (shore-2-miss ?s2m)
        (shore-2-cann ?s2c)
        (boat-location shore-2)
        (search-depth ?sd)
    )
    (boat-can-hold ?limit)
    =>
    (bind ?max-miss (min ?s2m ?limit))
    (loop-for-count (?miss 0 ?max-miss)
        (bind ?min-cann (max 0    (- 1 ?miss)))
        (bind ?max-cann (min ?s2c (- ?limit ?miss)))
        (loop-for-count (?cann ?min-cann ?max-cann)
            (duplicate ?node
                (shore-1-miss  (+ ?s1m ?miss))
                (shore-1-cann  (+ ?s1c ?cann))
                (shore-2-miss  (- ?s2m ?miss))
                (shore-2-cann  (- ?s2c ?cann))
                (boat-location shore-1)
                (search-depth  (+ ?sd 1))
                (parent        ?node)
                (last-move     (move-string ?miss ?cann shore-1))
            )
        )
    )
)

;TODO (?s1m, ?s1c, ?s2m и ?s1c)  опечатка в методичке

;; END MAIN

;; MODULE CONSTRAINT

(defmodule CONSTRAINTS 
    (import MAIN deftemplate status)
)

;Миссионеров съели на первом берегу
(defrule CONSTRAINTS::fail-shore-1
    (declare (auto-focus TRUE))
    ?node <- (status 
        (boat-location shore-2)
        (shore-1-miss ?m)
        (shore-1-cann ?c)
    )   
    (test (< ?m ?c))
    (test (> ?m  0))
    => (retract ?node)
)

;Миссионеров съели на втором берегу
(defrule CONSTRAINTS::fail-shore-2
    (declare (auto-focus TRUE))
    ?node <- (status 
        (boat-location shore-1)
        (shore-2-miss ?m)
        (shore-2-cann ?c)
    )
    (test (< ?m ?c))
    (test (> ?m  0))
    => (retract ?node)
)

;Недопустить путь который уже был найден но с более длинным путём
(defrule CONSTRAINTS::circular-path 
    (declare (auto-focus TRUE))
    (status
        (shore-1-miss ?s1m)
        (shore-1-cann ?s1c)
        (shore-2-miss ?s2m)
        (shore-2-cann ?s2c)
        (boat-location ?s)
        (search-depth ?sd1)
    )
    ?node <- (status
        (shore-1-miss ?s1m)
        (shore-1-cann ?s1c)
        (shore-2-miss ?s2m)
        (shore-2-cann ?s2c)
        (boat-location ?s)
        (search-depth ?sd2 & :(> ?sd2 ?sd1))
    )
    => (retract ?node)
)

;; END CONSTRAINT

;; MODULE SOLUTION

(defmodule SOLUTION 
    (import MAIN deftemplate status)
)

; Шаблон движений
(deftemplate SOLUTION::moves
   (slot id (type FACT-ADDRESS SYMBOL) (allowed-symbols no-parent)) 
   (multislot moves-list (type STRING))
)

; Найти правильный ответ
(defrule SOLUTION::goal-test 
    (declare (auto-focus TRUE))
    ?node <- (status 
        (shore-1-miss 0)
        (shore-1-cann 0)
        (shore-2-miss 3)
        (shore-2-cann 3)
        (boat-location shore-2)
        (parent ?parent)
        (last-move ?move)
    )
    =>
    (retract ?node)
    (assert (moves (id ?parent) (moves-list ?move)))
)

; Построить ответ
(defrule SOLUTION::build-solution
    ?node <- (status 
        (parent ?parent)
        (last-move ?move)
    )
    ?mv <- (moves (id ?node) (moves-list $?rest))
    =>
    (modify ?mv (id ?parent) (moves-list ?move ?rest))
)


; Вывести ответ
(defrule SOLUTION::print-solution 
    ?mv <- (moves (id no-parent) (moves-list "No move." $?m))
    =>
    (retract ?mv)
    (printout t t  "Solution found: " t t)
    (progn$ (?move ?m) (printout t ?move))
)



;; END SOLUTION