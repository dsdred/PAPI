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

#Область ПрограммныйИнтерфейс

// Рекурсивно решает Алгоритм
//
// Параметры:
//  Алгоритм			 - СправочникСсылка.PAPI_Алгоритмы - Исполняемый Алгоритм
//  ПараметрыАлгоритма	 - Структура - Входящие параметры
//	ВернутьПараметры     - Булево - Если истина, тогда в СтруктураВозврата добавляются ПараметрыАлгоритма 
// 
// Возвращаемое значение:
//  СтруктураВозврата - Структура
//  Отработал - Булево - Выполнено или нет
//  ТекстОшибки - Строка - Текст ошибки если функция отработала с ошибкой
//  Результат - ЛюбоеЗначение - Данные в формате 1С 
//  ПараметрыАлгоритма - Структура - если ВернутьПараметры = истина тогда возвращаем ПараметрыАлгоритма
//
Функция РешитьАлгоритм(Алгоритм, ПараметрыАлгоритма = Неопределено, ВернутьПараметры = Ложь) Экспорт
	
	СтруктураВозврата = Новый Структура("Результат, Отработал, ТекстОшибки", "", Истина, "");

	Если Не ЗначениеЗаполнено(Алгоритм) Тогда 
		
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr9");
		
		// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Предупреждение, СтруктураВозврата.ТекстОшибки);
		
		Возврат СтруктураВозврата;
		
	КонецЕсли;

	ВключенПривилегированныйРежим = Ложь;
	Если Алгоритм.Привилегированный Тогда 
		Если Не ПривилегированныйРежим() Тогда  
			ВключенПривилегированныйРежим = Истина;
			УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
		КонецЕсли;	
	КонецЕсли;	
	
	Если Не Алгоритм.Разрешен Тогда
		
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr1"); 
		
		// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Предупреждение, СтруктураВозврата.ТекстОшибки, Алгоритм);

		// Запись в РегистрСведений.PAPI_ЛогАлгоритмов
		Если Алгоритм.Логировать Тогда 
			ЗаписатьВЛогАлгоритмов(ТекущаяДатаСеанса()
							,Алгоритм
							,Перечисления.PAPI_ТипЛога.Предупреждение
							,СтруктураВозврата.ТекстОшибки);
		КонецЕсли;
						
		Возврат СтруктураВозврата;	
		
	КонецЕсли;	
	
	Если ПараметрыАлгоритма = Неопределено Тогда 
		ПараметрыАлгоритма = Новый Структура;
	КонецЕсли;	
	
	СтруктураНастройки = СтруктураНастроекАлгоритма(Алгоритм.Настройки);	
	
	// Получаем КодАлгоритма++
	Если СтруктураНастройки.Свойство("СА_КодАлгоритма") Тогда
		
		КодАлгоритма = СтруктураНастройки.СА_КодАлгоритма;
		Если ПустаяСтрока(КодАлгоритма) Тогда
								
			PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr2");   
			
			// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
			PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Ошибка, СтруктураВозврата.ТекстОшибки, Алгоритм);
			
			// Запись в РегистрСведений.PAPI_ЛогАлгоритмов
			Если Алгоритм.Логировать Тогда 
				ЗаписатьВЛогАлгоритмов(ТекущаяДатаСеанса()
								,Алгоритм
								,Перечисления.PAPI_ТипЛога.Ошибка
								,СтруктураВозврата.ТекстОшибки);
			КонецЕсли;
			
			Возврат СтруктураВозврата;
								
		КонецЕсли;	
			
	Иначе 	
		
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr2");  
		
		// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Ошибка, СтруктураВозврата.ТекстОшибки, Алгоритм);
			
		// Запись в РегистрСведений.PAPI_ЛогАлгоритмов	
		Если Алгоритм.Логировать Тогда 
			ЗаписатьВЛогАлгоритмов(ТекущаяДатаСеанса()
							,Алгоритм
							,Перечисления.PAPI_ТипЛога.Ошибка
							,СтруктураВозврата.ТекстОшибки);
		КонецЕсли;
												
		Возврат СтруктураВозврата;
		
	КонецЕсли;	
	// Получаем КодАлгоритма--
	
	// Получаем ПараметрыАлгоритма++
	Если СтруктураНастройки.Свойство("СА_ПараметрыАлгоритма")
		И ТипЗнч(СтруктураНастройки.СА_ПараметрыАлгоритма) = Тип("ТаблицаЗначений") Тогда 	
								
		// Заполняем параметры
		Для Каждого Параметр Из СтруктураНастройки.СА_ПараметрыАлгоритма Цикл
									
			// Проверка, если параметр метода передан, тогда пропускаем
			Если ПараметрыАлгоритма.Свойство(Параметр.Имя) Тогда 
				Продолжить;	
			КонецЕсли;
					
			
			Если Параметр.Вычисляемый Тогда 
				
				// Тут вычисляем параметр по алгоритму
				Результат = "";
				Если Не ПустаяСтрока(Параметр.ПроизвольныйКод) Тогда 									
								
					Выполнить_ПараметрАлгоритма_ПроизвольныйКод(Параметр, ПараметрыАлгоритма, СтруктураВозврата, Результат);
					
					Если Не СтруктураВозврата.Отработал Тогда 
									
						// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
						PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Ошибка, СтруктураВозврата.ТекстОшибки, Алгоритм);

						// Запись в РегистрСведений.PAPI_ЛогАлгоритмов
						Если Алгоритм.Логировать Тогда 
							ЗаписатьВЛогАлгоритмов(ТекущаяДатаСеанса()
											,Алгоритм
											,Перечисления.PAPI_ТипЛога.Ошибка
											,СтруктураВозврата.ТекстОшибки);
						КонецЕсли;

						Возврат СтруктураВозврата; 
						
					КонецЕсли;
					
				КонецЕсли;
					
				ПараметрыАлгоритма.Вставить(Параметр.Имя, Результат);
					
			ИначеЕсли ТипЗнч(Параметр.Значение) = Тип("СправочникСсылка.PAPI_Алгоритмы") Тогда 
									
				влСтруктураВозврата = РешитьАлгоритм(Параметр.Значение, ПараметрыАлгоритма);
				Если влСтруктураВозврата.Отработал Тогда
								
					ПараметрыАлгоритма.Вставить(Параметр.Имя, влСтруктураВозврата.Результат);
										
				Иначе
										
					Массив10Значений = Новый Массив;
					Массив10Значений.Добавить(Параметр.Имя);
					Массив10Значений.Добавить(Параметр.Значение.ИмяАлгоритма);
                    PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr3", Массив10Значений);
					
					// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
					PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Ошибка, СтруктураВозврата.ТекстОшибки, Алгоритм);
			
					// Запись в РегистрСведений.PAPI_ЛогАлгоритмов
					Если Алгоритм.Логировать Тогда 
						ЗаписатьВЛогАлгоритмов(ТекущаяДатаСеанса()
										,Алгоритм
										,Перечисления.PAPI_ТипЛога.Ошибка
										,СтруктураВозврата.ТекстОшибки);
					КонецЕсли;  
									
					Возврат влСтруктураВозврата;
										
				КонецЕсли;		
					
			Иначе   
					
			   	ПараметрыАлгоритма.Вставить(Параметр.Имя, Параметр.Значение);  
					
			КонецЕсли;
											
	    КонецЦикла;
											
	КонецЕсли;
	// Получаем ПараметрыАлгоритма--
	
	
	// Выполняем код из КодАлгоритма++  
	Выполнить_КодАлгоритма(КодАлгоритма, ПараметрыАлгоритма, СтруктураВозврата);	
	
	Если Не СтруктураВозврата.Отработал Тогда 
		
		// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Алгоритмы.РешитьАлгоритм", Перечисления.PAPI_ТипЛога.Ошибка, СтруктураВозврата.ТекстОшибки, Алгоритм);

		// Запись в РегистрСведений.PAPI_ЛогАлгоритмов
		Если Алгоритм.Логировать Тогда 
			ЗаписатьВЛогАлгоритмов(ТекущаяДатаСеанса()
							,Алгоритм
							,Перечисления.PAPI_ТипЛога.Ошибка
							,СтруктураВозврата.ТекстОшибки);
		КонецЕсли;  
					
	КонецЕсли;
	// Выполняем код из КодАлгоритма--
	
	Если ВернутьПараметры Тогда 
		СтруктураВозврата.Вставить("ПараметрыАлгоритма", ПараметрыАлгоритма); 		
	КонецЕсли;	
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции  

// Описание см. РешитьАлгоритм
//
// Параметры:
//  Параметр		- СтрокаТаблицыЗначений:
//		Имя 		- Строка - Ключ параметра
//		Значение 	- ЛюбоеЗначение - Данные в формате 1С  
//		Вычисляемый - Булево - Признак того что нужно выполнить произвольный код
//		ПроизвольныйКод - Строка - Произвольный код при выполнение которого получаем "Результат"
//  ПараметрыАлгоритма	 - Структура - Входящие параметры 
//  СтруктураВозврата 	- Структура
//  	Отработал 	- Булево - Выполнено или нет
// 		ТекстОшибки - Строка - Текст ошибки если функция отработала с ошибкой
//   
//  Результат - ЛюбоеЗначение - Данные в формате 1С
//
Процедура Выполнить_ПараметрАлгоритма_ПроизвольныйКод(Параметр, ПараметрыАлгоритма, СтруктураВозврата, Результат = "")
						
	Попытка
		
		Если Не ПустаяСтрока(Параметр.ПроизвольныйКод) Тогда 
			// Вычисляем "Результат" 
			Выполнить(Параметр.ПроизвольныйКод);
		КонецЕсли;	
			
	Исключение
																			
		СтруктураВозврата.Отработал = Ложь; 
						
		Массив10Значений = Новый Массив;
		Массив10Значений.Добавить(Параметр.Имя);
		Массив10Значений.Добавить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr4", Массив10Значений);
						
	КонецПопытки;
	
КонецПроцедуры

// Описание см. РешитьАлгоритм
//
// Параметры:
//  КодАлгоритма		 - Строка - Произвольный код алгоритма
//  ПараметрыАлгоритма	 - Структура - Входящие параметры 
//  СтруктураВозврата 	- Структура
//  	Отработал 	- Булево - Выполнено или нет
// 		ТекстОшибки - Строка - Текст ошибки если функция отработала с ошибкой
//		Результат 	- ЛюбоеЗначение - Данные в формате 1С  
//
Процедура Выполнить_КодАлгоритма(КодАлгоритма, ПараметрыАлгоритма, СтруктураВозврата)
	
	Результат = "";
	Попытка
		
		Если Не ПустаяСтрока(КодАлгоритма) Тогда 					
			Выполнить(КодАлгоритма);
		КонецЕсли;
		
		СтруктураВозврата.Результат = Результат;
		//СтруктураВозврата.Отработал = Истина;
							
	Исключение
		
		СтруктураВозврата.Отработал = Ложь;
		
		Массив10Значений = Новый Массив;
		Массив10Значений.Добавить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "ALErr5", Массив10Значений); 
		
	КонецПопытки;
	
КонецПроцедуры

// Получаем структуру настроек справочника PAPI_Алгоритмы
//
// Параметры:
//  Настройки - ХранилищеЗначения
// 
// Возвращаемое значение:
//  СтруктураДанных - Структура
//
Функция СтруктураНастроекАлгоритма(Настройки) Экспорт
	
	СтруктураДанных = Новый Структура;
	
	Если ТипЗнч(Настройки) = Тип("ХранилищеЗначения") Тогда
		перСтруктураНастройки = Настройки.Получить();
			
		Если перСтруктураНастройки <> Неопределено Тогда
			
			РезультатXML 		= PAPI_ОбщегоНазначенияВызовСервера.ДесериализаторXML(перСтруктураНастройки);	
			СтруктураНастройки 	= ?(РезультатXML.Отработал, РезультатXML.Результат, Неопределено);
			
			Если СтруктураНастройки <> Неопределено Тогда 
				Если ТипЗнч(СтруктураНастройки) = Тип("Структура") Тогда
					
#Область ЗаполняемСтруктуруДанных
					Если СтруктураНастройки.Свойство("СтруктураАлгоритма") Тогда 
							
						СтруктураАлгоритма =  СтруктураНастройки.СтруктураАлгоритма;
							
						Если ТипЗнч(СтруктураАлгоритма) = Тип("Структура") Тогда
								
							Если СтруктураАлгоритма.Свойство("КодАлгоритма") Тогда
									
								СтруктураДанных.Вставить("СА_КодАлгоритма", СтруктураАлгоритма.КодАлгоритма); 							
									
							КонецЕсли;
								
							Если СтруктураАлгоритма.Свойство("ПараметрыАлгоритма") Тогда
								Если ТипЗнч(СтруктураАлгоритма.ПараметрыАлгоритма) = Тип("ТаблицаЗначений") Тогда 
									СтруктураДанных.Вставить("СА_ПараметрыАлгоритма",СтруктураАлгоритма.ПараметрыАлгоритма);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;			
#КонецОбласти					
					
				КонецЕсли; 
			КонецЕсли; 
				
		КонецЕсли; 	
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

#Область Логирование

// Логирование Алгоритмов (РегистрыСведений.PAPI_ЛогАлгоритмов)
// Параметры:
//  ДатаВремя - Дата и время записи
//  Алгоритм - Выполняемый алгоритм
//  ТипЛога - Статус (Тип сообщения)
//  Информация - Текст лога
Процедура ЗаписатьВЛогАлгоритмов(ДатаВремя  = Неопределено
								,Алгоритм	= Неопределено
								,ТипЛога	= Неопределено
								,Информация	= "")
								
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	
							
	ТекущаяДата = ?(Не ЗначениеЗаполнено(ДатаВремя),ТекущаяДатаСеанса(),ДатаВремя);
	Если Не ЗначениеЗаполнено(Алгоритм) Тогда 
		Алгоритм = Справочники.PAPI_Алгоритмы.ПустаяСсылка();	
	КонецЕсли;	 
	
	Если Не ЗначениеЗаполнено(ТипЛога) Тогда 
		ТипЛога = Перечисления.PAPI_ТипЛога.Примечание;
	КонецЕсли;	
	
	БылаОшибка = Ложь;
	Попытка 
				
		НаборЗаписей = РегистрыСведений.PAPI_ЛогАлгоритмов.СоздатьНаборЗаписей();  			
		НаборЗаписей.Отбор.ДатаВремя.Установить(ТекущаяДата);
		НаборЗаписей.Отбор.Алгоритм.Установить(Алгоритм);
		НаборЗаписей.Отбор.ТипЛога.Установить(ТипЛога);
		НаборЗаписей.Прочитать();	
        
		Если НаборЗаписей.Количество() = 0 Тогда
			НоваяЗаписьРегистра = НаборЗаписей.Добавить();

			НоваяЗаписьРегистра.ДатаВремя 		= ТекущаяДата;
			НоваяЗаписьРегистра.Алгоритм 		= Алгоритм;
			НоваяЗаписьРегистра.ТипЛога 		= ТипЛога;
			
		Иначе
			НоваяЗаписьРегистра = НаборЗаписей[0];
		КонецЕсли;
				
		НоваяЗаписьРегистра.Информация = Информация;
		
		НаборЗаписей.Записать();
						
	Исключение	
		
		БылаОшибка = Истина;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Если БылаОшибка Тогда  
		
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Логирование.Алгоритмы", ТипЛога, ТекстОшибки, Алгоритм);
			
	КонецЕсли;	
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти


#КонецОбласти


