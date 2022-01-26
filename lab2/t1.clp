; Студент 2-го курса

; Студент 2-го курса <name> учится по специализации <spec>

(defrule R1
    (student (year 2) (name ?name) (spec ?spec) )
    =>
    (printout t "Student 2nd year " ?name " studying as a " ?spec crlf)
)