
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


;Погода без дождя
(defrule W1
	(temp ?temp)
	(rain ?rain)
	(test (< ?temp 0))
    =>
    (assert (wthr 0))
)

(defrule W2
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 0)(< ?temp 10)) (= ?rain 0)) )
    =>
    (assert (wthr 1))
)

(defrule W3
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 10)(< ?temp 20)) (= ?rain 0)) )
    =>
    (assert (wthr 2))
)

(defrule W4
	(temp ?temp)
	(rain ?rain)
	(test (and (>= ?temp 20) (= ?rain 0)) )
    =>
    (assert (wthr 3))
)


;Погода с дождем
(defrule W5
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 0)(< ?temp 10)) (= ?rain 1)) )
    =>
    (assert (wthr 0))
)

(defrule W6
	(temp ?temp)
	(rain ?rain)
	(test (and(and(>= ?temp 10)(< ?temp 20)) (= ?rain 1)) )
    =>
    (assert (wthr 1))
)

(defrule W7
	(temp ?temp)
	(rain ?rain)
	(test (and (>= ?temp 20) (= ?rain 1)) )
    =>
    (assert (wthr 2))
)

;Высчитаем количество свободных дней 
(defrule T1 
    (days ?days) 
    (work ?work) 
    (test (> ?work 0))
    =>
    (assert (ftime (- (* ?days 10) ?work)))
)

(defrule T2 
    (work ?work) 
    (test (<= ?work 0))
    =>
    (assert (ftime 10000))
)

;Вывод сообщений о погоде
(defrule SW1
    (wthr ?wthr) 
    (test (= ?wthr 0))
    => 
    (printout t "Weather is awful" crlf)
)

(defrule SW2 
    (wthr ?wthr) 
    (test (= ?wthr 1))
    => 
    (printout t "Weather is not good enough" crlf)
)

(defrule SW3 
    (wthr ?wthr) 
    (test (= ?wthr 2))
    => 
    (printout t "Weather is good" crlf)
)

(defrule SW4 
    (wthr ?wthr) 
    (test (= ?wthr 3))
    => 
    (printout t "Weather is wonderful" crlf)
)

;Вывод сообщение о количестве времени
(defrule ST1 
    (ftime ?ftime) 
    (test (<= ?ftime 0))
    => 
    (printout t "Time is over you are expelled" crlf)
)

(defrule ST2 
    (ftime ?ftime) 
    (test (and (> ?ftime 0) (<= ?ftime 20)))
    => 
    (printout t "You don't have much time" crlf)
)

(defrule ST4 
    (ftime ?ftime) 
    (test (and (> ?ftime 20) (<= ?ftime 60)))
    => 
    (printout t "You have some spare time" crlf)
)

(defrule ST5 
    (ftime ?ftime) 
    (test (and (> ?ftime 60) (<= ?ftime 9999)))
    => 
    (printout t "You have plenty of time" crlf)
)

(defrule ST6 
    (ftime ?ftime) 
    (test (> ?ftime 9999) )
    => 
    (printout t "You have infinite amount of time" crlf)
)

; выводим ответ что-же делать
(defrule A1
    (ftime ?ftime)
    (test (> ?ftime 9999))
    =>
    (printout t "Do what you want")
)

(defrule A2
    (ftime ?ftime)
    (test (<= ?ftime 0))
    =>
    (printout t "You should work like a hero")
)


(defrule A3 
    (ftime ?ftime) 
    (test (and (> ?ftime 0) (<= ?ftime 20)))
    => 
    (printout t "You should do labs!" crlf)
)

(defrule A4 
    (ftime ?ftime) 
    (wthr ?wthr)
    (test (and (> ?ftime 20) (<= ?ftime 60)))
    (test (and (> ?wthr -1) (<= ?wthr 1)))
    => 
    (printout t "Spend some time on your lab" crlf)
)

(defrule A5 
    (ftime ?ftime) 
    (wthr ?wthr)
    (test (and (> ?ftime 20) (<= ?ftime 60)))
    (test (and (> ?wthr 1) (<= ?wthr 3)))
    => 
    (printout t "You can go on a little walk" crlf)
)

(defrule A6 
    (ftime ?ftime) 
    (wthr ?wthr)
    (test (and (> ?ftime 60) (<= ?ftime 9999)))
    => 
    (printout t "You can relax and do your labs later" crlf)
)