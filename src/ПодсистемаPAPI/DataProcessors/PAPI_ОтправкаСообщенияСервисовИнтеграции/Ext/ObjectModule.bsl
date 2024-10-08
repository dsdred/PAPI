﻿
#Область ИнициализацияДополнительныеОтчетыИОбработки

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	Перем ПараметрыРегистрации;

    Если ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		
		МодульДополнительныеОтчетыИОбработки = ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		МодульДополнительныеОтчетыИОбработкиКлиентСервер = ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиентСервер");
		
		ПараметрыРегистрации = МодульДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.4.5.71");
		ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
			
		ПараметрыРегистрации.Вид = МодульДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
		ПараметрыРегистрации.Версия = "2024.08.25";
			
		НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
		НоваяКоманда.Представление = НСтр("ru = 'Отправка сообщения сервисов интеграции'");
		НоваяКоманда.Идентификатор = "ОтправкаСообщенияСервисовИнтеграции";
		НоваяКоманда.Использование = МодульДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
		НоваяКоманда.ПоказыватьОповещение = Ложь;  
		
	КонецЕсли;
		
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Функция для возврата минимальной версии при которой будет работать история данных
Функция МинимальнаяВерсияПлатформы()
	Возврат "8.3.17";	
КонецФункции

// Функция для возврата версии в которой появилось свойство РазмерТела
Функция ВерсияСРазмерТела()
	Возврат "8.3.21";	
КонецФункции


// Определяет используемую версию платформы.
//
//	Параметры:
//		ВерсияПлатформы - Строка - Пример: "8.3.11.2867"
//
// Возвращаемое значение:
//	Структура:
//   Отработал - Булево - Истина, функция возвращает нормальный результат, 
//   					Ложь означает, что результат получить не удалось.
//	 ТекстОшибки - Строка - Описание ошибки
//   Результат - Строка - Текущая версия конфигуратора или режима совместимости
//
Функция ТекущаяВерсияПлатформы(ВидПроверки = "МинимальнаяВерсияПлатформы") Экспорт 
	
	Результат = Новый Структура("Отработал, ТекстОшибки, Результат", Истина, "", 0);
	
	АктуальнаяСистемнаяИнформация = Новый СистемнаяИнформация;
		
	// 8.3.11.2867
	перВерсияПриложения = АктуальнаяСистемнаяИнформация.ВерсияПриложения;  
	 
	Если ВидПроверки = "МинимальнаяВерсияПлатформы" Тогда  
		МинимальнаяВерсия = МинимальнаяВерсияПлатформы();     
	Иначе
		МинимальнаяВерсия = ВерсияСРазмерТела();	
	КонецЕсли;	  
	
	// Основная проверка
	Если ВерсияСтаршеИлиРавнаВерсии(перВерсияПриложения, МинимальнаяВерсия) Тогда
		
		Результат.Результат = перВерсияПриложения;	   
		
	Иначе
		
		Результат.Отработал = Ложь;
		текТекстОшибки = НСтр("ru = 'Версия платформы ( %1 ), необходима версия не ниже ( %2 )'");
		Результат.ТекстОшибки	=  СтрШаблон(текТекстОшибки, перВерсияПриложения, МинимальнаяВерсия); 
		
	КонецЕсли;	
					
    Возврат Результат;
	
КонецФункции


// Сравниваем две версии и возвращаем Истина если ПроверяемаяВерсия >= ЭталоннаяВерсия,
// в противном случае возвращаем Ложь
Функция ВерсияСтаршеИлиРавнаВерсии(ПроверяемаяВерсия, ЭталоннаяВерсия)
	
	СтруктураПроверяемаяВерсия 	= ВернутьСтруктуруПоВерсии(ПроверяемаяВерсия);	
	СтруктураЭталоннаяВерсия 	= ВернутьСтруктуруПоВерсии(ЭталоннаяВерсия);
	
	Результат = Истина;
	
	Если Число(СтруктураПроверяемаяВерсия.НомерВерсии) > Число(СтруктураЭталоннаяВерсия.НомерВерсии) Тогда 
		
		Возврат Результат;
		
	ИначеЕсли Число(СтруктураПроверяемаяВерсия.НомерВерсии) < Число(СтруктураЭталоннаяВерсия.НомерВерсии) Тогда 
		
		Результат = Ложь;
		
	Иначе // СтруктураПроверяемаяВерсия.НомерВерсии = СтруктураЭталоннаяВерсия
		
		Если Число(СтруктураПроверяемаяВерсия.НомерРедакции) > Число(СтруктураЭталоннаяВерсия.НомерРедакции) Тогда
			
			Возврат Результат;
		
		ИначеЕсли Число(СтруктураПроверяемаяВерсия.НомерРедакции) < Число(СтруктураЭталоннаяВерсия.НомерРедакции) Тогда
			
			Результат = Ложь;
			
		Иначе // СтруктураПроверяемаяВерсия.НомерРедакции = СтруктураЭталоннаяВерсия.НомерРедакции
			
			Если Число(СтруктураПроверяемаяВерсия.НомерРелиза) > Число(СтруктураЭталоннаяВерсия.НомерРелиза) Тогда
				
				Возврат Результат;	
			
			ИначеЕсли Число(СтруктураПроверяемаяВерсия.НомерРелиза) < Число(СтруктураЭталоннаяВерсия.НомерРелиза) Тогда 
				
				Результат = Ложь;
				
			Иначе  // СтруктураПроверяемаяВерсия.НомерРелиза = СтруктураЭталоннаяВерсия.НомерРелиза
				
				Если СтруктураПроверяемаяВерсия.НомерПодрелиза <> "0" Тогда 
					
					Если Число(СтруктураПроверяемаяВерсия.НомерПодрелиза) > Число(СтруктураЭталоннаяВерсия.НомерПодрелиза) Тогда
				
						Возврат Результат;	
					
					ИначеЕсли Число(СтруктураПроверяемаяВерсия.НомерПодрелиза) < Число(СтруктураЭталоннаяВерсия.НомерПодрелиза) Тогда 
						
						Результат = Ложь;
						
					Иначе 
						
						Возврат Результат;
						
				    КонецЕсли; // НомерПодрелиза
				КонецЕсли; // НомерПодрелиза <> "0"
			КонецЕсли; // НомерРелиза	
        КонецЕсли; // НомерРедакции
	КонецЕсли; // НомерВерсии	
	
	Возврат Результат;
	
КонецФункции 

// Возвращает структуру по версии 
//	Параметры:
//		ВерсияПлатформы - Строка - Пример: "8.3.11.2867" 
//
// 	Возвращаемое значение:
// 	Структура:
//		НомерВерсии 	- Строка - Пример: "8"
//		НомерРедакции 	- Строка - Пример: "3"
//		НомерРелиза		- Строка - Пример: "11"
//		НомерПодрелиза 	- Строка - Пример: "2867"
Функция ВернутьСтруктуруПоВерсии(ВерсияПлатформы)
	
	массивРазделенныхЭлементов = СтрРазделить(ВерсияПлатформы, ".", Истина);    
	
	Если массивРазделенныхЭлементов.Количество() < 4 Тогда 
		Пока массивРазделенныхЭлементов.Количество() < 4 Цикл 
			массивРазделенныхЭлементов.Добавить("0");
		КонецЦикла;	
	КонецЕсли;
	
	СтруктураВерсияПриложения = Новый Структура("НомерВерсии, НомерРедакции, НомерРелиза, НомерПодрелиза"
						,массивРазделенныхЭлементов[0]
						,массивРазделенныхЭлементов[1]
						,массивРазделенныхЭлементов[2]
						,массивРазделенныхЭлементов[3]);

	Возврат СтруктураВерсияПриложения;
	
КонецФункции

#КонецОбласти


#Область ДополнительныеОбработкиИОтчеты 

// Возвращает Истина, если подсистема существует.
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема без слов "Подсистема.".
//                        Например: "СтандартныеПодсистемы.БазоваяФункциональность".
//
// Пример вызова необязательной подсистемы:
//
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
//  	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
//  	МодульУправлениеДоступом.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	ИменаПодсистем = ИменаПодсистем();
	Возврат ИменаПодсистем.Получить(ПолноеИмяПодсистемы) <> Неопределено;
	
КонецФункции

// Возвращает соответствие имен подсистем и значения Истина;
Функция ИменаПодсистем() Экспорт
	
	Возврат Новый ФиксированноеСоответствие(ИменаПодчиненныхПодсистем(Метаданные));
	
КонецФункции

Функция ИменаПодчиненныхПодсистем(РодительскаяПодсистема)
	
	Имена = Новый Соответствие;
	
	Для Каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Имена.Вставить(ТекущаяПодсистема.Имя, Истина);
		ИменаПодчиненных = ИменаПодчиненныхПодсистем(ТекущаяПодсистема);
		
		Для каждого ИмяПодчиненной Из ИменаПодчиненных Цикл
			Имена.Вставить(ТекущаяПодсистема.Имя + "." + ИмяПодчиненной.Ключ, Истина);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Имена;
	
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Если Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено Тогда
		Модуль = Вычислить(Имя); // АПК:488 "Вычислить" вместо "ОбщегоНазначения.ВычислитьВБезопасномРежиме()", так как это автономная обработка.
	Иначе
		Модуль = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(НСтр("ru = 'Общий модуль ""%1"" не существует.'"), Имя);
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено)
	
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
	
	Возврат СтрокаПодстановки;
КонецФункции


#КонецОбласти

