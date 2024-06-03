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

// Процедура - Обработка входящих сообщений из Сервиса интеграций
//
// Параметры:
//  Сообщение	 - СообщениеСервисаИнтеграции - Сообщения пришедшее из сервиса интеграции
//  Отказ		 - Булево - Признак отказа от выполнения действия 
//
Процедура ОбработкаВходящихСообщений(Сообщение, Отказ) Экспорт 

// СтруктураВходныхПараметров ++

	// Подготавливаем структуру из запроса
	СтруктураВходныхПараметров = Новый Структура;

	// Забираем свойства сообщения
	перСвойстваСообщения = Новый Структура;
	перСвойстваСообщения.Вставить("ДатаОтправки", 	Сообщение.ДатаОтправки);
	перСвойстваСообщения.Вставить("ДатаУстаревания",Сообщение.ДатаУстаревания);
	
	перСвойстваСообщения.Вставить("Идентификатор", 	Сообщение.Идентификатор);
	перСвойстваСообщения.Вставить("ИдентификаторСообщенияЗапроса", 	
													Сообщение.ИдентификаторСообщенияЗапроса);
	
	перСвойстваСообщения.Вставить("КодОтправителя", Сообщение.КодОтправителя);
	перСвойстваСообщения.Вставить("КодПолучателя", 	Сообщение.КодПолучателя);
	
	// Массив Типы для обмена 	
	МассивПолей = ДополнительныеСвойстваОбмена();
	
	Для Каждого элМассива Из МассивПолей Цикл                   
				
		Если Сообщение.Параметры.Получить(элМассива) <> Неопределено Тогда
				
			перСвойстваСообщения.Вставить(элМассива, Сообщение.Параметры[элМассива]);
					
		КонецЕсли;	
			
	КонецЦикла;  
	
	// Доступен, начиная с версии 8.3.21.
	// перСвойстваСообщения.Вставить("РазмерТела", Сообщение.РазмерТела);
	РазмерСообщения = Сообщение.Параметры.Получить("РазмерСообщения");
	Если РазмерСообщения <> Неопределено Тогда
		РазмерБуфера = Число(РазмерСообщения); 
	Иначе
		РазмерБуфера = 1024;    
	КонецЕсли;

	перСвойстваСообщения.Вставить("РазмерТела", РазмерБуфера);  
		
	СтруктураВходныхПараметров.Вставить("СвойстваСообщения", перСвойстваСообщения);
	
	
	// Читаем тело сообщения++         
	Если РазмерБуфера = 0 Тогда 
		
		ВходящееСообщение = "";
		
	Иначе
		
		Тело  = Новый БуферДвоичныхДанных(0);
		Буфер = Новый БуферДвоичныхДанных(РазмерБуфера);
		Поток = Сообщение.ПолучитьТелоКакПоток();	
		
		Пока Истина Цикл
			
			Прочитано = Поток.Прочитать(Буфер, 0, РазмерБуфера);
			
			Если Прочитано > 0 Тогда
				
				Тело = Тело.Соединить(Буфер);  
				
			КонецЕсли;   
			
			Если Прочитано < РазмерБуфера Тогда
				
				Прервать; 
				
	 		КонецЕсли; 
			
		КонецЦикла; 
		
		ВходящееСообщение = ПолучитьСтрокуИзБуфераДвоичныхДанных(Тело);   
		
	КонецЕсли;
		 
	СтруктураВходныхПараметров.Вставить("ТелоСообщения", ВходящееСообщение);
    // Читаем тело сообщения--

	
	// Забираем параметры сообщения
	перПараметрыСообщения = Новый Структура;
	Для Каждого текПараметр Из Сообщение.Параметры Цикл
		
		перПараметрыСообщения.Вставить(СокрЛП(текПараметр.Ключ), текПараметр.Значение);
		
	КонецЦикла;        
	
	СтруктураВходныхПараметров.Вставить("ПараметрыСообщения", перПараметрыСообщения);
	
// СтруктураВходныхПараметров --	

	ПодготовитьЧтениеИПрочитатьСообщение(СтруктураВходныхПараметров);
		
КонецПроцедуры	  

// Процедура - Подготовить чтение и прочитать сообщение
//
// Параметры:
//  СтруктураВходныхПараметров	 - Структура - См. PAPI_РаботаСВходящимиСообщениями.ОбработкаВходящихСообщений
//	ЗаписатьВРегистр - Булево - Если нужно сделать запись в регистр сведений PAPI_ВходящиеСообщенияСервисаИнтеграции
//								независимо от фунциональной опции "PAPI_ЛогированиеВходящихСообщенийСервисаИнтеграции"
//
Процедура ПодготовитьЧтениеИПрочитатьСообщение(СтруктураВходныхПараметров, ЗаписатьВРегистр = Ложь) Экспорт 
	
	перСвойстваСообщения = СтруктураВходныхПараметров.СвойстваСообщения;
	
	// Отправитель нужен для "Чтения Сообщения"
	Отправитель = Справочники.PAPI_Участники.ПолучитьУчастникаПоИмени(СтруктураВходныхПараметров.СвойстваСообщения.КодОтправителя);	 
	ТипСообщения= ?(СтруктураВходныхПараметров.СвойстваСообщения.Свойство("ТипСообщения"),
			СтруктураВходныхПараметров.СвойстваСообщения.ТипСообщения, "");				
			
	// Ищем элемент справочника отвечающий за чтение сообщения 
	текЧтениеСообщений = ПоискЧтенияСообщения(Отправитель, ТипСообщения); 	
	
	// Выполняем чтение сообщения
	СтруктураВозврата = ПрочитатьСообщение(текЧтениеСообщений, СтруктураВходныхПараметров);			
	
	Если СтруктураВозврата.Отработал Тогда 
		
		Если ПолучитьФункциональнуюОпцию("PAPI_ЛогированиеВходящихСообщенийСервисаИнтеграции")
			Или ЗаписатьВРегистр Тогда 
			перСвойстваСообщения.Вставить("ДанныеПрочитаны", Истина);
			перСвойстваСообщения.Вставить("ДатаЧтения", ТекущаяДатаСеанса()); 
			перСвойстваСообщения.Вставить("ТекстОшибки","");
		    РегистрыСведений.PAPI_ВходящиеСообщенияСервисаИнтеграции.ДобавитьИзменитьЗапись(перСвойстваСообщения, СтруктураВходныхПараметров);
		КонецЕсли;	
		
	Иначе
		
		перСвойстваСообщения.Вставить("ДанныеПрочитаны", Ложь);
		перСвойстваСообщения.Вставить("ДатаЧтения", 	ТекущаяДатаСеанса());
        перСвойстваСообщения.Вставить("ТекстОшибки", 	СтруктураВозврата.ТекстОшибки);
		
		РегистрыСведений.PAPI_ВходящиеСообщенияСервисаИнтеграции.ДобавитьИзменитьЗапись(перСвойстваСообщения, СтруктураВходныхПараметров);	
	КонецЕсли;
	
КонецПроцедуры	

// Функция - Прочитать сообщение
//
// Параметры:
//  ЧтениеСообщений				 - СправочникСсылка.PAPI_ЧтениеСообщений - Содержит алгоритм чтения сообщения
//  СтруктураВходныхПараметров	 - Структура - Структура состоящая из параметров входящего сообщения 
// 
// Возвращаемое значение:
//  СтруктураВозврата - Результат, Отработал, ТекстОшибки
//
Функция ПрочитатьСообщение(Знач ЧтениеСообщений, Знач СтруктураВходныхПараметров = Неопределено ) Экспорт
	
	СтруктураВозврата = Новый Структура("Результат, Отработал, ТекстОшибки", "", Истина, "");
	
	Если Не ЗначениеЗаполнено(ЧтениеСообщений) Тогда 
		
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "RMErr1");
		
		// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Сообщения.ПрочитатьСообщение", Перечисления.PAPI_ТипЛога.Предупреждение, СтруктураВозврата.ТекстОшибки);
		
		Возврат СтруктураВозврата;
		
	КонецЕсли;	
	
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;	

	Если Не ЧтениеСообщений.Разрешен Тогда
		
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "RMErr2"); 
		
		// Запись в журнал сообщения см. Справочник.PAPI_ШаблоныСообщений.Макет.СтандартныеСообщения
		PAPI_Логирование.ЗаписатьВЛог("PAPI.Сообщения.ПрочитатьСообщение", СтруктураВозврата.ТекстОшибки, ЧтениеСообщений);
		
		// TODO: сделать лог?
		// Запись в РегистрСведений.PAPI_ЛогЧтениеСообщений
		// Если ЧтениеСообщений.Логировать Тогда 
		//	PAPI_Логирование.ЗаписатьВЛогЧтениеСообщений(ТекущаяДатаСеанса()
		//					,ЧтениеСообщений
		//					,Перечисления.PAPI_ТипЛога.Предупреждение
		//					,СтруктураВозврата.ТекстОшибки);
		// КонецЕсли;
						
		Возврат СтруктураВозврата;	
		
	КонецЕсли;	

	Если СтруктураВходныхПараметров = Неопределено Тогда 
		СтруктураВходныхПараметров = Новый Структура;
	КонецЕсли;
		
	Если ЧтениеСообщений.ТипВыполнения = ПредопределенноеЗначение("Перечисление.PAPI_ТипВыполнения.Произвольный") Тогда	 
		
		СтруктураНастройки = СтруктураНастроекЧтенияСообщений(ЧтениеСообщений.Настройки);
		
		Если СтруктураНастройки.Свойство("СП_КодВыполнения") Тогда
			КодВыполнения = СтруктураНастройки.СП_КодВыполнения;	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЧтениеСообщений.КаналОтвета) Тогда 			
			ДобавитьИнформациюПоСервисуОтправки(СтруктураВходныхПараметров, ЧтениеСообщений);
		КонецЕсли;	
		
		
		ВыполнитьПроизвольныйКод(КодВыполнения, СтруктураВходныхПараметров, СтруктураВозврата);
		
		Если Не СтруктураВозврата.Отработал Тогда 
			
			PAPI_Логирование.ЗаписьВЖурналРегистрацииОшибки("PAPI.Сообщения.ВыполнитьПроизвольныйКод", СтруктураВозврата.ТекстОшибки, ЧтениеСообщений);
							
			// TODO: сделать лог?
			// Запись в РегистрСведений.PAPI_ЛогЧтениеСообщений
			// Если ЧтениеСообщений.Логировать Тогда 
			//	PAPI_Логирование.ЗаписатьВЛогЧтениеСообщений(ТекущаяДатаСеанса()
			//					,ЧтениеСообщений
			//					,Перечисления.PAPI_ТипЛога.Предупреждение
			//					,СтруктураВозврата.ТекстОшибки);
			// КонецЕсли;
			
		КонецЕсли;	
		
		
	ИначеЕсли ЧтениеСообщений.ТипВыполнения = ПредопределенноеЗначение("Перечисление.PAPI_ТипВыполнения.Алгоритм") Тогда 
				
		СтруктураВозврата = PAPI_РаботаСАлгоритмами.РешитьАлгоритм(ЧтениеСообщений.Алгоритм, СтруктураВходныхПараметров);
						
	Иначе 
		
		// TODO: ЧтениеСообщений.ТипВыполнения = ПредопределенноеЗначение("Перечисление.PAPI_ТипВыполнения.ВнешняяОбработка") 		
		
	КонецЕсли;
	
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;	
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура ВыполнитьПроизвольныйКод(КодВыполнения, СтруктураВходныхПараметров, СтруктураВозврата)
	
	Результат = "";
	Попытка
								
		Выполнить(КодВыполнения);
		СтруктураВозврата.Результат = Результат;
		
	Исключение
		
		СтруктураВозврата.Отработал = Ложь;
		
		Массив10Значений = Новый Массив;
		// Массив10Значений.Добавить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Массив10Значений.Добавить(ПодробноеПредставлениеОшибки((ИнформацияОбОшибке())));
		PAPI_РаботаСОтветом.ЗаполнитьСтруктуруВозвратаПоКодуОшибки(СтруктураВозврата, "RMErr3", Массив10Значений);
		
	КонецПопытки;

	
КонецПроцедуры                                


#КонецОбласти



#Область СлужебныеПроцедурыИФункции  

// Функция - Дополнительные свойства обмена
// 
// Возвращаемое значение:
//  Массив - Массив свойств для работы с сообщениями
//
Функция ДополнительныеСвойстваОбмена()
	
	МассивДопСвойств = Новый Массив;    
	МассивДопСвойств.Добавить("ТипСообщения");
	МассивДопСвойств.Добавить("ТипОбъекта");
	МассивДопСвойств.Добавить("ИдОбъекта");
	МассивДопСвойств.Добавить("Представление");
	МассивДопСвойств.Добавить("ВидИзменения");
	
	Возврат МассивДопСвойств;
	
КонецФункции	   

// Функция - Структура настроек подписки
//
// Параметры:
//  Настройки - ХранилищеЗначения
// 
// Возвращаемое значение:
//  СтруктураДанных - Структура 
//
Функция СтруктураНастроекЧтенияСообщений(Знач Настройки) Экспорт

	СтруктураДанных = Новый Структура;
	
	Если ТипЗнч(Настройки) = Тип("ХранилищеЗначения") Тогда
		перСтруктураНастройки = Настройки.Получить();
			
		Если перСтруктураНастройки <> Неопределено Тогда
			
			РезультатXML 		= PAPI_ОбщегоНазначенияВызовСервера.ДесериализаторXML(перСтруктураНастройки);	
			СтруктураНастройки 	= ?(РезультатXML.Отработал, РезультатXML.Результат, Неопределено);
			
			Если СтруктураНастройки <> Неопределено Тогда 
				Если ТипЗнч(СтруктураНастройки) = Тип("Структура") Тогда
					
#Область ЗаполняемСтруктуруДанных
					Если СтруктураНастройки.Свойство("СтруктураЧтенияСообщений") Тогда 
							
						СтруктураЧтенияСообщений = СтруктураНастройки.СтруктураЧтенияСообщений;
							
						Если ТипЗнч(СтруктураЧтенияСообщений) = Тип("Структура") Тогда
								
							Если СтруктураЧтенияСообщений.Свойство("КодВыполнения") Тогда
									
								СтруктураДанных.Вставить("СП_КодВыполнения", СтруктураЧтенияСообщений.КодВыполнения); 							
									
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

// Функция - Поиск чтения сообщения
//
// Параметры:
//  Отправитель	 - СправочникСсылка.PAPI_Участники - Имя отправителя 
//  ТипСообщения - Строка - Тип входящего сообщения
// 
// Возвращаемое значение:
//  Результат - СправочникСсылка.PAPI_ЧтениеСообщений 
//
Функция ПоискЧтенияСообщения(Знач Отправитель, Знач ТипСообщения) Экспорт 

	Результат = Справочники.PAPI_ЧтениеСообщений.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	PAPI_ЧтениеСообщений.Ссылка КАК ЧтениеСообщений
		|ИЗ
		|	Справочник.PAPI_ЧтениеСообщений КАК PAPI_ЧтениеСообщений
		|ГДЕ
		|	PAPI_ЧтениеСообщений.Отправитель = &Отправитель
		|	И PAPI_ЧтениеСообщений.ТипСообщения = &ТипСообщения
		|	И НЕ PAPI_ЧтениеСообщений.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Отправитель", Отправитель);
	Запрос.УстановитьПараметр("ТипСообщения", ТипСообщения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ЧтениеСообщений;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

Процедура ДобавитьИнформациюПоСервисуОтправки(СтруктураВходныхПараметров, ЧтениеСообщений)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	PAPI_ЧтениеСообщений.КаналОтвета.Сервис КАК ОтветаСервис,
		|	PAPI_ЧтениеСообщений.КаналОтвета.Канал КАК ОтветаКанал
		|ИЗ
		|	Справочник.PAPI_ЧтениеСообщений КАК PAPI_ЧтениеСообщений
		|ГДЕ
		|	PAPI_ЧтениеСообщений.Ссылка = &ЧтениеСообщений";
	
	Запрос.УстановитьПараметр("ЧтениеСообщений", ЧтениеСообщений);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
    	СервисОтправки = Новый Структура("Сервис, Канал", ВыборкаДетальныеЗаписи.ОтветаСервис, ВыборкаДетальныеЗаписи.ОтветаКанал);
		СтруктураВходныхПараметров.Вставить("СервисОтправки", СервисОтправки);
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти


