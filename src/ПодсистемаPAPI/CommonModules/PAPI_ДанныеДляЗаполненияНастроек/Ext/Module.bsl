﻿#Область License

//MIT License

//Copyright (c) 2024 Dmitrii Sidorenko

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#КонецОбласти

#Область НачальноеЗаполнение

// Наименование подсистемы PAPI
// 
// Возвращаемое значение:
//  Строка - предопределенное имя расширения PAPI
//
Функция НаименованиеПодсистемыPAPI() Экспорт 
	
	Возврат "ПодсистемаPAPI";	
	
КонецФункции	

// Версия расширения
// 
// Возвращаемое значение:
//  Строка - Версия PAPI
//
Функция ВерсияРасширения() Экспорт 

	// Обновление подсистемы
	МассивРасширений = РасширенияКонфигурации.Получить(Новый Структура("Имя", НаименованиеПодсистемыPAPI()));
	Если ТипЗнч(МассивРасширений) = Тип("Массив")
		И МассивРасширений.Количество() > 0 Тогда 
		РасширениеPAPI = МассивРасширений[0];
		ВерсияPAPI = РасширениеPAPI.Версия; 
	Иначе
		ВерсияPAPI = "0.0.0.0";
    КонецЕсли;
	
	Возврат ВерсияPAPI;
	
КонецФункции	

// Минимальная версия для обновления
// 
// Возвращаемое значение:
//  Строка - До версии 0.9.2.7 обновления не требовались, 
// 		поэтому при начальном заполнении проставляется эта версия.
//
Функция МинимальнаяВерсияДляОбновления() Экспорт 
	Возврат "0.9.2.7";	
КонецФункции	

// Модуль приложения
Процедура ПередНачаломРаботыСистемы() Экспорт
	
	ПроверитьИОбновитьРасширение();
		
КонецПроцедуры	 

// Проверить и обновить расширение
//
Процедура ПроверитьИОбновитьРасширение() 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	 	
	ТекущаяВерсия = PAPI_ОбщегоНазначенияВызовСервера.ПрочитатьЗначениеКонстанты("PAPI_ТекущаяВерсия");
		
	// Первый запуск
	Если ПустаяСтрока(ТекущаяВерсия) Тогда 
		ТекущаяВерсия = МинимальнаяВерсияДляОбновления();
			
		ДанныеЗаполнены = ЗаполнитьПервоначальныеДанные();
		Если ДанныеЗаполнены Тогда 
			
			PAPI_ОбщегоНазначенияВызовСервера.ПоменятьЗначениеКонстанты("PAPI_ТекущаяВерсия", ТекущаяВерсия, Истина);	
			ВерсияPAPI = ВерсияРасширения();
			
			// Проверяем требуется ли установить обновления  
			Если Не PAPI_ОбщегоНазначенияВызовСервера.ВерсияСтаршеИлиРавнаВерсии(ТекущаяВерсия, ВерсияPAPI, Истина) Тогда 
					
				ИмяВыполняемогоМетода = "PAPI_АсинхронныеОперации.ВыполнитьНеобходимыеОбновления";
				ФильтрОтбора = Новый Структура;
				ФильтрОтбора.Вставить("ИмяМетода", ИмяВыполняемогоМетода);

				РезультатЗадание = PAPI_ОбщегоНазначенияВызовСервера.НайтиФоновоеЗаданиеПоФильтрОтбора(ФильтрОтбора);	
				Если Не РезультатЗадание.Выполняется Тогда 
	                ПараметрыЗадания = Новый Массив;
					ПараметрыЗадания.Добавить(Новый Структура("ТекущаяВерсия", ТекущаяВерсия));	
					ФоновыеЗадания.Выполнить(ИмяВыполняемогоМетода, ПараметрыЗадания);		
				КонецЕсли;		
			КонецЕсли;
		КонецЕсли;				
	КонецЕсли;					

	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;
	
КонецПроцедуры	

// Заполнить первоначальные данные
// 
// Возвращаемое значение:
//  Булево - Если ошибок не было тогда истина 
//
Функция ЗаполнитьПервоначальныеДанные()
	
	Результат = Истина;
	
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
		
	ИмяСправочникаШаблоныСообщений = "PAPI_ШаблоныСообщений";
	МетаданныеШаблоныСообщений = Метаданные.Справочники.Найти(ИмяСправочникаШаблоныСообщений);
	Если МетаданныеШаблоныСообщений <> Неопределено Тогда 
		// Заполняем стандартные шаблоны сообщений 
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.PAPI_ШаблоныСообщений
			|ГДЕ
			|	Стандартный";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда 
			
			Результат = ЗаполнитьСправочникPAPI_ШаблоныСообщений();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции 

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает основной язык конфигурации
// 
// Возвращаемое значение:
//  Метаданные.ОсновнойЯзык.КодЯзыка - код языка
//
Функция ОсновнойЯзыкКонфигурации() Экспорт 
	Возврат Метаданные.ОсновнойЯзык.КодЯзыка;
КонецФункции

// Возвращает кодировку UTF8
// 
// Возвращаемое значение:
//  КодировкаТекста.UTF8 - кодировка
//
Функция ОсновнаяКодировкаОтветов() Экспорт
	
	Возврат КодировкаТекста.UTF8;
	
КонецФункции		

// Заполняем предопределенные ошибки в справочнике PAPI_ШаблоныСообщений
Функция ЗаполнитьСправочникPAPI_ШаблоныСообщений() Экспорт
	
	Результат = Истина;
	
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;
	
	МассивДляЗаполнения = Новый Массив;
	
	Макет = Справочники.PAPI_ШаблоныСообщений.ПолучитьМакет("СтандартныеСообщения");
	НомерСтроки 	= 1;
	
	кКлючПоиска		= "C1";
	кСообщение 		= "C2";
	кКодСостояния 	= "C3";
		
	ЗаполненоСообщение = ЗначениеЗаполнено(Макет.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + кКлючПоиска).Текст);
	Пока ЗаполненоСообщение Цикл
		ДобавитьВМассивДляЗаполненияЭлемент(МассивДляЗаполнения,
		Число(Макет.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + кКодСостояния).Текст),
		Макет.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + кКлючПоиска).Текст,
		Макет.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + кСообщение).Текст);
		
		НомерСтроки = НомерСтроки + 1;	
		ЗаполненоСообщение = ЗначениеЗаполнено(Макет.Область("R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0") + кКлючПоиска).Текст);
	КонецЦикла;	
	
// Создаем шаблоны сообщений	
// Создаем элементы только если код элемента не занят
	
	Для Каждого ЭлМассива Из МассивДляЗаполнения Цикл 
		Если ПустаяСтрока(ЭлМассива.Код) Тогда 
			Продолжить;	
		КонецЕсли;	
		
		НайденныйЭлемент = Справочники.PAPI_ШаблоныСообщений.НайтиПоКоду(ЭлМассива.Код);
		
		Если ЗначениеЗаполнено(НайденныйЭлемент) Тогда 
			Продолжить;
		КонецЕсли;
		
		НовыйЭлемент = Справочники.PAPI_ШаблоныСообщений.СоздатьЭлемент();
	
		НовыйЭлемент.Код 			= ЭлМассива.Код;
		НовыйЭлемент.КодСостояния 	= ЭлМассива.КодСостояния;
		НовыйЭлемент.ТекстСообщения = ЭлМассива.Сообщение;
		
		НовыйЭлемент.Стандартный 	= Истина;
		
		Попытка
			
			НовыйЭлемент.ОбменДанными.Загрузка = Истина;
			НовыйЭлемент.Записать();
			
		Исключение
			
			Результат = Ложь;
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "Справочники.PAPI_ШаблоныСообщений");
		
		КонецПопытки;
													
									
	КонецЦикла;		
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняем массив для формирования элементов справочника PAPI_ШаблоныСообщений
Процедура ДобавитьВМассивДляЗаполненияЭлемент(МассивДляЗаполнения, КодСостояния, КодОшибки, ТекстСообщения)
	
	МассивДляЗаполнения.Добавить(Новый Структура("КодСостояния, Код, Сообщение", КодСостояния, КодОшибки, ТекстСообщения));

КонецПроцедуры	

#КонецОбласти