﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление()
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
 
	Если Список.УсловноеОформление.Элементы.Количество() > 0 Тогда 
		Список.УсловноеОформление.Элементы.Очистить();
	КонецЕсли;	
	
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить(); 
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.АнтикБелый);
		
   	ЭлементОтбора                = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Разрешен");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.ПравоеЗначение = Ложь;  				
	
	ЭлементОтбора                = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоГруппа"); 
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Ложь; 
	
	// Оформляемые поля
	МассивИменКолонокДляПодсветки = Новый Массив;
	МассивИменКолонокДляПодсветки.Добавить(Элементы.Наименование.Имя);
	МассивИменКолонокДляПодсветки.Добавить(Элементы.Код.Имя);
	МассивИменКолонокДляПодсветки.Добавить(Элементы.ИмяАлгоритма.Имя);

	Для каждого ТекЭлемент Из МассивИменКолонокДляПодсветки Цикл
	    ОформляемоеПоле      = ЭлементОформления.Поля.Элементы.Добавить();
	    ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ТекЭлемент);
	КонецЦикла;

КонецПроцедуры   

#КонецОбласти 