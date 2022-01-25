;1.1
(clear)
(reset)
(assert (n n) (m m) (p p))
    ;Появились соответствующие факты
(reset)
    ;ОСтался только initial-fact
(deffacts name (n n) (m m) (p p))
    ;Ничего не изменилось
(reset)
    ;Теперь при каждом reset будут появлятся
    ;   (initial-fact) (n n) (m m) (p p)