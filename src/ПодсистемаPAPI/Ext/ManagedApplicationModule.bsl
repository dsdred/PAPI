﻿ 
#Область ОписаниеПеременных

// Хранилище глобальных переменных.
//
// PAPI_ПараметрыПриложения - Соответствие из КлючИЗначение:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Пример инициализации:
//   ИмяПараметра = "ПереченьПодписокНаСобытие";
//   Если PAPI_ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     PAPI_ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Пример использования:
//   PAPI_ПараметрыПриложения["ПереченьПодписокНаСобытие"].Добавить(...);    
//
Перем PAPI_ПараметрыПриложения Экспорт;

#КонецОбласти
 
&После("ПередНачаломРаботыСистемы")
Процедура PAPI_ПередНачаломРаботыСистемы()   
	
	// Инициализация глобальных параметров
	Если PAPI_ПараметрыПриложения = Неопределено Тогда
		PAPI_ПараметрыПриложения = Новый Соответствие;
	КонецЕсли;
	
	PAPI_ДанныеДляЗаполненияНастроек.ПередНачаломРаботыСистемы();
	
КонецПроцедуры
