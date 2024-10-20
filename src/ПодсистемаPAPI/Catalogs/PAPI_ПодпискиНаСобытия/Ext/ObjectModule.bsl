﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий 

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда 
		
		Если Не ЭтоНовый() Тогда
			 
			Если Источники.Количество() > 0 Тогда  	
				PAPI_ОбщегоНазначенияВызовСервера.УбратьДублиВТабличнойЧасти(Источники, "Источник", Ложь); 
			КонецЕсли;
			
			// Передаем в чистку данные до изменения
			Если Ссылка.Источники.Количество() > 0 Тогда 
				ДополнительныеСвойства.Вставить("ИсточникиДляОчищения", Ссылка.Источники.Выгрузить());
				ДополнительныеСвойства.Вставить("СобытиеДоЗаписи",  Ссылка.Событие); 		
			КонецЕсли;
			
		КонецЕсли;     
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		// Очистить старые данные, если они были
		Если ДополнительныеСвойства.Свойство("ИсточникиДляОчищения") Тогда
			Для Каждого ДанныеДляОчистки Из ДополнительныеСвойства.ИсточникиДляОчищения Цикл
				РегистрыСведений.PAPI_ИсполнителиПодписок.ОчиститьЗаписиПоИзмерениям(
											ДанныеДляОчистки.Источник, ДополнительныеСвойства.СобытиеДоЗаписи, Ссылка
				);
			КонецЦикла;
		КонецЕсли;
		
		// Добавить новые данные
		Если ЭтотОбъект.Разрешен И Не ЭтотОбъект.ПометкаУдаления Тогда
			Для Каждого ДанныеНаДобавление Из Источники Цикл			
				РегистрыСведений.PAPI_ИсполнителиПодписок.ДобавитьЗапись(ДанныеНаДобавление.Источник, Событие, Ссылка);
			КонецЦикла;
		Иначе
			// Почистить все данные
			УдалитьВсеИсполнители();
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	УдалитьВсеИсполнители();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура УдалитьВсеИсполнители()
	
	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;
	
	
	Если Не Метаданные.РегистрыСведений.Найти("PAPI_ИсполнителиПодписок") = Неопределено Тогда 
		РегистрыСведений.PAPI_ИсполнителиПодписок.УдалитьВсеИсполнители(Ссылка);	
	КонецЕсли;	
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.PAPI_ИсполнителиПодписок КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Подписка = &Подписка
	|");
	Запрос.УстановитьПараметр("Подписка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.PAPI_ИсполнителиПодписок.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти



#КонецЕсли
