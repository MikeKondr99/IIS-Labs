; Студент 2-го курса, средний балл не ниже 4.5 

; Студент <name> имеет средний балл <aver_mark>

; Но с проверкой <name> и <aver_mark>

; Оканчивает университет в возрасте не старше 24 лет

;(data (x ?x) (y =(* 2 ?x))).

(defrule R1
    (student 
        (year ?year & 2) 
        (name ?name & :(stringp ?name)) 
        (aver_mark ?avg & :(floatp ?avg))
        (age ?age)
        ; Возраст окончания: age + (5 - year) <= 24 | age + 5 - 2 <= 24 | age <= 21
        (test (<= age 21)
    )
    (test (<= (+ ?age (- 5 ?year)) 24))
    (test (>= ?avg 4.5))
    =>
    (printout t "Student 2nd year " ?name " has average mark " ?avg crlf 
    "  and will finish studies before the age of 25" crlf)
)