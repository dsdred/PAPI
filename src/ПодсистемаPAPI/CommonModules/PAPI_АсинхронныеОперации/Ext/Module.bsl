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


#Область РегламентныеОперации

// Удаление старых данных  
// Регламентное задание "PAPI_УдалениеСтарыхДанных"
//
Процедура УдалениеСтарыхДанных() Экспорт
		
    СоответствиеЗначений = Перечисления.PAPI_СрокиХранения.СоответствиеЗначенийИДаты();
	Если Метаданные.Константы.Найти("PAPI_НастройкаХраненияДанных") <> Неопределено Тогда 
		// Считываем структуру хранящую настройки хранения данных
		СтруктураЗначенийХранения = Константы.PAPI_НастройкаХраненияДанных.СтруктураНастроек();
	Иначе
		СтруктураЗначенийХранения = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураЗначенийХранения)
		И ТипЗнч(СтруктураЗначенийХранения) = Тип("Структура") Тогда 
		
		СоответствиеЗначенийИПроцедур = СоответствиеЗначенийИПроцедурДляУдаленияСтарыхДанных();
		Для Каждого ТекЭлементСоответствия Из СоответствиеЗначенийИПроцедур Цикл  
			Если СтруктураЗначенийХранения.Свойство(ТекЭлементСоответствия.Ключ) Тогда 
				ТекЭлемент = СтруктураЗначенийХранения[ТекЭлементСоответствия.Ключ];
				
				ДатаОтбора = СоответствиеЗначений[ТекЭлемент];
				Если ЗначениеЗаполнено(ДатаОтбора) Тогда
					ПараметрыЗадания = Новый Массив;
					ПараметрыЗадания.Добавить(ДатаОтбора);
					ВыполнитьРегламентВручнуюНаСервере(ТекЭлементСоответствия.Значение, ПараметрыЗадания);	
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
		
		// 		
	КонецЕсли;
	
КонецПроцедуры

// Выполнить регламент вручную на сервере
//
// Параметры:
//  ИмяВыполняемогоМетода	- Строка - Название процедуры и модуля. Пример: "PAPI_АсинхронныеОперации.УдалитьУстаревшиеДокументы" 
//  ПараметрыЗадания		- Массив - Массив параметров
//
Процедура ВыполнитьРегламентВручнуюНаСервере(ИмяВыполняемогоМетода, ПараметрыЗадания)
	
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;

	ФильтрОтбора = Новый Структура;
	ФильтрОтбора.Вставить("ИмяМетода", ИмяВыполняемогоМетода);

	РезультатЗадание = PAPI_ОбщегоНазначенияВызовСервера.НайтиФоновоеЗаданиеПоФильтрОтбора(ФильтрОтбора);	
	Если Не ПустаяСтрока(РезультатЗадание.ТекстОшибки) Тогда 
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка",
			Перечисления.PAPI_ТипЛога.Ошибка, 
			РезультатЗадание.ТекстОшибки, 
			СтрШаблон("PAPI_АсинхронныеОперации.ВыполнитьРегламентВручнуюНаСервере, ИмяМетода: %1", ИмяВыполняемогоМетода));	
	КонецЕсли;	
			
	Если Не РезультатЗадание.Выполняется Тогда 

		ФоновыеЗадания.Выполнить(ИмяВыполняемогоМетода, ПараметрыЗадания);	
	
	КонецЕсли;
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
КонецПроцедуры

// Фоновое задание для удаления устаревших документов содержащих логи входящих запросов
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Документы младше или равные этой дате, данные будут удалены безвозвратно
//
Процедура УдалитьУстаревшиеДокументы(ДатаОчистки) Экспорт 
	
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Ссылка КАК Ссылка ИЗ Документ.PAPI_ВходящийЗапрос ГДЕ Дата <= &ДатаОчистки";
	Запрос.УстановитьПараметр("ДатаОчистки", ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
			
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Попытка	
			ДокументОб = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ДокументОб.Удалить();
		Исключение
				
			ТекстОшибки 	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());							
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.УдалитьУстаревшиеДокументы");	
					
		КонецПопытки;	
	КонецЦикла;
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;
	
КонецПроцедуры

// Фоновое задание для удаления логов методов из регистра сведений PAPI_ЛогМетодов
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Логи младше или равные этой дате, данные будут удалены безвозвратно
//
Процедура УдалитьЛогиМетодов(ДатаОчистки) Экспорт 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДатаВремя КАК ДатаВремя,
			|	Метод КАК Метод,
			|	ТипЛога КАК ТипЛога
			|ИЗ
			|	РегистрСведений.PAPI_ЛогМетодов
			|ГДЕ
			|	ДатаВремя <= &ДатаОчистки";
	Запрос.УстановитьПараметр("ДатаОчистки",ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
			
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Попытка	
			
			НаборЗаписей = РегистрыСведений["PAPI_ЛогМетодов"].СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.ДатаВремя.Установить(ВыборкаДетальныеЗаписи.ДатаВремя);
			НаборЗаписей.Отбор.Метод.Установить(ВыборкаДетальныеЗаписи.Метод);
			НаборЗаписей.Отбор.ТипЛога.Установить(ВыборкаДетальныеЗаписи.ТипЛога);
		 
			НаборЗаписей.Записать(); 
			
		Исключение
			
			ТекстОшибки 	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());							
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.УдалитьЛогиМетодов");	
							
		КонецПопытки;	
	КонецЦикла;  
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
КонецПроцедуры	

// Фоновое задание для удаления логов алгоритмов из регистра сведений PAPI_ЛогАлгоритмов
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Логи младше или равные этой дате, данные будут удалены безвозвратно
//
Процедура УдалитьЛогиАлгоритмов(ДатаОчистки) Экспорт 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДатаВремя КАК ДатаВремя,
			|	Алгоритм КАК Алгоритм,
			|	ТипЛога КАК ТипЛога
			
			|ИЗ
			|	РегистрСведений.PAPI_ЛогАлгоритмов
			|ГДЕ
			|	ДатаВремя <= &ДатаОчистки";
	Запрос.УстановитьПараметр("ДатаОчистки",ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
			
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Попытка	
			
			НаборЗаписей = РегистрыСведений["PAPI_ЛогАлгоритмов"].СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.ДатаВремя.Установить(ВыборкаДетальныеЗаписи.ДатаВремя);
			НаборЗаписей.Отбор.Алгоритм.Установить(ВыборкаДетальныеЗаписи.Алгоритм);
			НаборЗаписей.Отбор.ТипЛога.Установить(ВыборкаДетальныеЗаписи.ТипЛога);
		 
			НаборЗаписей.Записать(); 
			
		Исключение
			
			ТекстОшибки 	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());							
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.УдалитьЛогиАлгоритмов");	
							
		КонецПопытки;	
	КонецЦикла;  
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
КонецПроцедуры

// Фоновое задание для удаления результатов из регистра сведений PAPI_ХранилищеРезультатов
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Дата создания младше или равные этой дате, данные будут удалены безвозвратно
//
Процедура УдалитьРезультатыХранилища(ДатаОчистки) Экспорт 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	КлючПоиска КАК КлючПоиска,
			|	НомерЧасти КАК НомерЧасти
			|ИЗ
			|	РегистрСведений.PAPI_ХранилищеРезультатов
			|ГДЕ
			|	ДатаСоздания <= &ДатаОчистки";
	Запрос.УстановитьПараметр("ДатаОчистки",ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
			
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Попытка	
			
			НаборЗаписей = РегистрыСведений["PAPI_ХранилищеРезультатов"].СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.КлючПоиска.Установить(ВыборкаДетальныеЗаписи.КлючПоиска);
			НаборЗаписей.Отбор.НомерЧасти.Установить(ВыборкаДетальныеЗаписи.НомерЧасти);
		 
			НаборЗаписей.Записать(); 
			
		Исключение
			
			ТекстОшибки 	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());							
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.УдалитьРезультатыХранилища");	
							
		КонецПопытки;	
	КонецЦикла;  
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
КонецПроцедуры

// Фоновое задание для удаления алгоритмов из очереди выполнения в регистре сведений PAPI_ОчередьАлгоритмовДляФоновогоВыполнения
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Дата создания младше или равные этой дате, данные будут удалены безвозвратно
//
Процедура УдалитьАлгоритмыИзОчереди(ДатаОчистки) Экспорт 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	КлючПоиска КАК КлючПоиска,
			|	Алгоритм КАК Алгоритм
			|ИЗ
			|	РегистрСведений.PAPI_ОчередьАлгоритмовДляФоновогоВыполнения
			|ГДЕ
			|	Выполнен И ДатаОкончания <= &ДатаОчистки";
	Запрос.УстановитьПараметр("ДатаОчистки",ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
			
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Попытка	
			
			НаборЗаписей = РегистрыСведений["PAPI_ОчередьАлгоритмовДляФоновогоВыполнения"].СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.КлючПоиска.Установить(ВыборкаДетальныеЗаписи.КлючПоиска);
			НаборЗаписей.Отбор.Алгоритм.Установить(ВыборкаДетальныеЗаписи.Алгоритм);
		 
			НаборЗаписей.Записать(); 
			
		Исключение
			
			ТекстОшибки 	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());							
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.УдалитьАлгоритмыИзОчереди");	
							
		КонецПопытки;	
	КонецЦикла;  
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
КонецПроцедуры

// Фоновое задание для удаления документов из очереди выполнения в регистре сведений PAPI_ОчередьДействийСДокументами
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Дата изменения младше или равные этой дате, данные будут удалены безвозвратно
//
Процедура УдалитьДокументыИзОчереди(ДатаОчистки) Экспорт 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТипОбъекта КАК ТипОбъекта,
			|	ИдОбъекта КАК ИдОбъекта
			|ИЗ
			|	РегистрСведений.PAPI_ОчередьДействийСДокументами
			|ГДЕ
			|	Выполнено И ДатаИзменения <= &ДатаОчистки";
	Запрос.УстановитьПараметр("ДатаОчистки",ДатаОчистки);
	РезультатЗапроса = Запрос.Выполнить();
			
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Попытка	
			
			НаборЗаписей = РегистрыСведений["PAPI_ОчередьДействийСДокументами"].СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.ТипОбъекта.Установить(ВыборкаДетальныеЗаписи.ТипОбъекта);
			НаборЗаписей.Отбор.ИдОбъекта.Установить(ВыборкаДетальныеЗаписи.ИдОбъекта);
		 
			НаборЗаписей.Записать(); 
			
		Исключение
			
			ТекстОшибки 	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());							
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.УдалитьДокументыИзОчереди");	
							
		КонецПопытки;	
	КонецЦикла;  
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
КонецПроцедуры

// Фоновое задание для удалить входящие сообщения сервиса интеграции
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Дата чтения младше или равны этой дате, данные будут удалены безвозвратно 
//
Процедура УдалитьВходящиеСообщенияСервисаИнтеграции (ДатаОчистки) Экспорт 

	РегистрыСведений["PAPI_ВходящиеСообщенияСервисаИнтеграции"].УдалитьУстаревшиеЗаписи(ДатаОчистки);
	
КонецПроцедуры	

// Фоновое задание для удалить запросы неостающих данных
//
// Параметры:
//  ДатаОчистки	 - Дата	 - Дата чтения младше или равны этой дате, данные будут удалены безвозвратно 
//
Процедура УдалитьЗапросыНедостающихДанных (ДатаОчистки) Экспорт 

	РегистрыСведений["PAPI_ЗапросНедостающихДанных"].УдалитьУстаревшиеЗаписи(ДатаОчистки);
	
КонецПроцедуры

#КонецОбласти

// Соответствие значений настроек и процедур по чистке. Значения настроек см. Константы.PAPI_НастройкаХраненияДанных.ПолучитьСтруктуруПоУмолчанию 
//
// Возвращаемое значение:
//  ЗначенияСтруктур - Соответствие - Значения на основании которых будут чистится старые данные 
//
Функция СоответствиеЗначенийИПроцедурДляУдаленияСтарыхДанных()
	
	ЗначенияПоУмолчанию = Новый Соответствие;
	Если Метаданные.Документы.Найти("PAPI_ВходящийЗапрос") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияВходящихЗапросов", "PAPI_АсинхронныеОперации.УдалитьУстаревшиеДокументы");
	КонецЕсли;	
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ЛогМетодов") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияЛогМетодов", "PAPI_АсинхронныеОперации.УдалитьЛогиМетодов");	
	КонецЕсли;	
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ЛогАлгоритмов") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияЛогАлгоритмов", "PAPI_АсинхронныеОперации.УдалитьЛогиАлгоритмов");	
	КонецЕсли;
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ХранилищеРезультатов") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияРезультатов", "PAPI_АсинхронныеОперации.УдалитьРезультатыХранилища");	
	КонецЕсли;
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ОчередьАлгоритмовДляФоновогоВыполнения") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияОчередьАлгоритмов", "PAPI_АсинхронныеОперации.УдалитьАлгоритмыИзОчереди");	
	КонецЕсли;
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ОчередьДействийСДокументами") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияОчередьДокументов", "PAPI_АсинхронныеОперации.УдалитьДокументыИзОчереди");	
	КонецЕсли;
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ВходящиеСообщенияСервисаИнтеграции") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияВходящиеСообщенияСервисаИнтеграции", "PAPI_АсинхронныеОперации.УдалитьВходящиеСообщенияСервисаИнтеграции");	
	КонецЕсли;  
	
	Если Метаданные.РегистрыСведений.Найти("PAPI_ЗапросНедостающихДанных") <> Неопределено Тогда 
		ЗначенияПоУмолчанию.Вставить("СрокХраненияЗапросНедостающихДанных", "PAPI_АсинхронныеОперации.УдалитьЗапросыНедостающихДанных");	
	КонецЕсли;

	
	Возврат ЗначенияПоУмолчанию;    
	
КонецФункции



#Область ОстаткиPAPI2019года


// TODO: Остатки от PAPI 2019 года. Посмотреть надо ли и привести в порядок.
// ТекстФоновойПроцедуры = "
// |//Тут передаем текст фоновой процедуры, это может быть вызов каких то процедур или полноценный код
// |//вызов процедур проще, т.к. тупо легче отлаживать, т.к. код в этой процедуре обычной отладке не поддастся,
// |//а при вызове процедуры или функции мы ставим там точку останова и включаем в отладке автоматическое
// |//подключение  фоновых заданий. Запускать можно любые методы для выполнения на сервере.
// |
// |ОбщийМодульСервер.ВыполнитьНужнуюЗадачу(Параметр1,Параметр2);"
// И вызывать ее выполнение:
//	ЗапуститьФоновоеВыполнение(ТекстФоновойПроцедуры,Новый Структура("Параметр1,Параметр2",Параметр1,Параметр2));
//
// Функция ЗапуститьФоновоеВыполнение(ТекстПроцедуры,СтруктураПараметров=Неопределено) Экспорт
//    УникальныйИдентификатор = Новый УникальныйИдентификатор;
//    ПараметрыВыполнения = Новый Массив;
//    ПараметрыВыполнения.Добавить(ТекстПроцедуры);
//    ПараметрыВыполнения.Добавить(СтруктураПараметров);
//    
//    ФоновыеЗадания.Выполнить("PAPI_АсинхронныеОперации.УниверсальноеФЗ",ПараметрыВыполнения,УникальныйИдентификатор);
//    Возврат УникальныйИдентификатор;
// КонецФункции
//Процедура УниверсальноеФЗ(ТекстМодуля,ПараметрыВыполнения) Экспорт
//	ПолныйТекстМодуля = "";
//	Для Каждого ТекПараметр Из ПараметрыВыполнения Цикл
//		ПолныйТекстМодуля = ПолныйТекстМодуля+ТекПараметр.Ключ+"=ПараметрыВыполнения."+ТекПараметр.Ключ+";"+Символы.ПС;
//	КонецЦикла;
//	ПолныйТекстМодуля = ПолныйТекстМодуля + ТекстМодуля;
//	Выполнить(ПолныйТекстМодуля);
//КонецПроцедуры


// Выполнение алгоритма в регистре очередей 
//
// Параметры:
//  ПараметрыРегистра	 - Структура
//		Алгоритм			- СправочникСсылка.PAPI_Алгоритмы 		(Обязательный параметр)
//		КлючПоиска			- Строка - Ключ для поиска результата  	(Обязательный параметр) 
//		ПараметрыАлгоритма	- Структура - Параметры передаваемые в алгоритм   
//		Выполнен			- Булево - Признак того, что алгоритм выполнен или нет
//		Ошибка				- Булево - Признак того, что при выполнении была ошибка
//		ТекстОшибки			- Строка - Описание произошедшей ошибки в ходе выполнения алгоритма 
//		ДатаНачала			- Дата - время начала выполнения алгоритма в фоновом задании
//		ДатаОкончания 		- Дата - время окончания выполнения алгоритма в фоновом задании
//		КоличествоПопыток 	- Число - количество попыток приводивших к ошибке 
//
//Процедура ВыполнитьАлгоритмИзОчередиАлгоритмов(ПараметрыРегистра) Экспорт
//	
//	ВключенПривилегированныйРежим = Ложь;
//	Если Не ПривилегированныйРежим() Тогда  
//		ВключенПривилегированныйРежим = Истина;
//		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
//	КонецЕсли;	
//	
//	ПроверкаПройдена = Истина; 
//	
//	Если ТипЗнч(ПараметрыРегистра) = Тип("Структура") Тогда 
//		
//	    ПараметрыРегистра.Вставить("ДатаНачала", ТекущаяДатаСеанса());

//		ТекстОшибки = "";
//		
//		Если Не ПараметрыРегистра.Свойство("Алгоритм") Тогда 
//			
//			ПроверкаПройдена = Ложь; 	
//			ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", Символы.ПС) + "Отсутствует Алгоритм";
//			
//		Иначе
//			Если ТипЗнч(ПараметрыРегистра.Алгоритм) = Тип("Строка") Тогда
//					
//				ПараметрыРегистра.Алгоритм = PAPI_РаботаСАлгоритмами.ПолучитьАлгоритмПоИмени(ПараметрыРегистра.Алгоритм); 
//					
//			КонецЕсли;
//	
//			Если ТипЗнч(ПараметрыРегистра.Алгоритм) <> Тип("СправочникСсылка.PAPI_Алгоритмы") Тогда 
//				
//				ПроверкаПройдена = Ложь; 	
//				ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", Символы.ПС) + "Отсутствует Алгоритм";
//				
//			КонецЕсли;
//			
//		КонецЕсли;	  
//		
//		
//		Если Не ПараметрыРегистра.Свойство("КлючПоиска") Тогда 
//			
//			ПроверкаПройдена = Ложь;
//			ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", Символы.ПС) + "Отсутствует КлючПоиска";

//		КонецЕсли;	
//		
//		Если ПараметрыРегистра.Свойство("ПараметрыАлгоритма")
//			И ТипЗнч(ПараметрыРегистра.ПараметрыАлгоритма) = Тип("Структура") Тогда
//			
//			ПараметрыАлгоритма = ПараметрыРегистра.ПараметрыАлгоритма;  
//			
//		Иначе 
//			
//			ПараметрыАлгоритма = Новый Структура; 
//			
//		КонецЕсли;
//		
//	
//		Если ПроверкаПройдена Тогда
//							
//			СтруктураВозврата = PAPI_РаботаСАлгоритмами.РешитьАлгоритм(ПараметрыРегистра.Алгоритм, ПараметрыАлгоритма);   
//			
//			Если СтруктураВозврата.Отработал Тогда         
//					
//				PAPI_Логирование.ЗаписатьВЛог("PAPI.Информация", Перечисления.PAPI_ТипЛога.Информация, 
//					"Выполнен алгоритм :" + ПараметрыРегистра.Алгоритм.ИмяАлгоритма, "PAPI_АсинхронныеОперации.ВыполнитьАлгоритмИзОчередиАлгоритмов");
//					
//			Иначе
//				
//				ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", Символы.ПС) 
//					+ "Ошибка выполнения алгоритма: " + ПараметрыРегистра.Алгоритм.ИмяАлгоритма + СтруктураВозврата.ТекстОшибки;
//							
//				PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, 
//					"PAPI_АсинхронныеОперации.ВыполнитьАлгоритмИзОчередиАлгоритмов");			
//								
//			КонецЕсли;
//			
//			ПараметрыРегистра.Вставить("ДатаОкончания",	ТекущаяДатаСеанса());	
//			ПараметрыРегистра.Вставить("Выполнен",		СтруктураВозврата.Отработал);
//			ПараметрыРегистра.Вставить("Ошибка",	 	Не СтруктураВозврата.Отработал);
//            ПараметрыРегистра.Вставить("ТекстОшибки",	ТекстОшибки);

//			
//			// Записываем в регистр информацию по выполнению
//		    РегистрыСведений.PAPI_ОчередьАлгоритмовДляФоновогоВыполнения.ДобавитьИзменитьЗапись(ПараметрыРегистра);
//		
//		Иначе
//		
//			PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, 
//				"PAPI_АсинхронныеОперации.ВыполнитьАлгоритмИзОчередиАлгоритмов");		
//				
//		КонецЕсли;	
//	Иначе  
//			
//		ТекстОшибки = НСтр("ru = 'Запись не является Структурой'; en = 'Record is not a Structure'");		
//		PAPI_Логирование.ЗаписатьВЛог("PAPI.Ошибка", Перечисления.PAPI_ТипЛога.Ошибка, ТекстОшибки, "PAPI_АсинхронныеОперации.ВыполнитьАлгоритмИзОчередиАлгоритмов");
//			
//	КонецЕсли;   
//		
//		
//	Если ВключенПривилегированныйРежим Тогда 
//		ВключенПривилегированныйРежим = Ложь;
//		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
//	КонецЕсли;
//	
//КонецПроцедуры	     

#КонецОбласти

