﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий 

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда 
		
		Если Источники.Количество() > 0 Тогда 
			PAPI_ОбщегоНазначенияВызовСервера.УбратьДублиВТабличнойЧасти(Источники, "Источник", Ложь); 		
		КонецЕсли;     
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
