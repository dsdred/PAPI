#Область License

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

#Область СлужебныеПроцедурыИФункции  

// Процедура - Сравнение структуры с реквизитами объекта с заменой значений в объекте 
//
// Параметры:
//  ЭлОбъект					 - Объект 	 - Создаваемый\изменяемый объект 
//  СтруктураПредопределенные	 - Структура - Структура заполнена значениями где свойство структуры совпадает с именем реквизита объекта
//	Перезаполнять				 - Булево	 - Если реквизит объекта заполнен и Перезаполнять = ложь, тогда не перезаполнять.
//
Процедура СравнитьИЗаменитьЗначенияРеквизитов(ЭлОбъект, СтруктураПредопределенные, Перезаполнять = Истина) Экспорт 
	
	Для Каждого ЭлСтруктуры Из СтруктураПредопределенные Цикл 
		
		Если ЗначениеЗаполнено(ЭлОбъект[ЭлСтруктуры.Ключ])
			И Не Перезаполнять Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ЭлОбъект[ЭлСтруктуры.Ключ] <> ЭлСтруктуры.Значение Тогда 
			ЭлОбъект[ЭлСтруктуры.Ключ] = ЭлСтруктуры.Значение;	
		КонецЕсли;	      

	КонецЦикла;
	
КонецПроцедуры 

// Функция - Документы разрешены к обмену по дате. Заглушка.
//
// Параметры:
//  ДатаДокумента	 - Дата	- Дата документа
// 
// Возвращаемое значение:
//  Булево - Истина - Документ разрешен к обмену, ложь - документ запрещен 
//
Функция ДатаЗапретаОбменаДокументов(Знач ДатаДокумента) Экспорт 
	
	Результат = Истина;
	
	перДатаЗапретаОбменаДокументов = PAPI_ОбщегоНазначенияВызовСервера.ПрочитатьЗначениеКонстанты("PAPI_ДатаЗапретаОбменаДокументов");
	
	Если ЗначениеЗаполнено(перДатаЗапретаОбменаДокументов) Тогда 
		
		Результат = (ДатаДокумента >= перДатаЗапретаОбменаДокументов);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	



#КонецОбласти

