
; Шаблон для блока
(deftemplate block 
    (slot size  (type INTEGER)                )
    (slot place (type SYMBOL ) (default heap) )
    (slot color (type SYMBOL )                )
)

; Шаблон башни
(deftemplate tower 
    (multislot blocks (type SYMBOL))
)

; Шаблон под-цели
(deftemplate goal
    (slot task (type SYMBOL))
)

; объявляем блоки по варианту
(deffacts var1
    (block (size 10) (color blue  ))
    (block (size 8)  (color green ))
    (block (size 18) (color red   ))
    (block (size 15) (color yellow))
    (tower)
)

; Начальная задача найти наибольший кубик
(defrule start
    (initial-fact)
    =>
    (assert (goal (task find)))
)

; Поиск самого большого блока в куче
(defrule Find 
    ?g <- (goal (task find))
    ?b <- (block (size ?s1               ) (place heap) )
    (not  (block (size ?s2 & :(> ?s2 ?s1)) (place heap) ) )
    =>
    (modify ?b (place hand))
    (modify ?g (task build))
)

; Добавление кубика из руки на верх башни
(defrule Build 
    ?g <- (goal (task build))
    ?t <- (tower (blocks $?rest))
    ?b <- (block (size ?s1) (place hand) (color ?c) )
    =>
    (modify ?b (place tower))
    (modify ?t (blocks ?c ?rest))
    (modify ?g (task find))
)

; Вывод цветов башни сверху вниз
(defrule Print 
    ?t <- (tower (blocks $?rest))
    (test (= (length ?rest) 4))
    =>
    (progn$ (?c ?rest) (printout t ?c crlf))
)


