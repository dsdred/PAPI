﻿#Область КонсольКода

// Добавлена консоль кода Monaco https://github.com/salexdv/bsl_console 
// На основе разработки https://infostart.ru/1c/tools/1989363/

#КонецОбласти 
 
#Область ПрограммныйИнтерфейс

Функция ДоступнаКонсольКода() Экспорт
	#Если ВебКлиент Тогда
	    Возврат Ложь;
	#ИначеЕсли Клиент Тогда
		Возврат Истина;
	#Иначе
		//Возврат НЕ ОбщегоНазначения.ЭтоВебКлиент();  
		Возврат Истина; // TODO: ТекущийРежимЗапуска() с проверкой на ЭтоВебКлиент	
	#КонецЕсли
КонецФункции

#КонецОбласти

#Область ПараметрыФормыКонсоли

Процедура УстановитьПараметрФормыКонсоли(знач Форма, знач ИмяПараметра, знач ЗначениеПараметра) Экспорт 
	
	Структура = Новый Структура;
	Структура.Вставить(ИмяПараметра, ЗначениеПараметра);
	
	УстановитьПараметрыФормыКонсоли(Форма, Структура); 
	
КонецПроцедуры

Процедура УстановитьПараметрыФормыКонсоли(знач Форма, знач Структура) Экспорт  
	
	ИмяРеквизита	= ИмяРеквизитаПараметрыКонсолиКода();
 	ПараметрыФормы	= Новый Структура(Форма[ИмяРеквизита]);
	
	ЕстьИзменения = Ложь;
	Для Каждого КлючИЗначение Из Структура Цикл
		Если НЕ ПараметрыФормы.Свойство(КлючИЗначение.Ключ) Тогда
			Продолжить;
		ИначеЕсли ПараметрыФормы[КлючИЗначение.Ключ] = КлючИЗначение.Значение Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыФормы[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		
		ЕстьИзменения = Истина;
	КонецЦикла;
	
	Если ЕстьИзменения Тогда
		Форма[ИмяРеквизита] = Новый ФиксированнаяСтруктура(ПараметрыФормы);
	КонецЕсли;  
	
КонецПроцедуры

Функция ИмяПараметрыФормыКонсоли() Экспорт 
	Возврат "pw#console#form";
КонецФункции

Функция ПараметрыФормыКонсоли(знач Форма) Экспорт
	Структура = Новый Структура;
	Структура.Вставить(КлючПараметров()			, ИмяПараметрыФормыКонсоли());
	Структура.Вставить("Версия"					, "20230122");
	Структура.Вставить("УникальныйИдентификатор", Форма.УникальныйИдентификатор);
	Структура.Вставить("КаталогИсходников"		, "");
	Структура.Вставить("КаталогИсходногоКода"	, "");
	Структура.Вставить("АдресМакетаКонсоли"		, "");
	Структура.Вставить("АдресОбщихМодулей"		, "");
	Структура.Вставить("АдресКлиентскихМодулей"	, "");
	Структура.Вставить("АдресСерверныхМодулей"	, "");
	Структура.Вставить("АдресХраненияПеременных", "");
	Структура.Вставить("ИменаОбщихМодулей"		, Неопределено);
	Структура.Вставить("ГлобальныйМодули"		, Неопределено);
	Структура.Вставить("ПоляКонсоли"			, Новый ФиксированнаяСтруктура(Новый Структура));
	Структура.Вставить("ФайлыКонсоли"			, Новый ФиксированныйМассив(Новый Массив));
	
	Возврат Структура;
КонецФункции

Функция ЭтоПараметрыФормыКонсоли(знач Структура) Экспорт
	Возврат ПроверитьСтруктуруПоИмени(Структура, ИмяПараметрыФормыКонсоли());
КонецФункции

Функция ПолучитьПараметрыФормыКонсоли(знач Форма) Экспорт
	Возврат Форма[ИмяРеквизитаПараметрыКонсолиКода()]
КонецФункции

Функция ПолучитьПараметрФормыКонсоли(знач Форма, знач ИмяПараметра) Экспорт
	ПараметрыФормы = ПолучитьПараметрыФормыКонсоли(Форма);
	Если НЕ ЭтоПараметрыФормыКонсоли(ПараметрыФормы) Тогда
		Возврат Неопределено;
	Иначе 
		Возврат ПараметрыФормы[ИмяПараметра];
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область ПараметрыКонсоли

Функция ИмяОбъектКонсоли() Экспорт 
	Возврат "pw#console#data";
КонецФункции

Функция СтруктураОбъектКонсоли() Экспорт
	Структура = Новый Структура;
	Структура.Вставить(КлючПараметров(), ИмяОбъектКонсоли());
	Структура.Вставить("Форма"				, Неопределено);
	Структура.Вставить("ОбъектКонсоли"		, Неопределено);
	Структура.Вставить("ПараметрыФормы"		, Неопределено);
	Структура.Вставить("ПараметрыКонсоли"	, Неопределено);
	
	Возврат Структура;
КонецФункции

Функция ЭтоСтруктураОбъектКонсоли(знач Структура) Экспорт
	Возврат ПроверитьСтруктуруПоИмени(Структура, ИмяОбъектКонсоли());
КонецФункции

Функция УстановитьПараметрКонсоли(знач Форма, знач ИмяРеквизита, знач ИмяПараметра, знач ЗначениеПараметра) Экспорт
	ЗначениеЗаписи		= ПолучитьЗначениеПараметра(ЗначениеПараметра);
	СтрокаПараметров	= ПолучитьСтрокуПараметровКонсоли(Форма, ИмяРеквизита);
	
	СтрокаПараметров[ИмяПараметра] = ЗначениеЗаписи;
КонецФункции

#КонецОбласти

#Область ПараметрыПанелиКонсоли

Функция ИмяПараметрыПанелиКонсоли() Экспорт 
	Возврат "pw#console#commandbar";
КонецФункции

Функция ПараметрыПанелиКонсоли() Экспорт
	Структура = Новый Структура;
	Структура.Вставить(КлючПараметров()		, ИмяПараметрыПанелиКонсоли());
	Структура.Вставить("КонструкторЗапроса"	, Истина);
	Структура.Вставить("Тема"				, Ложь);
	Структура.Вставить("БыстрыеПодсказки"	, Истина);
	Структура.Вставить("ПодсвечиватьЗапросы", Истина);
	Структура.Вставить("КартаКода"			, Истина);
	Структура.Вставить("ПробелыИТабуляции"	, Истина);
	Структура.Вставить("РежимСравнения"		, Истина);
	Структура.Вставить("СтрокаСостояния"	, Истина);
	Структура.Вставить("ИзменятьКомпиляцию"	, Ложь);

	Возврат Структура;
КонецФункции

Функция ЭтоПараметрыПанелиКонсоли(знач Структура) Экспорт
	Возврат ПроверитьСтруктуруПоИмени(Структура, ИмяПараметрыПанелиКонсоли());
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция КлючПараметров() Экспорт
	Возврат "_ssl_tools_";
КонецФункции

Функция ПолучитьСтрокуПараметровКонсоли(знач Форма, знач ИмяРеквизита) Экспорт
	НРегИмяРеквизита = НРег(ИмяРеквизита);
	
	ИмяТаблицы = ИмяТаблицыПараметрыКонсолейКода();
	
	ТаблицаДанных = Форма[ИмяТаблицы];
	
	СтрокаТаблицы = Неопределено;
	Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
		Если СтрокаДанных.ИмяДляСравнения = НРегИмяРеквизита Тогда
			СтрокаТаблицы = СтрокаДанных;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ТаблицаДанных.Добавить();
		СтрокаТаблицы.ИмяДляСравнения	= НРегИмяРеквизита;
		СтрокаТаблицы.ИмяРеквизита		= ИмяРеквизита;
	КонецЕсли;
	
	Возврат СтрокаТаблицы;
КонецФункции

Функция ИмяРеквизитаПараметрыКонсолиКода() Экспорт
	Возврат "pw_ПараметрыФормыКонсоли";
КонецФункции

Функция ИмяРеквизитаВременныеФайлы() Экспорт
	Возврат "pw_ВременныеФайлы";
КонецФункции

Функция ИмяТаблицыПараметрыКонсолейКода() Экспорт
	Возврат "pw_ПараметрыКонсолейКода";
КонецФункции

Функция ПолучитьПутьКФайлуВерсииКонсоли(знач КаталогИсходников, знач Версия) Экспорт
	
	Возврат PAPI_ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогИсходников, Версия + ".ver");;
	
КонецФункции

Функция ПолучитьИмяКаталогаВыгрузкиМетаданныхПоТипу(знач ТипОбъектов) Экспорт
	
	СоответствиеИмен = Новый Соответствие();
	СоответствиеИмен.Вставить("справочники"                 , "Catalogs");
	СоответствиеИмен.Вставить("catalogs"                    , "Catalogs");
	СоответствиеИмен.Вставить("документы"                   , "Documents");
	СоответствиеИмен.Вставить("documents"                   , "Documents");
	СоответствиеИмен.Вставить("регистрысведений"            , "InformationRegisters");
	СоответствиеИмен.Вставить("informationregisters"        , "InformationRegisters");
	СоответствиеИмен.Вставить("регистрынакопления"          , "AccumulationRegisters");
	СоответствиеИмен.Вставить("accumulationregisters"       , "AccumulationRegisters");
	СоответствиеИмен.Вставить("регистрыбухгалтерии"         , "AccountingRegisters");
	СоответствиеИмен.Вставить("accountingregisters"         , "AccountingRegisters");
	СоответствиеИмен.Вставить("регистрырасчета"             , "CalculationRegisters");
	СоответствиеИмен.Вставить("calculationregisters"        , "CalculationRegisters");
	СоответствиеИмен.Вставить("обработки"                   , "DataProcessors");
	СоответствиеИмен.Вставить("dataprocessors"              , "DataProcessors");
	СоответствиеИмен.Вставить("отчеты"                      , "Reports");
	СоответствиеИмен.Вставить("reports"                     , "Reports");
	СоответствиеИмен.Вставить("перечисления"                , "Enums");
	СоответствиеИмен.Вставить("enums"                       , "Enums");
	СоответствиеИмен.Вставить("планысчетов"                 , "ChartsOfAccounts");
	СоответствиеИмен.Вставить("chartsofaccounts"            , "ChartsOfAccounts");
	СоответствиеИмен.Вставить("бизнеспроцессы"              , "BusinessProcesses");
	СоответствиеИмен.Вставить("businessprocesses"           , "BusinessProcesses");
	СоответствиеИмен.Вставить("задачи"                      , "Tasks");
	СоответствиеИмен.Вставить("tasks"                       , "Tasks");
	СоответствиеИмен.Вставить("планыобмена"                 , "ExchangePlans");
	СоответствиеИмен.Вставить("exchangeplans"               , "ExchangePlans");
	СоответствиеИмен.Вставить("планывидовхарактеристик"     , "ChartsOfCharacteristicTypes");
	СоответствиеИмен.Вставить("chartsofcharacteristictypes" , "ChartsOfCharacteristicTypes");
	СоответствиеИмен.Вставить("планывидоврасчета"           , "ChartsOfCalculationTypes");
	СоответствиеИмен.Вставить("chartsofcalculationtypes"    , "ChartsOfCalculationTypes");
	СоответствиеИмен.Вставить("константы"                   , "Constants");
	СоответствиеИмен.Вставить("constants"                   , "Constants");
	
	Возврат СоответствиеИмен[ТипОбъектов];
	
КонецФункции

Функция ПолучитьИмяКоллекцииМетаданныхПоТипу(знач ТипОбъектов) Экспорт
	
	СоответствиеИмен = Новый Соответствие();
	СоответствиеИмен.Вставить("справочники"                 , "catalogs");
	СоответствиеИмен.Вставить("catalogs"                    , "catalogs");
	СоответствиеИмен.Вставить("документы"                   , "documents");
	СоответствиеИмен.Вставить("documents"                   , "documents");
	СоответствиеИмен.Вставить("регистрысведений"            , "infoRegs");
	СоответствиеИмен.Вставить("informationregisters"        , "infoRegs");
	СоответствиеИмен.Вставить("регистрынакопления"          , "accumRegs");
	СоответствиеИмен.Вставить("accumulationregisters"       , "accumRegs");
	СоответствиеИмен.Вставить("регистрыбухгалтерии"         , "accountRegs");
	СоответствиеИмен.Вставить("accountingregisters"         , "accountRegs");
	СоответствиеИмен.Вставить("регистрырасчета"             , "calcRegs");
	СоответствиеИмен.Вставить("calculationregisters"        , "calcRegs");
	СоответствиеИмен.Вставить("обработки"                   , "dataProc");
	СоответствиеИмен.Вставить("dataprocessors"              , "dataProc");
	СоответствиеИмен.Вставить("отчеты"                      , "reports");
	СоответствиеИмен.Вставить("reports"                     , "reports");
	СоответствиеИмен.Вставить("перечисления"                , "enums");
	СоответствиеИмен.Вставить("enums"                       , "enums");
	СоответствиеИмен.Вставить("планысчетов"                 , "сhartsOfAccounts");
	СоответствиеИмен.Вставить("chartsofaccounts"            , "сhartsOfAccounts");
	СоответствиеИмен.Вставить("бизнеспроцессы"              , "businessProcesses");
	СоответствиеИмен.Вставить("businessprocesses"           , "businessProcesses");
	СоответствиеИмен.Вставить("задачи"                      , "tasks");
	СоответствиеИмен.Вставить("tasks"                       , "tasks");
	СоответствиеИмен.Вставить("планыобмена"                 , "exchangePlans");
	СоответствиеИмен.Вставить("exchangeplans"               , "exchangePlans");
	СоответствиеИмен.Вставить("планывидовхарактеристик"     , "chartsOfCharacteristicTypes");
	СоответствиеИмен.Вставить("chartsofcharacteristictypes" , "chartsOfCharacteristicTypes");
	СоответствиеИмен.Вставить("планывидоврасчета"           , "chartsOfCalculationTypes");
	СоответствиеИмен.Вставить("chartsofcalculationtypes"    , "chartsOfCalculationTypes");
	СоответствиеИмен.Вставить("константы"                   , "constants");
	СоответствиеИмен.Вставить("constants"                   , "constants");
	СоответствиеИмен.Вставить("внешниеисточникиданных"      , "externalDataSources");
	СоответствиеИмен.Вставить("externaldatasources"         , "externalDataSources");
	
	Возврат СоответствиеИмен[ТипОбъектов];
	
КонецФункции

Функция СтруктуруВСтрокуJSON(знач Структура) Экспорт
	#Если ВебКлиент Тогда
	    Возврат PAPI_КонсольКодаВызовСервера.СтруктуруВСтрокуJSON(Структура);
	#Иначе
		Файл = Новый ЗаписьJSON;
		Файл.УстановитьСтроку();
		Попытка
		   ЗаписатьJSON(Файл, Структура);
		Исключение
		   ВызватьИсключение("Не удалось сохранить коллекцию метаданных:" + Символы.ПС + ОписаниеОшибки());
		КонецПопытки;
		
		Возврат Файл.Закрыть();
	#КонецЕсли
КонецФункции

Функция ЭтоСоответствие(знач Значение) Экспорт
	ТипЗначения = ТипЗнч(Значение);
	Возврат ТипЗначения = Тип("Соответствие") ИЛИ ТипЗначения = Тип("ФиксированноеСоответствие");
КонецФункции

Функция ЭтоСтруктура(знач Значение) Экспорт
	ТипЗначения = ТипЗнч(Значение);
	Возврат ТипЗначения = Тип("Структура") ИЛИ ТипЗначения = Тип("ФиксированнаяСтруктура");
КонецФункции

Функция ЭтоМассив(знач Значение) Экспорт
	ТипЗначения = ТипЗнч(Значение);
	Возврат ТипЗначения = Тип("Массив") ИЛИ ТипЗначения = Тип("ФиксированныйМассив");
КонецФункции
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьСтруктуруПоИмени(знач Структура, знач Имя)
	Ключ = КлючПараметров();
	Значение = Неопределено;
	Возврат PAPI_КонсольКодаКлиентСервер.ЭтоСтруктура(Структура)
		И Структура.Свойство(Ключ, Значение)
		И Значение = Имя;
КонецФункции

Функция ПолучитьЗначениеПараметра(знач ЗначениеПараметра)
	ТипЗначение = ТипЗнч(ЗначениеПараметра);
	Если ТипЗначение = Тип("Структура") Тогда
		Возврат Новый ФиксированнаяСтруктура(ЗначениеПараметра);
	ИначеЕсли ТипЗначение = Тип("Соответствие") Тогда
		Возврат Новый ФиксированноеСоответствие(ЗначениеПараметра);
	ИначеЕсли ТипЗначение = Тип("Массив") Тогда
		Возврат Новый ФиксированныйМассив(ЗначениеПараметра);
	Иначе 
		Возврат ЗначениеПараметра;
	КонецЕсли;
КонецФункции

#КонецОбласти

