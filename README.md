# TestFoRedOS
    Согласно условиям тестового задания, я не мог использовать какие либо репозитории,
    docker images, rpm пакеты - кроме тех, что предоставляют официальные репозитории РЕД ОС.
    Так же, учитывая что тестовый образ не имеет - пакетного менеджера, программы make и тд,
    нельзя копировать исполняемый файл nginx в образ и согласно ТС - запрещено использовать
    различные системый сборки docker образов, то я решил использовать multi-stage сборку с 
    предварительным скачиванием необходимых пакетов и зависимостей.
