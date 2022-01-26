; Студент 2-го курса, средний балл не ниже 4.5 

; Студент <name> имеет средний балл <aver_mark>

(defrule R1
    (student (year 2) (name ?name) (aver_mark ?avg) )
    (test (>= ?avg 4.5))
    =>
    (printout t "Student 2nd year " ?name " has average mark " ?avg crlf)
)