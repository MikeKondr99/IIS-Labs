(deftemplate student
(slot name)		; имя студента
(slot age)		; возраст
(slot year)		; год обучения (курс)
(slot spec)		; специализация
(slot aver_mark))	; средний балл

(deffacts students
    (student (name "John")   (age 20) (year 1) (spec "hard") (aver_mark 4.7))
    (student (name "Alex")   (age 19) (year 2) (spec "soft") (aver_mark 3.3))
    (student (name "George") (age 18) (year 3) (spec "ai") (aver_mark 4.3))
    (student (name "Tom")    (age 21) (year 5) (spec "soft") (aver_mark 3.7))
    (student (name "Bill")   (age 18) (year 3) (spec "ai") (aver_mark 4.7))
    (student (name "Oleg")   (age 22) (year 4) (spec "soft") (aver_mark 4.8))
    (student (name "Peter")  (age 21) (year 2) (spec "soft") (aver_mark 3.3))
    (student (name "Kate")   (age 19) (year 2) (spec "ai") (aver_mark 4.5))
    (student (name "Lisa")   (age 22) (year 1) (spec "hard") (aver_mark 4.2))
    (student (name "Dio")    (age 17) (year 4) (spec "soft") (aver_mark 4.0))
) 
