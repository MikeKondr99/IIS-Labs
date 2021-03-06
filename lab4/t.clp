;; Модуль MAIN

(defmodule MAIN 
    (export deftemplate status)
)


;Шаблон для ситуации
(deftemplate MAIN::status 
    (slot  farmer-location  (type SYMBOL)  (allowed-symbols shore-1 shore-2))
    (slot fox-location  (type SYMBOL)  (allowed-symbols shore-1 shore-2))
    (slot goat-location  (type SYMBOL)  (allowed-symbols shore-1 shore-2))
    (slot cabbage-location  (type SYMBOL)  (allowed-symbols shore-1 shore-2))
    (slot  parent  (type FACT-ADDRESS SYMBOL)  (allowed-symbols no-parent))
    (slot  search-depth  (type INTEGER) (range 1 ?VARIABLE))
    (slot last-move  (type SYMBOL) (allowed-symbols no-move alone fox goat cabbage))
)

;начальная позиция
(deffacts MAIN::initial-positions
    (status 
        (search-depth 1)
        (parent no-parent)
        (farmer-location shore-1)
        (fox-location shore-1)
        (goat-location shore-1)
        (cabbage-location shore-1)
        (last-move no-move)
    )
)

(deffacts MAIN::opposites
    (opposite-of shore-1 shore-2)
    (opposite-of shore-2 shore-1)
)

;Правило взять с собой лису
(defrule MAIN::move-with-fox 		    		     
    ?node <- (status (search-depth ?num) 
        (farmer-location ?side)		     
        (fox-location ?side)
    )
    (opposite-of ?side ?nside)		     
    =>
    (duplicate ?node 						
        (search-depth =(+ 1 ?num))  
        (parent ?node)		  
        (farmer-location ?nside)	  		
        (fox-location ?nside)	  		
        (last-move fox)
    )
)		  		

;Правило взять с собой капусту
(defrule MAIN::move-with-cabbage 		    		     
    ?node <- (status (search-depth ?num) 
        (farmer-location ?side)		     
        (cabbage-location ?side)
    )
    (opposite-of ?side ?nside)		     
    =>
    (duplicate ?node 						
        (search-depth =(+ 1 ?num))  
        (parent ?node)		  
        (farmer-location ?nside)	  		
        (cabbage-location ?nside)	  		
        (last-move cabbage)
    )
)

;Правило взять с собой козу
(defrule MAIN::move-with-goat
    ?node <- (status (search-depth ?num) 
        (farmer-location ?side)		     
        (goat-location ?side)
    )
    (opposite-of ?side ?nside)		     
    =>
    (duplicate ?node 						
        (search-depth =(+ 1 ?num))  
        (parent ?node)		  
        (farmer-location ?nside)	  		
        (goat-location ?nside)	  		
        (last-move goat)
    )
)		  		

;Переплыть одному
(defrule MAIN::move-alone
    ?node <- (status (search-depth ?num) 
        (farmer-location ?side)
    )
    (opposite-of ?side ?nside)		     
    =>
    (duplicate ?node 						
        (search-depth =(+ 1 ?num))  
        (parent ?node)		  
        (farmer-location ?nside)	  		
        (last-move alone)
    )
)

;; END MAIN


;; MODULE CONSTRAINT

(defmodule CONSTRAINTS 
    (import MAIN deftemplate status)
)

;Недопустить лиса ест козу
(defrule CONSTRAINTS::fox-eats-goat 
    (declare (auto-focus TRUE))
    ?node <- (status 
        (farmer-location ?side1)
        (fox-location ?side2 & ~?side1)
        (goat-location ?side2))
    => (retract ?node)
)

;Недопустить коза ест капусту
(defrule CONSTRAINTS::goat-eats-cabbage 
    (declare (auto-focus TRUE))
    ?node <- (status 
        (farmer-location ?side1)
        (goat-location ?side2 & ~?side1)
        (cabbage-location ?side2))
    => (retract ?node)
)

;Недопустить путь который уже был найден но с более длинным путём
(defrule CONSTRAINTS::circular-path 
    (declare (auto-focus TRUE))
    (status 
        (search-depth ?sd1)    	
        (farmer-location ?fs)      		
        (fox-location ?xs)
        (goat-location ?gs)
        (cabbage-location ?cs)
    )
    ?node <- (status 
        (search-depth ?sd2 & :(< ?sd1 ?sd2)) 
        (farmer-location ?fs)
        (fox-location ?xs)
        (goat-location ?gs)
        (cabbage-location ?cs))
    => (retract ?node)
)

;; END CONSTRAINT

;; MODULE SOLUTION

(defmodule SOLUTION 
    (import MAIN deftemplate status)
    (import MAIN defglobal *?initial-missionaries*)
    (import MAIN defglobal *?initial-cannibals*)
)

; Шаблон движений
(deftemplate SOLUTION::moves
   (slot id (type FACT-ADDRESS SYMBOL) (allowed-symbols no-parent)) 
   (multislot moves-list (type SYMBOL) (allowed-symbols no-move alone fox goat cabbage))
)

; Найти правильный ответ
(defrule SOLUTION::goal-test 
    (declare (auto-focus TRUE))
    ?node <- (status 
        (parent ?parent)
        (last-move ?move))
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
    ?mv <- (moves (id no-parent) (moves-list no-move $?m))
    =>
    (retract ?mv)
    (printout t  "Solution found: " t)
    (bind ?length (length ?m))
    (bind ?i 1)
    (bind ?shore shore-2)
    (while (<= ?i ?length)
        (bind ?thing (nth ?i ?m))
        (if (eq ?thing alone)
            then (printout t "  Farmer moves alone to " ?shore "." t) 
            else (printout t "  Farmer moves with " ?thing " to " ?shore "." t)
        )
        (if (eq ?shore shore-1)
            then (bind ?shore shore-2)
            else (bind ?shore shore-1)
        )
        (bind ?i (+ 1 ?i))
    )
)



;; END SOLUTION