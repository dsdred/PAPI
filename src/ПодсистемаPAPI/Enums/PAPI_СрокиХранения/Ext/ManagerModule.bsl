﻿
// Функция - Все значения списком
// 
// Возвращаемое значение:
//  СписокЗначений - Все значения перечисления
//
Функция ВсеЗначенияСписком() Экспорт
	
	Результат = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Ссылка КАК Значение,
		|	ПРЕДСТАВЛЕНИЕ(Ссылка) КАК Представление
		|ИЗ
		|	Перечисление.PAPI_СрокиХранения";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Результат.Добавить(ВыборкаДетальныеЗаписи.Значение, ВыборкаДетальныеЗаписи.Представление); 
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции	


// Функция - Соответствие значений и даты
// 
// Возвращаемое значение:
//  Соответствие - Возвращает соответствие значений перечисления PAPI_НастройкаХраненияДанных 
//					и значения даты в зависимости от значения перечисления.
//
Функция СоответствиеЗначенийИДаты() Экспорт 
	
	Результат = Новый Соответствие;
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	PAPI_СрокиХранения.Ссылка КАК СрокХранения,
		|	ВЫБОР
		|		КОГДА PAPI_СрокиХранения.Ссылка = ЗНАЧЕНИЕ(Перечисление.PAPI_СрокиХранения.ЗаДень)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, -1)
		|		КОГДА PAPI_СрокиХранения.Ссылка = ЗНАЧЕНИЕ(Перечисление.PAPI_СрокиХранения.ЗаНеделю)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, НЕДЕЛЯ, -1)
		|		КОГДА PAPI_СрокиХранения.Ссылка = ЗНАЧЕНИЕ(Перечисление.PAPI_СрокиХранения.ЗаМесяц)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, МЕСЯЦ, -1)
		|		КОГДА PAPI_СрокиХранения.Ссылка = ЗНАЧЕНИЕ(Перечисление.PAPI_СрокиХранения.ЗаТриМесяца)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, МЕСЯЦ, -3)
		|		КОГДА PAPI_СрокиХранения.Ссылка = ЗНАЧЕНИЕ(Перечисление.PAPI_СрокиХранения.ЗаШестьМесяцев)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, МЕСЯЦ, -6)
		|		КОГДА PAPI_СрокиХранения.Ссылка = ЗНАЧЕНИЕ(Перечисление.PAPI_СрокиХранения.ЗаГод)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, ГОД, -1)
		|		ИНАЧЕ NULL
		|	КОНЕЦ КАК ДатаУдаления
		|ПОМЕСТИТЬ ВТ_СрокиХранения
		|ИЗ
		|	Перечисление.PAPI_СрокиХранения КАК PAPI_СрокиХранения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СрокиХранения.СрокХранения КАК СрокХранения,
		|	ВТ_СрокиХранения.ДатаУдаления КАК ДатаУдаления
		|ИЗ
		|	ВТ_СрокиХранения КАК ВТ_СрокиХранения
		|ГДЕ
		|	НЕ ВТ_СрокиХранения.ДатаУдаления ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		Результат.Вставить(ВыборкаДетальныеЗаписи.СрокХранения, ВыборкаДетальныеЗаписи.ДатаУдаления);	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции 

