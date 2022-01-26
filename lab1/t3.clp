
; Считываем данные у пользователя
(defrule data-input
  (initial-fact)
=>
  (printout t "Days until exam: ")
  (bind ?days (read))
  (assert (days ?days))
  (printout t"Amount of work (%): ")
  (bind ?work (read))
  (assert (work ?work))
  (printout t"Temperature outside (c): ")
  (bind ?temp (read))
  (assert (temp ?temp))
  (printout t"Is it raining outside? (0 or 1): ")
  (bind ?rain (read))
  (assert (rain ?rain)) 
)  


;Если температура ниже 0 то погода 0
(defrule W1
	(temp ?temp)
	(rain ?rain)
	(test (< ?temp 0))
    =>
    (assert (wthr 0))
)

;Если температура больше 0 и меньше 10 и нет дождя то погода 1
(defrule W2
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 0)(< ?temp 10)) (= ?rain 0)) )
    =>
    (assert (wthr 1))
)

;Если температура больше 10 и меньше 20 и нет дождя то погода 2
(defrule W3
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 10)(< ?temp 20)) (= ?rain 0)) )
    =>
    (assert (wthr 2))
)

;Если температура больше и нет дождя то погода 3
(defrule W4
	(temp ?temp)
	(rain ?rain)
	(test (and (>= ?temp 20) (= ?rain 0)) )
    =>
    (assert (wthr 3))
)


;Если температура больше 0 и меньше 10 и идёт дождь то погода 0
(defrule W5
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 0)(< ?temp 10)) (= ?rain 1)) )
    =>
    (assert (wthr 0))
)

;Если температура больше 10 и меньше 20 и идёт дождь то погода 1
(defrule W6
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 10)(< ?temp 20)) (= ?rain 1)) )
    =>
    (assert (wthr 1))
)

;Если температура больше 20 и идёт дождь то погода 2
(defrule W7
	(temp ?temp)
	(rain ?rain)
	(test (and (>= ?temp 20) (= ?rain 1)) )
    =>
    (assert (wthr 2))
)

;Свободно время = количество дней умноженное на 10 минус колиество работы в процентах
;Предпологаем что за день работы можно сделать 10% работ
(defrule T1 
    (days ?days) 
    (work ?work) 
    (test (> ?work 0))
    =>
    (assert (ftime (- (* ?days 10) ?work)))
)

; Если работы нет то свободное время = 10000
(defrule T2 
    (work ?work) 
    (test (<= ?work 0))
    =>
    (assert (ftime 10000))
)

; ЕСли погода равна 0 то вывести сообщение что погода ужасная
(defrule SW1
    (wthr ?wthr) 
    (test (= ?wthr 0))
    => 
    (printout t "Weather is awful" crlf)
)

; если погода равна 1 то вывести сообщение что погода не очень хорошая
(defrule SW2 
    (wthr ?wthr) 
    (test (= ?wthr 1))
    => 
    (printout t "Weather is not good enough" crlf)
)

; если погода равна 2 то вывести сообщение что погода хорошая
(defrule SW3 
    (wthr ?wthr) 
    (test (= ?wthr 2))
    => 
    (printout t "Weather is good" crlf)
)

; если погода равна 3 то вывести сообщение что погода великолепная
(defrule SW4 
    (wthr ?wthr) 
    (test (= ?wthr 3))
    => 
    (printout t "Weather is wonderful" crlf)
)

; если свободное время меньше или равно 0 то вывести сообщение что ты отчислен
(defrule ST1 
    (ftime ?ftime) 
    (test (<= ?ftime 0))
    => 
    (printout t "Time is over you are expelled" crlf)
)

; если свободное время больше нуля и меньше 20 то вывести сообщение что ты имеешь немного времени
(defrule ST2 
    (ftime ?ftime) 
    (test (and (> ?ftime 0) (<= ?ftime 20)))
    => 
    (printout t "You don't have much time" crlf)
)

; если свободное время больше 20 и меньше 60 то вывести сообщение что ты имеешь немного лишнее времени
(defrule ST4 
    (ftime ?ftime) 
    (test (and (> ?ftime 20) (<= ?ftime 60)))
    => 
    (printout t "You have some spare time" crlf)
)

; если свободное время больше 60 и меньше 9999 то вывести сообщение что ты имеешь лишнее временя
(defrule ST5 
    (ftime ?ftime) 
    (test (and (> ?ftime 60) (<= ?ftime 9999)))
    => 
    (printout t "You have plenty of time" crlf)
)

; если свободное время больше 9999 то вывести сообщение что ты имеешь всё время мира
(defrule ST6 
    (ftime ?ftime) 
    (test (> ?ftime 9999) )
    => 
    (printout t "You have infinite amount of time" crlf)
)

; Вывести ответ "Делай что хочешь"
(defrule A1
    (ftime ?ftime)
    (test (> ?ftime 9999))
    =>
    (printout t "Do what you want")
)

; Вывести ответ "Нужно напрячься и поработать"
(defrule A2
    (ftime ?ftime)
    (test (<= ?ftime 0))
    =>
    (printout t "You should work like a hero")
)

; Вывести ответ "Нужно делат лабораторные"
(defrule A3 
    (ftime ?ftime) 
    (test (and (> ?ftime 0) (<= ?ftime 20)))
    => 
    (printout t "You should do labs!" crlf)
)

; Вывести ответ "Потрать некоторое время на лабораторные"
(defrule A4 
    (ftime ?ftime) 
    (wthr ?wthr)
    (test (and (> ?ftime 20) (<= ?ftime 60)))
    (test (and (> ?wthr -1) (<= ?wthr 1)))
    => 
    (printout t "Spend some time on your lab" crlf)
)

; Вывести ответ "Ты можешь позволить себе прогуляться"
(defrule A5 
    (ftime ?ftime) 
    (wthr ?wthr)
    (test (and (> ?ftime 20) (<= ?ftime 60)))
    (test (and (> ?wthr 1) (<= ?wthr 3)))
    => 
    (printout t "You can go on a little walk" crlf)
)

; Вывести ответ "Ты можешь сделать и попозже"
(defrule A6 
    (ftime ?ftime) 
    (wthr ?wthr)
    (test (and (> ?ftime 60) (<= ?ftime 9999)))
    => 
    (printout t "You can relax and do your labs later" crlf)
)