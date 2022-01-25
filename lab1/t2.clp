;1.2
(clear)
(deffacts F1 (x) (y) (z))
    ;Добавляем начальные факты
; x & y => v
(defrule R1 (and (x) (y)) => (assert (v)))

; y & z => w
(defrule R2 (and (y) (z)) => (assert (w)))

; v & w => u
(defrule R3 (and (v) (w)) => (assert (u)))

;Исполнение по шагам
;(x) (y) (z)
;(x) (y) (z) (w)
;(x) (y) (z) (w) (v)
;(x) (y) (z) (w) (v) (u)

