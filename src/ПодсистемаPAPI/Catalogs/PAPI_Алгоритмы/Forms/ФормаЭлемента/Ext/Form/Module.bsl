﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда 
	// Создан копированием++
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования)
			И ТипЗнч(Параметры.ЗначениеКопирования) = Тип("СправочникСсылка.PAPI_Алгоритмы") Тогда	
			
			ПриЧтенииНаСервере(Параметры.ЗначениеКопирования);
				
		КонецЕсли;
	// Создан копированием--	
	КонецЕсли;		
	
	// КонсольКода Монако
	КонсольКодаДоступна = PAPI_ОбщегоНазначенияВызовСервера.ПодсистемаСуществует("PAPI.PAPI_КонсольКода");
	Элементы.КодАлгоритма.КнопкаОткрытия = КонсольКодаДоступна;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Объект.ЭтоГруппа Тогда
		ПоместитьСтруктураАлгоритмаВНастройки(ТекущийОбъект);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не ТекущийОбъект.ЭтоГруппа Тогда

		СтруктураНастройки = PAPI_РаботаСАлгоритмами.СтруктураНастроекАлгоритма(ТекущийОбъект.Настройки);

		Если СтруктураНастройки.Свойство("СА_КодАлгоритма") Тогда
			КодАлгоритма = СтруктураНастройки.СА_КодАлгоритма;	
		КонецЕсли;	
		
		Если СтруктураНастройки.Свойство("СА_ПараметрыАлгоритма") Тогда
			ПараметрыАлгоритма.Загрузить(СтруктураНастройки.СА_ПараметрыАлгоритма);	
		КонецЕсли;	
	КонецЕсли;	
		
КонецПроцедуры

#КонецОбласти 


#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыАлгоритма

&НаКлиенте
Процедура ПараметрыАлгоритмаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыАлгоритма.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.Вычисляемый Тогда 
		 
		ТекущийПроизвольныйКод = ТекущиеДанные.ПроизвольныйКод;
		
		// КонсольКода Монако
		Элементы.ТекущийПроизвольныйКод.КнопкаОткрытия = КонсольКодаДоступна;
	Иначе
		
		ТекущийПроизвольныйКод = ""; 
		
		// КонсольКода Монако
		Элементы.ТекущийПроизвольныйКод.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийПроизвольныйКодПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыАлгоритма.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено 
		И ТекущиеДанные.Вычисляемый Тогда
		
		ТекущиеДанные.ПроизвольныйКод = ТекущийПроизвольныйКод;  
		
	Иначе   
		
		ТекущиеДанные.ПроизвольныйКод = "";
		
	КонецЕсли;                         

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАлгоритмаПроизвольныйКодПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыАлгоритма.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено 
		И ТекущиеДанные.Вычисляемый Тогда
		
		ТекущийПроизвольныйКод = ТекущиеДанные.ПроизвольныйКод;  
		
		// КонсольКода Монако
		Элементы.ТекущийПроизвольныйКод.КнопкаОткрытия = КонсольКодаДоступна;
	Иначе   
		
		ТекущийПроизвольныйКод = "";
		
		// КонсольКода Монако
		Элементы.ТекущийПроизвольныйКод.КнопкаОткрытия = Ложь;
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАлгоритмаВычисляемыйПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыАлгоритма.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено 
		И ТекущиеДанные.Вычисляемый Тогда
		
		ТекущийПроизвольныйКод = ТекущиеДанные.ПроизвольныйКод;  
		
		// КонсольКода Монако
		Элементы.ТекущийПроизвольныйКод.КнопкаОткрытия = КонсольКодаДоступна;
	Иначе   
		
		ТекущийПроизвольныйКод = "";
		
		// КонсольКода Монако
		Элементы.ТекущийПроизвольныйКод.КнопкаОткрытия = Ложь;
	КонецЕсли; 
	
КонецПроцедуры


#КонецОбласти

#Область КонсольКода


&НаКлиенте
Процедура КодАлгоритмаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Элемент.КнопкаОткрытия Тогда 
		ОткрытьФормуРедактированияКода(Элемент, СтандартнаяОбработка);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ТекущийПроизвольныйКодОткрытие(Элемент, СтандартнаяОбработка) 
	
	Если Элемент.КнопкаОткрытия Тогда 
		ОткрытьФормуРедактированияКода(Элемент, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Функция ОткрытьФормуРедактированияКода(Элемент, СтандартнаяОбработка, ПользовательскиеОбъектыПодсказки = Неопределено)
	
	СтандартнаяОбработка = Ложь;
	ПарамОткрытия = Новый Структура;
	ПарамОткрытия.Вставить("Заголовок", Элемент.Заголовок);
	ПарамОткрытия.Вставить("ТекстАлгоритма", Элемент.ТекстРедактирования);	
	
	ПарамОткрытия.Вставить("ПользовательскиеОбъекты", ПользовательскиеОбъектыПодсказки);
	
	ОткрытьФорму("Обработка.PAPI_КонсольКода.Форма.Форма", 
			ПарамОткрытия, 
			ЭтотОбъект, 
			, 
			, 
			, 
			Новый ОписаниеОповещения("ОкончаниеРедактированиеКода", ЭтотОбъект, Элемент.Имя), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);    
	
КонецФункции

&НаКлиенте
Процедура ОкончаниеРедактированиеКода(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ДопПараметры] = Результат;
	Модифицированность = Истина; 
	
	Если ДопПараметры = "ТекущийПроизвольныйКод" Тогда 
		ТекущийПроизвольныйКодПриИзменении(Элементы.ТекущийПроизвольныйКод);	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПоместитьСтруктураАлгоритмаВНастройки(ТекущийОбъект)
		
// СтруктураАлгоритма ++		                    
	СтруктураДанных = Новый Структура;
	СтруктураАлгоритма = Новый Структура;
	СтруктураАлгоритма.Вставить("КодАлгоритма",КодАлгоритма);
	
	СтруктураАлгоритма.Вставить("ПараметрыАлгоритма", ПараметрыАлгоритма.Выгрузить(,"Имя, Значение, Вычисляемый, ПроизвольныйКод"));
	
	СтруктураДанных.Вставить("СтруктураАлгоритма", СтруктураАлгоритма);
// СтруктураАлгоритма --

	ДанныеXML = PAPI_ОбщегоНазначенияВызовСервера.СериализаторXML(СтруктураДанных);
	ТекущийОбъект.Настройки = Новый ХранилищеЗначения(?(ДанныеXML.Отработал, ДанныеXML.Результат, ""));
	
КонецПроцедуры 


#КонецОбласти