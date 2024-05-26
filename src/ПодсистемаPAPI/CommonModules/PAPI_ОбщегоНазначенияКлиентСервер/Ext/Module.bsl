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

#Область СообщенияКлиенту

// Процедура - Краткое сообщение пользователю
//
// Параметры:
//  Текст	 - Строка	 - Текст сообщения
//  Поле	 - Строка	 - Поле в котором есть ошибка (Необязательна)
//
Процедура КраткоеСообщениеПользователю(Текст, Поле = "") Экспорт
       
	Сообщение 		= Новый СообщениеПользователю;
	Сообщение.Текст = Текст;  
	
	Если Не ПустаяСтрока(Поле) Тогда 
		Сообщение.Поле 	= Поле; 
	КонецЕсли;
	
	Сообщение.Сообщить();

КонецПроцедуры  

#КонецОбласти

#Область РаботаСДеревомНаФорме

 // Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - Пометка хранится в числовой колонке "Пометка".
//
Процедура ИзменениеПометки(ДанныеСтроки) Экспорт
	
	ДанныеСтроки.Пометка = ДанныеСтроки.Пометка % 2;
	ПроставитьПометкиВниз(ДанныеСтроки);
	ПроставитьПометкиВверх(ДанныеСтроки); 
	
КонецПроцедуры

// Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - Пометка хранится в числовой колонке "Пометка".
//
Процедура ПроставитьПометкиВниз(ДанныеСтроки) Экспорт  
	
	Значение = ДанныеСтроки.Пометка;
	Для Каждого Потомок Из ДанныеСтроки.ПолучитьЭлементы() Цикл
		Потомок.Пометка = Значение;
		ПроставитьПометкиВниз(Потомок);
	КонецЦикла; 
	
КонецПроцедуры

// Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - Пометка хранится в числовой колонке "Пометка".
//
Процедура ПроставитьПометкиВверх(ДанныеСтроки) Экспорт
	
	РодительСтроки = ДанныеСтроки.ПолучитьРодителя();
	Если РодительСтроки <> Неопределено Тогда
		ВсеИстина = Истина;
		НеВсеЛожь = Ложь;
		Для Каждого Потомок Из РодительСтроки.ПолучитьЭлементы() Цикл
			ВсеИстина = ВсеИстина И (Потомок.Пометка = 1);
			НеВсеЛожь = НеВсеЛожь Или Булево(Потомок.Пометка);
		КонецЦикла;
		Если ВсеИстина Тогда
			РодительСтроки.Пометка = 1;
		ИначеЕсли НеВсеЛожь Тогда
			РодительСтроки.Пометка = 2;
		Иначе
			РодительСтроки.Пометка = 0;
		КонецЕсли;
		ПроставитьПометкиВверх(РодительСтроки);
	КонецЕсли;  
	
КонецПроцедуры       

#КонецОбласти 
