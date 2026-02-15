#Область License

//MIT License

//Copyright (c) 2024-2026 Dmitrii Sidorenko

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

#Область ФоновыеЗадания
// Регламентное задание "PAPI_ВыполнитьОбработкуОчередиДействийСДокументами"
Процедура ВыполнитьОбработкуОчередиДействийСДокументами() Экспорт 

	ВключенПривилегированныйРежим = Ложь;
	Если Не ПривилегированныйРежим() Тогда  
		ВключенПривилегированныйРежим = Истина;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	PAPI_ОчередьДействийСДокументами.ТипОбъекта КАК ТипОбъекта,
		|	PAPI_ОчередьДействийСДокументами.ИдОбъекта КАК ИдОбъекта,
		|	PAPI_ОчередьДействийСДокументами.Действие КАК Действие,
		|	PAPI_ОчередьДействийСДокументами.Представление КАК Представление,
		|	PAPI_ОчередьДействийСДокументами.Выполнено КАК Выполнено,
		|	PAPI_ОчередьДействийСДокументами.ТекстОшибки КАК ТекстОшибки,
		|	PAPI_ОчередьДействийСДокументами.КоличествоПопыток КАК КоличествоПопыток,
		|	PAPI_ОчередьДействийСДокументами.ДатаИзменения КАК ДатаИзменения
		|ИЗ
		|	РегистрСведений.PAPI_ОчередьДействийСДокументами КАК PAPI_ОчередьДействийСДокументами
		|ГДЕ
		|	НЕ PAPI_ОчередьДействийСДокументами.Выполнено
		|";
	
	перКоличествоПопыток = PAPI_ОбщегоНазначенияВызовСервера.ПрочитатьЗначениеКонстанты("PAPI_КоличествоПопытокОчередиДокументов");
	Если ЗначениеЗаполнено(перКоличествоПопыток) Тогда 
		Запрос.Текст = Запрос.Текст + "	И PAPI_ОчередьДействийСДокументами.КоличествоПопыток < &КоличествоПопыток";
		Запрос.УстановитьПараметр("КоличествоПопыток", перКоличествоПопыток);
	КонецЕсли;	
	
	Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО
								  |	PAPI_ОчередьДействийСДокументами.ДатаИзменения
								  |";	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураРегистра = РегистрыСведений.PAPI_ОчередьДействийСДокументами.ПолучитьСтруктуруПоУмолчанию();
		ЗаполнитьЗначенияСвойств(СтруктураРегистра, ВыборкаДетальныеЗаписи);

		РегистрыСведений.PAPI_ОчередьДействийСДокументами.ВыполнитьДействие(СтруктураРегистра);
		
	КонецЦикла;
	
	Если ВключенПривилегированныйРежим Тогда 
		ВключенПривилегированныйРежим = Ложь;
		УстановитьПривилегированныйРежим(ВключенПривилегированныйРежим);	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти