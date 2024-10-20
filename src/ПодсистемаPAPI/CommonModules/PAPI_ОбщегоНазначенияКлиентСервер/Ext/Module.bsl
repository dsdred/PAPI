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

#Область СообщенияКлиенту

// Краткое сообщение пользователю
//
// Параметры:
//  Текст	 - Строка	 - Текст сообщения
//  Поле	 - Строка	 - Поле в котором есть ошибка (Необязательна)
//
Процедура КраткоеСообщениеПользователю(Текст, Поле = "") Экспорт
       
	Сообщение 		= Новый СообщениеПользователю;
	Сообщение.Текст = Текст;  
	
	Если Не ПустаяСтрока(Поле) Тогда 
		Сообщение.Поле 	= Поле; 
	КонецЕсли;
	
	Сообщение.Сообщить();

КонецПроцедуры  

#КонецОбласти

#Область РаботаСДеревомНаФорме

 // Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - Пометка хранится в числовой колонке "Пометка".
//
Процедура ИзменениеПометки(ДанныеСтроки) Экспорт
	
	ДанныеСтроки.Пометка = ДанныеСтроки.Пометка % 2;
	ПроставитьПометкиВниз(ДанныеСтроки);
	ПроставитьПометкиВверх(ДанныеСтроки); 
	
КонецПроцедуры

// Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - Пометка хранится в числовой колонке "Пометка".
//
Процедура ПроставитьПометкиВниз(ДанныеСтроки) Экспорт  
	
	Значение = ДанныеСтроки.Пометка;
	Для Каждого Потомок Из ДанныеСтроки.ПолучитьЭлементы() Цикл
		Потомок.Пометка = Значение;
		ПроставитьПометкиВниз(Потомок);
	КонецЦикла; 
	
КонецПроцедуры

// Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - Пометка хранится в числовой колонке "Пометка".
//
Процедура ПроставитьПометкиВверх(ДанныеСтроки) Экспорт
	
	РодительСтроки = ДанныеСтроки.ПолучитьРодителя();
	Если РодительСтроки <> Неопределено Тогда
		ВсеИстина = Истина;
		НеВсеЛожь = Ложь;
		Для Каждого Потомок Из РодительСтроки.ПолучитьЭлементы() Цикл
			ВсеИстина = ВсеИстина И (Потомок.Пометка = 1);
			НеВсеЛожь = НеВсеЛожь Или Булево(Потомок.Пометка);
		КонецЦикла;
		Если ВсеИстина Тогда
			РодительСтроки.Пометка = 1;
		ИначеЕсли НеВсеЛожь Тогда
			РодительСтроки.Пометка = 2;
		Иначе
			РодительСтроки.Пометка = 0;
		КонецЕсли;
		ПроставитьПометкиВверх(РодительСтроки);
	КонецЕсли;  
	
КонецПроцедуры       

#КонецОбласти 

#Область РаботаСФормой

// Устанавливает свойство ИмяСвойства элемента формы с именем ИмяЭлемента в значение Значение.
// Применяется в тех случаях, когда элемента формы может не быть на форме из-за отсутствия прав у пользователя
// на объект, реквизит объекта или команду.
//
// Параметры:
//  ЭлементыФормы - ВсеЭлементыФормы
//                - ЭлементыФормы - коллекция элементов управляемой формы.
//  ИмяЭлемента   - Строка       - имя элемента формы.
//  ИмяСвойства   - Строка       - имя устанавливаемого свойства элемента формы.
//  Значение      - Произвольный - новое значение элемента.
// 
Процедура УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение) Экспорт
	
	ЭлементФормы = ЭлементыФормы.Найти(ИмяЭлемента);
	Если ЭлементФормы <> Неопределено И ЭлементФормы[ИмяСвойства] <> Значение Тогда
		ЭлементФормы[ИмяСвойства] = Значение;
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти 

#Область РаботаСФайлами

// Составляет полное имя файла из имени каталога и имени файла.
//
// Параметры:
//  ИмяКаталога  - Строка - путь к каталогу файла на диске.
//  ИмяФайла     - Строка - имя файла, без имени каталога.
//
// Возвращаемое значение:
//   Строка
//
Функция ПолучитьПолноеИмяФайла(Знач ИмяКаталога, Знач ИмяФайла) Экспорт

	Если НЕ ПустаяСтрока(ИмяФайла) Тогда
		
		Слэш = "";
		Если (Прав(ИмяКаталога, 1) <> "\") И (Прав(ИмяКаталога, 1) <> "/") Тогда
			Слэш = ?(СтрНайти(ИмяКаталога, "\") = 0, "/", "\");
		КонецЕсли;
		
		Возврат ИмяКаталога + Слэш + ИмяФайла;
		
	Иначе
		
		Возврат ИмяКаталога;
		
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область РаботаСоСтруктурами

// Возвращает значение свойства структуры.
//
// Параметры:
//   Структура - Структура
//             - ФиксированнаяСтруктура - объект, из которого необходимо прочитать значение ключа.
//   Ключ - Строка - имя свойства структуры, для которого необходимо прочитать значение.
//   ЗначениеПоУмолчанию - Произвольный - возвращается когда в структуре нет значения по указанному
//                                        ключу.
//
// Возвращаемое значение:
//   Произвольный - значение свойства структуры. ЗначениеПоУмолчанию если в структуре нет указанного свойства.
//
Функция СвойствоСтруктуры(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если Структура = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Результат = ЗначениеПоУмолчанию;
	Если Структура.Свойство(Ключ, Результат) Тогда
		Возврат Результат;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ТекущееОкружение

// Возвращает Истина, если клиентское приложение запущено под управлением macOS.
//
//
// Возвращаемое значение:
//  Булево - если нет клиентского приложения, возвращается Ложь.
//
Функция ЭтоMacOSКлиент() Экспорт
	
	ТипПлатформыКлиента = ТипПлатформыКлиента();
	Возврат ТипПлатформыКлиента = ТипПлатформы.MacOS_x86
		Или ТипПлатформыКлиента = ТипПлатформы.MacOS_x86_64;
	
КонецФункции
		
// Возвращает тип платформы клиента.
//
// Возвращаемое значение:
//  ТипПлатформы, Неопределено - тип платформы на которой запущен клиент. В режиме веб-клиента, если тип 
//                               платформы иной, чем описан в типе ТипПлатформы, то возвращается Неопределено.
//
Функция ТипПлатформыКлиента() Экспорт
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Возврат СистемнаяИнфо.ТипПлатформы;
	
КонецФункции	

#КонецОбласти  
