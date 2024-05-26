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

#Область ОбработчикиСписокСообщений

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	Если ЗначениеЗаполнено(ВходящийЗапрос) Тогда 
		ВыполнитьЗапросНаСервере();   
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗапросНаСервере()
	
	РезультатJS = PAPI_ОбщегоНазначенияВызовСервера.ЧтениеДанныхИзJSON(ВходящийЗапрос.Запрос);
	
	Если РезультатJS.Отработал Тогда 
		
		СтруктураВходныхПараметров = РезультатJS.Результат;
		Если ВходящийЗапрос.ЕстьТелоЗапроса Тогда 
			
			перТелоЗапроса = ВходящийЗапрос.ТелоЗапроса.Получить();	
			СтруктураВходныхПараметров.Вставить("ТелоЗапроса", перТелоЗапроса);
					
		КонецЕсли; 
		
		Элементы.ГруппаОтвет.Видимость = Истина;
		СтруктураОтвет = PAPI_РаботаСМетодами.ВыполнитьМетод(ВходящийЗапрос.Метод, СтруктураВходныхПараметров);
        
		Отработал 		= СтруктураОтвет.Отработал;
		КодОтвета 		= СтруктураОтвет.КодОтвета;
		ДанныеОтвета 	= СтруктураОтвет.ДанныеОтвета;
		ТекстОшибки 	= СтруктураОтвет.ТекстОшибки;
		
		ЗаголовкиОтвета.Очистить();
		
		Если СтруктураОтвет.Свойство("ЗаголовкиОтвета") Тогда 
			Для Каждого ТекущийЗаголовок Из СтруктураОтвет.ЗаголовкиОтвета Цикл 
				НоваяСтрока = ЗаголовкиОтвета.Добавить();
			    ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущийЗаголовок); 
			КонецЦикла;
		КонецЕсли;	
		
	Иначе	
		
		PAPI_ОбщегоНазначенияКлиентСервер.КраткоеСообщениеПользователю(РезультатJS.ТекстОшибки);
		Элементы.ГруппаОтвет.Видимость = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры  

#КонецОбласти

