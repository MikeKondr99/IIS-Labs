
; Считываем данные у пользователя
(defrule data-input
  (initial-fact)
=>
  (printout t crlf "Vvedite chislo dnei do zacheta (tseloe znachenie): ")
  (bind ?days (read))
  (assert (days ?days))
  (printout t crlf "Vvedite chislo nesdelannyh laboratornyh rabot (v %) ")
  (bind ?works (read))
  (assert (work ?work))
  (printout t crlf "Vvedite temperaturu na ulitse: ")
  (bind ?temp (read))
  (assert (temp ?temp))
  (printout t crlf "Est' li na ulitse osadki? (da - 1/net - 0): ")
  (bind ?rain (read))
  (assert (rain ?rain))  
  (printout t crlf "Is there any white rabbit? (da - 1/net - 0) //HASN'T Realized: "))

; если works 0    Всё сделано
(defrule R1
	(days ?days)
	(works ?works)
	(test (= ?works 0)) 
=>
(printout t crlf crlf "Vse uzhe sdelano." crlf)
(assert (freetime "infinity"))
(assert (freetimecnst 0)))

; days 5..7  works 0..50 Времени много
(defrule R2
	(days ?days)
	(works ?works)
	(test (and (and(> ?days 5) (<= ?days 7)) (and (<= ?works 50) (> ?works 0) ))) 
=>
(printout t crlf crlf "Svobodnogo vremeni mnogo" crlf)
(assert (freetime "mnogo"))
(assert (freetimecnst 1)))

; days 5..7 works 50..100 Времени не очень много
(defrule R3
	(days ?days)
	(works ?works)
	(test (and (and(> ?days 5) (<= ?days 7)) (and (<= ?works 100) (> ?works 50) )))
=>
(printout t crlf crlf "Svobodnogo vremeni ne ochen' mnogo" crlf)
(assert (freetime "ne_ochen"))
(assert (freetimecnst 2)))

; days 3..5 works 0..50 Времени много
(defrule R4
	(days ?days)
	(works ?works)
	(test (and (and(> ?days 3) (<= ?days 5)) (and (<= ?works 50) (> ?works 0) ))) 
=>
(printout t crlf crlf "Svobodnogo vremeni mnogo" crlf)
(assert (freetime "mnogo"))
(assert (freetimecnst 1)))

; days 3..5 works 50..100 Времени не очень много
(defrule R5
	(days ?days)
	(works ?works)
	(test (and (and(> ?days 3) (<= ?days 5)) (and (<= ?works 100) (> ?works 50) ))) 
=>
(printout t crlf crlf "Svobodnogo vremeni ne ochen' mnogo" crlf)
(assert (freetime "ne_ochen"))
(assert (freetimecnst 2)))

; days 3 works 0..50 Времени не очень много
(defrule R6
	(days ?days)
	(works ?works)
	(test (and (= ?days 3) (and ( > ?works 0 ) (<= ?works 50) )))
=>
(printout t crlf crlf "Svobodnogo vremeni ne ochen' mnogo" crlf)
(assert (freetime "ne_ochen"))
(assert (freetimecnst 2)))

; days 3 works 50..100 Времени совсем немного. Пора делать.
(defrule R7
	(days ?days)
	(works ?works)
	(test (and (= ?days 3) (and ( > ?works 50 ) (<= ?works 100) )))
=>
(printout t crlf crlf "Svobodnogo vremeni sovsem nemnogo. Pora delat'" crlf)
(assert (freetime "pora_dalat"))
(assert (freetimecnst 3)))

; days 2 works 0..33 Времени не очень немного
(defrule R8
	(days ?days)
	(works ?works)
	(test (and (= ?days 2) (and ( > ?works 0 ) (<= ?works 33) )))
=>
(printout t crlf crlf "Svobodnogo vremeni ne ochen' mnogo" crlf)
(assert (freetime "ne_ochen"))
(assert (freetimecnst 2)))

; days 2 works 33..66 Времени совсем немного
(defrule R9
	(days ?days)
	(works ?works)
	(test (and (= ?days 2) (and ( > ?works 33 ) (<= ?works 66) )))
=>
(printout t crlf crlf "Svobodnogo vremeni sovsem nemnogo. Pora delat'" crlf)
(assert (freetime "pora_dalat"))
(assert (freetimecnst 3)))

; days 2 works 66..100 Свободного времени нет  -- не успеваем
(defrule R10
	(days ?days)
	(works ?works)
	(test (and (= ?days 2) (and ( > ?works 66 ) (<= ?works 100) )))
=>
(printout t crlf crlf "Svobodnogo vremeni net -- ne uspevaem" crlf)
(assert (freetime "finish"))
(assert (freetimecnst 4)))

; days 1 works 0..25 Свободного времени не очень много
(defrule R11
	(days ?days)
	(works ?works)
	(test (and (= ?days 1) (and ( > ?works 0 ) (<= ?works 25) )))
=>
(printout t crlf crlf "Svobodnogo vremeni ne ochen' mnogo" crlf)
(assert (freetime "ne_ochen"))
(assert (freetimecnst 2)))

; days 1 works 25..50 Свободного времени нет  -- не успеваем
(defrule R12
	(days ?days)
	(works ?works)
	(test (and (= ?days 1) (and ( > ?works 25 ) (<= ?works 50) )))
=>
(printout t crlf crlf "Svobodnogo vremeni sovsem nemnogo. Pora delat'" crlf)
(assert (freetime "pora_dalat"))
(assert (freetimecnst 3)))

; days 1 works 50..100 time4
(defrule R13
	(days ?days)
	(works ?works)
	(test (and (= ?days 1) (and ( > ?works 50 ) (<= ?works 100) )))
=>
(printout t crlf crlf "Svobodnogo vremeni net -- ne uspevaem" crlf)
(assert (freetime "finish"))
(assert (freetimecnst 4)))

; days 0 works >0 Свободного времени нет  -- не успеваем
(defrule R14
	(days ?days)
	(works ?works)
	(test (and (= ?days 0) ( > ?works 0 )))
=>
(printout t crlf crlf "Nu kogda-to ono bylo. A seichas uzhe ne vazhno" crlf)
(assert (freetime "ppc"))
(assert (freetimecnst 5)))

; days temp 25.. w1
(defrule R15
	(temper ?temper)
	(rain ?rain)
	(test (> ?temper 25)) 
=>
(printout t crlf crlf "Pogoda ochen' horoshaya " crlf)
(assert (weather "v-good"))
(assert (weathercnst 1)))

; days temp 5..25 rain 0 w2
(defrule R16
	(temper ?temper)
	(rain ?rain)
	(test (and(and(>= ?temper 5)(< ?temper 25)) (= ?rain 0)) )
=>
(printout t crlf crlf "Pogoda horoshaya " crlf)
(assert (weather "good"))
(assert (weathercnst 2)))

; days temp 5..25 w3
(defrule R17
	(temper ?temper)
	(rain ?rain)
	(test (and(and(>= ?temper 5)(< ?temper 25)) (<> ?rain 0)) )
=>
(printout t crlf crlf "Pogoda plohaya " crlf)
(assert (weather "bad"))
(assert (weathercnst 3)))

; days temp ..5 w4
(defrule R18
	(temper ?temper)
	(rain ?rain)
	(test (<= ?temper 5) )
=>
(printout t crlf crlf "Pogoda ochen' plohaya " crlf)
(assert (weather "v-bad "))
(assert (weathercnst 4)))

(defrule R21
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(< ?freetimecnst 3)(= ?weathercnst 1)))
=>
(printout t crlf crlf "Mozhno idti gulyat'" crlf)
(assert (act "go")))

(defrule R20
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (= ?freetimecnst 5))
=>
(printout t crlf crlf "Po povodu pogodi ne znayu, no uchit' uje pozdno" crlf)
(assert (act "nth")))

(defrule R21
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (= ?freetimecnst 0))
=>
(printout t crlf crlf "Po povodu pogodi ne znayu -- gotovsya k sleduyuchey sessii..." crlf)
(assert (act "botan")))

(defrule R22
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(= ?freetimecnst 4)(<> ?weathercnst 5)))
=>
(printout t crlf crlf "Nado uchit'!" crlf)
(assert (act "learn")))

(defrule R23
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(= ?freetimecnst 3)(= ?weathercnst 2)))
=>
(printout t crlf crlf "Luchshe uchit'sya" crlf)
(assert (act "learn")))

(defrule R24
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(= ?freetimecnst 2)(= ?weathercnst 2)))
=>
(printout t crlf crlf "As u wish" crlf)
(assert (act "auw")))

(defrule R25
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(= ?freetimecnst 1)(= ?weathercnst 2)))
=>
(printout t crlf crlf "As u wish" crlf)
(assert (act "auw")))

(defrule R26
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and( or (= ?freetimecnst 2)( = ?freetimecnst 1))(= ?weathercnst 3)))
=>
(printout t crlf crlf "Luchshe uchit'" crlf)
(assert (act "glearn")))

(defrule R27
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(= ?freetimecnst 3)(= ?weathercnst 3)))
=>
(printout t crlf crlf "Luchshe uchit'" crlf)
(assert (act "glearn")))

(defrule R28
	(weathercnst ?weathercnst)
	(freetimecnst ?freetimecnst)
	(test (and(> ?freetimecnst 0) (= ?weathercnst 4)))
=>
(printout t crlf crlf "Luchshe uchit'" crlf)
(assert (act "glearn")))
 
