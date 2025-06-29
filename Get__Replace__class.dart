import 'dart:typed_data';    //Нужен для "Uint8List"
import 'dart:convert';       //для utf8.encode()

bool memcmp(final Uint8List Uint8List_compare_1, final int index_cmp_1, final Uint8List Uint8List_compare_2, final int index_cmp_2, final int num)
{
  //index_cmp_1            - Индекс элемента в буффере "_Uint8List_ref" с которого нужно сранвить данные с данными из буффера "Uint8List_compare_2".
  //Uint8List_from_Copy    - Буффер "Uint8List" с которым нужно сранвить данные.
  //index_from_Copy        - индекс элемента из буффера "Uint8List_compare_2" откуда нужно сравнить данные.

  for(int i = 0; i < num; i++ )
  {
    if(Uint8List_compare_1[index_cmp_1 + i] != Uint8List_compare_2[index_cmp_2 + i])
    {
      return false;
    }

  }

  return true;
}
void memcpy(Uint8List Uint8List_to_Copy, final int index_to_Copy, final Uint8List Uint8List_from_Copy, final int index_from_Copy, final int size_copy)
{
  //Uint8List_to_Copy       - Буффер куда нужно копировать данные из "Uint8List_from_Copy"
  //index_to_Copy           - Индекс элемента в буффере "Uint8List_to_Copy" куда нужно скопировать даныне из буффера "Uint8List_from_Copy".
  //Uint8List_from_Copy     - Буффер "Uint8List" откуда нужно скопировать данные.
  //index_from_Copy         - индекс элемента из буффера "index_from_Copy" откуда нужно скопировать элементы в размере "size_copy".


  //-----------------------------------------------------------------------------
  //Первый параметр: это Индекс элемента в буффере "Uint8List_to_Copy" с которого нужно начать вставлять данные из "Uint8List_from_Copy";
  //Второй параметр: это индекс элемента в буффере "Uint8List_to_Copy" ДО которого [НЕ Включая] нужно скпировать элементы из "Uint8List_from_Copy".
  //ТО ЕСТЬ - если нужно к примеру скоировать данные в буффер "Uint8List_to_Copy" со 2 элемента по 4 - то есть три элемента: 2,3,4 - то нужно указать: первым парметром - 1, а вторым парметром элемент следующий за 4, то есть 4(ТУПО КАК ТО!).

  //Uint8List_from_Copy - буффер из которого копируются данные.
  //Четвертый параметр - это индекс элемента в буффере "Uint8List_from_Copy" с которого будут скопированы данные в размере "значение второго параметра минус значение первого парметра".
  //-----------------------------------------------------------------------------

  Uint8List_to_Copy.setRange(index_to_Copy, index_to_Copy + size_copy, Uint8List_from_Copy, index_from_Copy);
}
int find_substring(final Uint8List Buffer, final int index_begin, final int index_end, final Uint8List substr, final int substr_size)
{
  //Простой поиск.

  int length = index_end - index_begin + 1;

  if (length < substr_size)
  {
    //Значит искомая подстрока больше, чем искомыый диапазон.

    return -1;
  }
  else
  {
    //Значит искомая подстрока равна или меньше диапазона в котором нужно искать. Расчитаем кол-во итераций, которое нужно будет пройти memcmp для поиска подстроки в указанном диапазоне:

    int num_iteration = (length - substr_size) + 1;

    //----------------------------------------------------------------------------------------
    for (int i = 0; i < num_iteration; i++)
    {
      // memcmp(int index_cmp_1, Uint8List Uint8List_which_to_compare, index_cmp_2, int num)

      bool res = memcmp(Buffer, index_begin + i, substr, 0, substr_size);

      if (res == true)
      {
        return index_begin + i;     //Значит подстрока совпадает с блоком памяти, значит нашли подстроку.
      }
    }
    //----------------------------------------------------------------------------------------

    //Если код дошел до сюда, значит совпадение найти не удалось.

    return -1;

  }

}




//*****************************************************************************************
class result_struct
{

  int left_out_p        = -1; //Указатель на первый левый символ Левой внешней подстроки, то есть эта та подстрока, которая идет перед Левой искомой подстрокой.
  int left_out_size     = -1; //Размер

  int substr_found_p    = -1; //Указатель на первый левый символ найденной подстроки.
  int substr_found_size = -1; //Размер подстроки начиная с left_p

  int right_out_p       = -1; //ВНИМАНИЕ: это хвост только для последнего элемента в переданном векторе "vector_for_result". Это Указатель на первый левый символ Правой внешней подстроки, то есть эта та подстрока, которая идет сразу после найденой подстроки уже до конца самой строки. Актуально ТОЛЬКО при size_right_out > 0.
  int right_out_size    = -1; //Размер

  result_struct(this.left_out_p, this.left_out_size, this.substr_found_p, this.substr_found_size);
}

class request_struct
{
  late Uint8List pointer_to_subsrt;
  late int subsrt_size;

  request_struct(this.pointer_to_subsrt, this.subsrt_size);
}

class Get_Split_AllPointerRanges__class
{
  //--------------------------------------------------------------public:Begin--------------------------------------------------------------------

  int get__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result)
  {

//---------------------------------------------------------------
    int offset = 0;
//---------------------------------------------------------------
    int save_size = vector_for_result.length;
//---------------------------------------------------------------



//---------------------------------------------------------------
    for (;;)
    {
      int pointer_find = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.pointer_to_subsrt, request_struct_.subsrt_size);

      if (pointer_find == -1)
      {
        FinishRecording_BackTail(vector_for_result, offset, pointer_end); //Записываем послдений задний "хвост", то есть то, что осталось после Правой ограничивающей подстроки до конца строки.

        return vector_for_result.length - save_size;
      }
      else
      {
        //Значит нашли подстроку:


        //------------------------------------------------------------------
        if (offset == 0)
        {
          //Значит это первая найденная последотвалеьность:

          vector_for_result.add(new result_struct(pointer_beg, pointer_find - pointer_beg, pointer_find, request_struct_.subsrt_size));
        }
        else
        {
          //Значит это минимум вторая найденная последотвалеьность:

          vector_for_result.add(new result_struct(vector_for_result.last.substr_found_p + vector_for_result.last.substr_found_size, pointer_find - (vector_for_result.last.substr_found_p + vector_for_result.last.substr_found_size), pointer_find, request_struct_.subsrt_size));
        }
        //------------------------------------------------------------------


        //--------------------------------------------------------------------------
        if ((pointer_find + request_struct_.subsrt_size) > pointer_end)
        {
          //Значит вышли за границы строки: Значит сразу после найденной Правой огарничивающей подстроки - ничего нет.

          return vector_for_result.length - save_size;
        }
        else
        {
          offset = (pointer_find + request_struct_.subsrt_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
        }
        //--------------------------------------------------------------------------


      }
    }

  }

  int get(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result)
  {

//--------------------------------------------------------
    int offset = 0;
//---------------------------------------------------------------
    int save_size = vector_for_result.length;
//---------------------------------------------------------------



//---------------------------------------------------------------
    for (;;)
    {
      int pointer_find = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.pointer_to_subsrt, request_struct_.subsrt_size);

      if (pointer_find == -1)
      {
        FinishRecording_BackTail(vector_for_result, offset, pointer_end); //Записываем послдений задний "хвост", то есть то, что осталось после Правой ограничивающей подстроки до конца строки.

        return vector_for_result.length - save_size;
      }
      else
      {
        //Значит нашли подстроку:


        //------------------------------------------------------------------
        if (offset == 0)
        {
          //Значит это первая найденная последотвалеьность:

          vector_for_result.add(new result_struct(pointer_beg, pointer_find - pointer_beg, pointer_find, request_struct_.subsrt_size));
        }
        else
        {
          //Значит это минимум вторая найденная последотвалеьность:

          vector_for_result.add(new result_struct(vector_for_result.last.substr_found_p + vector_for_result.last.substr_found_size, pointer_find - (vector_for_result.last.substr_found_p + vector_for_result.last.substr_found_size), pointer_find, request_struct_.subsrt_size));
        }
        //------------------------------------------------------------------


        //--------------------------------------------------------------------------
        if ((pointer_find + request_struct_.subsrt_size) > pointer_end)
        {
          //Значит вышли за границы строки: Значит сразу после найденной Правой огарничивающей подстроки - ничего нет.

          return vector_for_result.length - save_size;
        }
        else
        {
          offset = (pointer_find + request_struct_.subsrt_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
        }
        //--------------------------------------------------------------------------


      }
    }

  }
//---------------------------------------------------------------




//---------------------------------------------------------------------private:begin--------------------------------------------------------------------

  void FinishRecording_BackTail(List<result_struct> vector_for_result, final int offset, final int pointer_end)
  {

    //-------------------------Дозаписываем задний хвост:начало-------------------
    if (offset != 0)
    {
      //Значит минимум одна последовтаельность уже была найдена и после нее до окнца строки остался "задний хвост", занесем его.

      vector_for_result.last.right_out_p = vector_for_result.last.substr_found_p + vector_for_result.last.substr_found_size;
      vector_for_result.last.right_out_size = pointer_end - vector_for_result.last.right_out_p + 1;
    }
    //-------------------------Дозаписываем задний хвост:конец-------------------

  }


}
//*****************************************************************************************

//*****************************************************************************************
enum insert_flag
    {
  Before,
  After,
}

class Uint8List__class
{

  Uint8List__class()
  {
    initialization();
  }

  void initialization()
  {
    _Uint8List_ref = Uint8List(0);
  }

  void set__Reserve_koef(final double value)
  {
    _reserve_koef = value;
  }

  //----------------------------------------------Public:Begin--------------------------------------------------------------
  void set_Buffer_Wrap_around_class(final Uint8List Uint8List_, final int size)
  {
    //Делаем переданный "Uint8List_" - как бы частью данного класса.

    _Uint8List_ref = Uint8List_;

    _size           = size;
    _capacity_size  = Uint8List_.length;
  }

  void set_Buffer_Value(final Uint8List Uint8List_, final int size)
  {
    //Делаем копию "Uint8List_".

    resize(size);

    memcpy(_Uint8List_ref!, 0, Uint8List_, 0, size);
  }

  void insert(final int Index_element_to_Insert, final Uint8List Uint8List_insert, final int insert_size, final insert_flag insert_flag_)
  {

    //Index_element_to_Insert - индекс Элемента в буффере "_Uint8List_ref" отсносительно которого нужно осуществить вставку "Uint8List_insert"
    //InserFlag:                -флаг вставки: Before - значит Uint8List_insert нужно вставить ДО указанного Index_element_to_Insert; After - значит Uint8List_insert нужно вставить После указанного Index_element_to_Insert;



    //---------------------------------------------------------
    if (insert_flag_ == insert_flag.After)
    {
      //After:

      //---------------------------------------------------------
      if((_capacity_size - _size) < insert_size)
      {
        //Значит место для записи Не хватает: выделим новую память с запасом и перекопируем туда все данные.

        Uint8List Uint8List_NewBuffer = _new_alloc__Without_Copy(_size + insert_size, _reserve_koef);   //Выделим новую память с учетом размера "Uint8List_insert" и перекопируем туда существуте элементы.

        _insert_After_with_NewBuffer(Uint8List_NewBuffer, _Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);

        _Uint8List_ref = Uint8List_NewBuffer;
      }
      else
      {
        //Значит емкости для вставки хватает:

        if(Index_element_to_Insert == (_size-1))
        {
          //Значит по сути делаем push_back:

          _push_back__CurrentBuffer(_Uint8List_ref!, _size, Uint8List_insert, insert_size);
        }
        else
        {
          //Значит вставка в середину ПОСЛЕ указанного индекса элемента "Index_element_to_Insert":

          _insert_After_with_CurrentBuffer(_Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);
        }

      }
      //---------------------------------------------------------

    }
    else
    {
      //Before:

      //---------------------------------------------------------
      if((_capacity_size - _size) < insert_size)
      {
        //Значит место для записи Не хватает: выделим новую память с запасом и перекопируем туда все данные.

        Uint8List Uint8List_NewBuffer = _new_alloc__Without_Copy(_size + insert_size, _reserve_koef);   //Выделим новую память с учетом размера "Uint8List_insert" и перекопируем туда существуте элементы.

        _insert_Before_with_NewBuffer(Uint8List_NewBuffer, _Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);

        _Uint8List_ref = Uint8List_NewBuffer;
      }
      else
      {
        //Значит емкости для вставки хватает:

        if(Index_element_to_Insert == 0)
        {
          //Значит по сути делаем push_front:

          _push_front__CurrentBuffer(_Uint8List_ref!, _size, Uint8List_insert, insert_size);
        }
        else
        {
          //Значит вставка в середину ДО указанного индекса элемента "Index_element_to_Insert":

          _insert_Before_with_CurrentBuffer(_Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);
        }

      }
      //---------------------------------------------------------

    }
    //---------------------------------------------------------


    _size = _size + insert_size;

  }

  void insert_OneValue(final int Index_element_to_Insert, final int value, final insert_flag insert_flag_)
  {

    Uint8List Uint8List_ = Uint8List(1);
    Uint8List_[0]        = value;

    insert(Index_element_to_Insert, Uint8List_, 1, insert_flag_);
  }

  void push_back(final Uint8List Uint8List_add, final int add_size)
  {


    //---------------------------------------------------------
    if((_capacity_size - _size) < add_size)
    {
      //Значит место для записи Не хватает: выделим новую память с запасом и перекопируем туда все данные.

      _new_alloc__With_Copy(_size + add_size, _reserve_koef);   //Выделим новую память с учетом размера "Uint8List_add" и перекопируем туда существуте элементы.
    }

    //---------------------------------------------------------

    //---------------------------------------------------------------
    _push_back__CurrentBuffer(_Uint8List_ref!, _size, Uint8List_add, add_size);                                  //Копируем данные из "Uint8List_add" в конец "_Uint8List_ref".
    //---------------------------------------------------------------

    //---------------------------------------------------------------
    _size = _size + add_size;
    //---------------------------------------------------------------

  }

  void push_back_OneValue(int value)
  {
    Uint8List Uint8List_ = Uint8List(1);
    Uint8List_[0]        = value;

    push_back(Uint8List_,1);
  }

  void set_Buffer_Value_by_UTF8_from_String(final String String_)
  {
    //Данный метод только для однобайтного типа

    final Uint8List Uint8List_ = Uint8List.fromList(utf8.encode(String_));

    set_Buffer_Value(Uint8List_, Uint8List_.length);
  }

  void push_back_from_String(final String String_)
  {
    final Uint8List Uint8List_ = Uint8List.fromList(utf8.encode(String_));

    push_back(Uint8List_, Uint8List_.length);
  }

  void insert_from_String(final String String_, final int Index_element_to_Insert, final insert_flag insert_flag_)
  {
    final Uint8List Uint8List_ = Uint8List.fromList(utf8.encode(String_));

    insert(Index_element_to_Insert, Uint8List_, Uint8List_.length, insert_flag_);
  }


  void pop_back(final int delete_size)
  {
    _size = _size - delete_size;
  }

  void erase(final int Index_Erase_element)
  {

    if(Index_Erase_element == _size-1)
    {
      pop_back(1);
    }
    else
    {
      memcpy(_Uint8List_ref!, Index_Erase_element, _Uint8List_ref!, Index_Erase_element + 1, (_size -Index_Erase_element - 1));

      _size = _size - 1;
    }

  }
  void erase_range(final int Index_Erase_element_First, final int Index_Erase_element_End)
  {

    if(Index_Erase_element_End == _size-1)
    {
      _size = _size - (Index_Erase_element_End - Index_Erase_element_First + 1);
    }
    else
    {

      //----------------------------------------------------------------------------
      memcpy(_Uint8List_ref!, Index_Erase_element_First, _Uint8List_ref!, Index_Erase_element_End + 1, (_size - Index_Erase_element_End) - 1);
      //----------------------------------------------------------------------------

      _size = _size - (Index_Erase_element_End - Index_Erase_element_First + 1);
    }

  }


  void erase_if(bool Function(int value_compare) user_func_condition)
  {

    //-------------------------
    int read_index  = 0;
    int write_index = 0;

    int current_value;
    //-------------------------

    //-------------------------------------------------------------------
    for (read_index = 0; read_index < _size; read_index++)
    {

      current_value = _Uint8List_ref![read_index];

      bool delete_flag = user_func_condition(current_value);

      //````````````````````````````````````````````````
      if (delete_flag == false)
      {

        if (read_index != write_index)
        {
          _Uint8List_ref![write_index] = current_value;
        }

        write_index++;
      }
      //````````````````````````````````````````````````

    }
    //-------------------------------------------------------------------


    _size = write_index;

  }


  void memcpy(Uint8List Uint8List_to_Copy, final int index_to_Copy, final Uint8List Uint8List_from_Copy, final index_from_Copy, final int size_copy)
  {
    //Uint8List_to_Copy       - Буффер куда нужно копировать данные из "Uint8List_from_Copy"
    //index_to_Copy           - Индекс элемента в буффере "Uint8List_to_Copy" куда нужно скопировать даныне из буффера "Uint8List_from_Copy".
    //Uint8List_from_Copy     - Буффер "Uint8List" откуда нужно скопировать данные.
    //index_from_Copy         - индекс элемента из буффера "index_from_Copy" откуда нужно скопировать элементы в размере "size_copy".


    //-----------------------------------------------------------------------------
    //Первый параметр: это Индекс элемента в буффере "Uint8List_to_Copy" с которого нужно начать вставлять данные из "Uint8List_from_Copy";
    //Второй параметр: это индекс элемента в буффере "Uint8List_to_Copy" ДО которого [НЕ Включая] нужно скпировать элементы из "Uint8List_from_Copy".
    //ТО ЕСТЬ - если нужно к примеру скоировать данные в буффер "Uint8List_to_Copy" со 2 элемента по 4 - то есть три элемента: 2,3,4 - то нужно указать: первым парметром - 1, а вторым парметром элемент следующий за 4, то есть 4(ТУПО КАК ТО!).

    //Uint8List_from_Copy - буффер из которого копируются данные.
    //Четвертый параметр - это индекс элемента в буффере "Uint8List_from_Copy" с которого будут скопированы данные в размере "значение второго параметра минус значение первого парметра".
    //-----------------------------------------------------------------------------

    Uint8List_to_Copy.setRange(index_to_Copy, index_to_Copy + size_copy, Uint8List_from_Copy, index_from_Copy);
  }

  bool memcmp(final Uint8List Uint8List_compare_1, final int index_cmp_1, final Uint8List Uint8List_compare_2, final index_cmp_2, final int num)
  {
    //index_cmp_1            - Индекс элемента в буффере "_Uint8List_ref" с которого нужно сранвить данные с данными из буффера "Uint8List_compare_2".
    //Uint8List_from_Copy    - Буффер "Uint8List" с которым нужно сранвить данные.
    //index_from_Copy        - индекс элемента из буффера "Uint8List_compare_2" откуда нужно сравнить данные.

    for(int i = 0; i < num; i++ )
    {
      if(Uint8List_compare_1[index_cmp_1 + i] != Uint8List_compare_2[index_cmp_2 + i])
      {
        return false;
      }

    }

    return true;
  }

  int get__element_value(final int index)
  {
    return _Uint8List_ref![index];
  }

  int size()
  {
    return _size;
  }

  void reserve(final int value_reserve)
  {
    if (value_reserve > _capacity_size)
    {
      _new_alloc__With_Copy(value_reserve, 0);
    }

  }

  int capacity()
  {
    return _capacity_size;
  }

  void resize(final int new_size)
  {

    //--------------------------------------------------
    if(new_size > _capacity_size)
    {
      _new_alloc__With_Copy(new_size, 0);
    }
    //--------------------------------------------------

    _size = new_size;
  }

  void shrink_to_fit()
  {

    if(_capacity_size > _size)
    {
      _new_alloc__With_Copy(_size, 0);       //Сокращаем _capacity_size до _size.
    }

  }

  void clear()
  {
    _size           = 0;
    _capacity_size  = 0;
  }

  void free()
  {
    clear();

    _Uint8List_ref = null;

    initialization();
  }

  Uint8List get__Native_Uint8List_ref()
  {
    return _Uint8List_ref!;
  }

  int find_substring(final int index_begin, final int index_end, final Uint8List substr, final int substr_size)
  {
    //Простой поиск.

    int length = index_end - index_begin + 1;

    if (length < substr_size)
    {
      //Значит искомая подстрока больше, чем искомыый диапазон.

      return -1;
    }
    else
    {
      //Значит искомая подстрока равна или меньше диапазона в котором нужно искать. Расчитаем кол-во итераций, которое нужно будет пройти memcmp для поиска подстроки в указанном диапазоне:

      int num_iteration = (length - substr_size) + 1;

      //----------------------------------------------------------------------------------------
      for (int i = 0; i < num_iteration; i++)
      {
        // memcmp(int index_cmp_1, Uint8List Uint8List_which_to_compare, index_cmp_2, int num)

        bool res = memcmp(_Uint8List_ref!, index_begin + i, substr, 0, substr_size);

        if (res == true)
        {
          return index_begin + i;     //Значит подстрока совпадает с блоком памяти, значит нашли подстроку.
        }
      }
      //----------------------------------------------------------------------------------------

      //Если код дошел до сюда, значит совпадение найти не удалось.

      return -1;

    }

  }

  bool find_substring_to_List(final int index_begin, final int index_end, final Uint8List substr, final int substr_size, List<int> vector_result_ref)
  {

    bool found_flag = false;

    int index_begin_ = index_begin;


    for(;;)
    {

      //-----------------------------------------------------------------------------------------
      int res = find_substring(index_begin_, index_end, substr, substr_size);

      if(res > -1)
      {
        //Значит найдена "подстрока". res - это индекс элемента с которого она начинается.

        //--------------------------------------------------------------
        vector_result_ref.add(res);  //Занесем ее в вектор.

        found_flag = true;           //Ставим флаг, что хотя бы одна "подстрока" найдена.
        //--------------------------------------------------------------

        //--------------------------------------------------------------
        index_begin_ = res + substr_size;  //Смещаем начало диапазона поиска для следующео поиска "подстроки".
        //--------------------------------------------------------------
      }
      else
      {
        return found_flag;
      }
      //-----------------------------------------------------------------------------------------

    }

  }


  String? decode_UTF8_to_String()
  {
    try
    {
      Uint8List Uint8List_view = Uint8List.view(_Uint8List_ref!.buffer, 0, _size);

      return utf8.decode(Uint8List_view);
    } on FormatException
    {
      return null;
    }

  }

  void print_only_WorkSize()
  {
    Uint8List Uint8List_temp = Uint8List.view(_Uint8List_ref!.buffer, 0, _size);

    print(Uint8List_temp);
  }

//----------------------------------------------Public:End--------------------------------------------------------------



  //----------------------------------------------Private:Begin-------------------------------------------------------------
  Float32List get__View_Type_Float32List(final int Index_element, final int element_size)
  {
    return Float32List.view(_Uint8List_ref!.buffer, Index_element * Float32List.bytesPerElement, element_size);
  }
  Float64List get__View_Type_Float64List(final int Index_element, final int element_size)
  {
    return Float64List.view(_Uint8List_ref!.buffer, Index_element * Float64List.bytesPerElement, element_size);
  }
  Int8List get__View_Type_Int8List(final int Index_element, final int element_size)
  {
    return Int8List.view(_Uint8List_ref!.buffer, Index_element * Int8List.bytesPerElement, element_size);
  }
  Int16List get__View_Type_Int16List(final int Index_element, final int element_size)
  {
    return Int16List.view(_Uint8List_ref!.buffer, Index_element * Int16List.bytesPerElement, element_size);
  }
  Int32List get__View_Type_Int32List(final int Index_element, final int element_size)
  {
    return Int32List.view(_Uint8List_ref!.buffer, Index_element * Int32List.bytesPerElement, element_size);
  }
  Int64List get__View_Type_Int64List(final int Index_element, final int element_size)
  {
    return Int64List.view(_Uint8List_ref!.buffer, Index_element * Int64List.bytesPerElement, element_size);
  }
  Uint8List get__View_Type_Uint8List(final int Index_element, final int element_size)
  {
    return Uint8List.view(_Uint8List_ref!.buffer, Index_element * Uint8List.bytesPerElement, element_size);
  }
  Uint16List get__View_Type_Uint16List(final int Index_element, final int element_size)
  {
    return Uint16List.view(_Uint8List_ref!.buffer, Index_element * Uint16List.bytesPerElement, element_size);
  }
  Uint32List get__View_Type_Uint32List(final int Index_element, final int element_size)
  {
    return Uint32List.view(_Uint8List_ref!.buffer, Index_element * Uint32List.bytesPerElement, element_size);
  }
  Uint64List get__View_Type_Uint64List(final int Index_element, final int element_size)
  {
    return Uint64List.view(_Uint8List_ref!.buffer, Index_element * Uint64List.bytesPerElement, element_size);
  }
  //----------------------------------------------Public:End--------------------------------------------------------------




//----------------------------------------------Private:Begin-------------------------------------------------------------
  Uint8List? _Uint8List_ref;
//----------------------------------------------Private:End--------------------------------------------------------------


//----------------------------------------------Private:Begin-------------------------------------------------------------
  int _size             = 0;
  int _capacity_size    = 0;         //Это общая выделнная память "_Uint8List_ref" включая рабочие элементы размером "_size".
  double _reserve_koef  = 0.4;       //Во сколько раз от рабочего размера - будет дополнительно резервироватся память.
//----------------------------------------------Private:End--------------------------------------------------------------


//----------------------------------------------Private:Begin-------------------------------------------------------------

  void _new_alloc__With_Copy(final int alloc_size, final double reserve_koef)
  {

    //------------------------------------------------------
    int new_size               = (alloc_size + (alloc_size)*reserve_koef).toInt();

    Uint8List Uint8List_new    = Uint8List(new_size);

    memcpy(Uint8List_new, 0, _Uint8List_ref!, 0, _size);           //Перекопируем существущие элементы в новый буффер.
    //------------------------------------------------------

    //------------------------------------------------------
    _capacity_size  = new_size;

    _Uint8List_ref = Uint8List_new;                        //Так память на которую раньше указывал "_Uint8List_ref" - теоретически должен подчистить сборщик мусора.
    //------------------------------------------------------

  }
  Uint8List _new_alloc__Without_Copy(final int alloc_size, final double reserve_koef)
  {

    //------------------------------------------------------
    int new_size               = (alloc_size + (alloc_size)*reserve_koef).toInt();

    Uint8List Uint8List_new    = Uint8List(new_size);
    //------------------------------------------------------

    //------------------------------------------------------
    _capacity_size  = new_size;
    //------------------------------------------------------


    return Uint8List_new;
  }


  void _insert_After_with_NewAlloc(final int Index_element_to_Insert, final Uint8List Uint8List_insert, final int insert_size)
  {

    //-------------------Выделяем новую память:begin-----------------------------------
    int alloc_size             = _size + insert_size;

    int new_size               = (alloc_size + (alloc_size)*_reserve_koef).toInt();

    Uint8List Uint8List_new    = Uint8List(new_size);
    //-------------------Выделяем новую память:end-----------------------------------



    //-------------------------------------------------------------------------------
    memcpy(Uint8List_new, 0, _Uint8List_ref!, 0, Index_element_to_Insert);                                                                                                    //Копируем ту часть текущих данных, которая находится до указанного эkемента "Index_element_to_Insert" ДО которого нужно вставить новые данные, НЕ ВКЛЮЧАЯ сам элемент "Index_element_to_Insert"
    memcpy(Uint8List_new, Index_element_to_Insert, Uint8List_insert, 0, insert_size);                                                                             //Теперь копируем те данные, которые нужно вставить.
    memcpy(Uint8List_new, Index_element_to_Insert + insert_size, _Uint8List_ref!, Index_element_to_Insert, _size - Index_element_to_Insert);     //И копируем оставшуюся текущую часть данных из "_Uint8List_ref" после новых вставленных данных.

    _Uint8List_ref = Uint8List_new;    //Так память на которую раньше указывал "_Uint8List_ref" - теоретически должен подчистить сборщик мусора.
    //-------------------------------------------------------------------------------


    //------------------------------------------------------
    _capacity_size  = new_size;

    _Uint8List_ref = Uint8List_new;                        //Так память на которую раньше указывал "_Uint8List_ref" - теоретически должен подчистить сборщик мусора.
    //------------------------------------------------------




  }

  void _insert_Before_with_NewBuffer(Uint8List Uint8List_NewBuffer, final Uint8List Current_Buffer, final int Current_Buffer_size, final int Index_element_to_Insert, final Uint8List Uint8List_insert, final int insert_size)
  {

    //Uint8List_NewBuffer - это буффер с уже необходимой выделенной памятю, но полностью пустой всмысле рабочих данных.

    memcpy(Uint8List_NewBuffer, 0, Current_Buffer, 0, Index_element_to_Insert);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert, Uint8List_insert, 0, insert_size);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert + insert_size, Current_Buffer, Index_element_to_Insert, (Current_Buffer_size - Index_element_to_Insert) );

  }
  void _insert_Before_with_CurrentBuffer(Uint8List Buffer_into_which_insert, final int Buffer_into_which_insert_size, final int Index_element_to_Insert, final Uint8List Uint8List_insert, final int insert_size)
  {
    memcpy(Buffer_into_which_insert, (Index_element_to_Insert + insert_size), Buffer_into_which_insert, Index_element_to_Insert, (Buffer_into_which_insert_size - Index_element_to_Insert));

    memcpy(Buffer_into_which_insert, Index_element_to_Insert, Uint8List_insert, 0, insert_size);
  }
  void _insert_After_with_NewBuffer(Uint8List Uint8List_NewBuffer, final Uint8List Current_Buffer, final int Current_Buffer_size, int Index_element_to_Insert, final Uint8List Uint8List_insert, final int insert_size)
  {
    //Uint8List_NewBuffer - это буффер с уже необходимой выделенной памятю, но полностью пустой всмысле рабочих данных.

    memcpy(Uint8List_NewBuffer, 0, Current_Buffer, 0, Index_element_to_Insert + 1);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert + 1, Uint8List_insert, 0, insert_size);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert + 1 + insert_size, Current_Buffer, (Index_element_to_Insert+1), (Current_Buffer_size - (Index_element_to_Insert+1)) );
  }
  void _insert_After_with_CurrentBuffer(Uint8List Buffer_into_which_insert, final int Buffer_into_which_insert_size, final int Index_element_to_Insert, final Uint8List Uint8List_insert, final int insert_size)
  {
    memcpy(Buffer_into_which_insert, (Index_element_to_Insert + insert_size + 1), Buffer_into_which_insert, (Index_element_to_Insert + insert_size), (Buffer_into_which_insert_size - (Index_element_to_Insert+1)));                                                                                                              //Копируем ту часть текущих данных, которая находится до указанного элемента "Index_element_to_Insert" после которого нужно вставить новые данные.

    memcpy(Buffer_into_which_insert, Index_element_to_Insert + 1, Uint8List_insert, 0, insert_size);
  }

  void _push_front__CurrentBuffer(Uint8List Buffer_into_which_push, final int Buffer_into_which_push_size, final Uint8List Uint8List_insert, final int push_size)
  {
    memcpy(Buffer_into_which_push, push_size, Buffer_into_which_push, 0, Buffer_into_which_push_size);            //Копируем сначала данные из "CurrentBuffer" - как бы сдвигая их Вправо на размер вставляемых данных из "Uint8List_insert"

    memcpy(Buffer_into_which_push, 0, Uint8List_insert, 0, push_size);                                           //И Потом копируем сами вставляемые данные в начало буффера.
  }
  void _push_back__CurrentBuffer(Uint8List Buffer_into_which_push, final int Buffer_into_which_push_size, final Uint8List Uint8List_add, final int push_size)
  {
    memcpy(Buffer_into_which_push, Buffer_into_which_push_size, Uint8List_add, 0, push_size);
  }


//----------------------------------------------Private:End-------------------------------------------------------------

}
//*****************************************************************************************






class Get__Replace__class
{

  //------------------------------------------------------------------public:--------------------------------------------------------------------------------------


  (int, Uint8List?) replace_to_NewString__EndPointer(final Uint8List Buffer, final int pointer_to_BeginData, final int pointer_to_EndData, final Uint8List pointer_to_substr_ToBeReplaced, final int size_substr_ToBeReplaced, final Uint8List pointer_to_substr_ForReplaced, final int size_substr_ForReplaced)
  {
    //pointer_to_substr_ToBeReplaced - указатель на подстроку которая должна быть заменена. То есть то, что должно быть найдено в строке "pointer_to_BeginData" и замененно на "pointer_to_substr_ForReplaced"

    //--------------------------------------------Разделим строку на части:Начало-------------------------------------------------------
    req_split.pointer_to_subsrt = pointer_to_substr_ToBeReplaced;
    req_split.subsrt_size       = size_substr_ToBeReplaced;

    vec_SplitResult.length = 0;
    final int result = Get_Split_AllPointerRanges_.get__EndPointer(Buffer, pointer_to_BeginData, pointer_to_EndData, req_split, vec_SplitResult);
    //--------------------------------------------Разделим строку на части:Конец-------------------------------------------------------




    //---------------------------------------------------------------------------------------------------------------------------------
    if (result != 0)
    {
      //--------------------------------------Посчитаем кол-во байт небходимо для новой строки с учетом замены:Начало---------------------------------------

      int Final_size = 0;

      if (size_substr_ToBeReplaced > size_substr_ForReplaced)
      {
        //Значит подстрока которую нужно заменить больше, чем подстрока на которую нужно заменить, то есть итоговая строка будет меньше, чем строка на которую указывает "pointer_to_BeginData".

        Final_size = (pointer_to_EndData - pointer_to_BeginData + 1) - (vec_SplitResult.length * (size_substr_ToBeReplaced - size_substr_ForReplaced));
      }
      else
      {
        if (size_substr_ToBeReplaced < size_substr_ForReplaced)
        {
          //Значит подстрока которую нужно заменить меньше, чем подстрока на которую нужно заменить, то есть итоговая строка будет больше, чем строка на которую указывает "pointer_to_BeginData".

          Final_size = (pointer_to_EndData - pointer_to_BeginData + 1) + (vec_SplitResult.length * (size_substr_ForReplaced - size_substr_ToBeReplaced));
        }
        else
        {
          //Значит подстрока которую нужно заменить равна по размеру, подстроке на которую нужно заменить, то есть итоговая строка по размеру будет точно такая же, как и есть.

          Final_size = (pointer_to_EndData - pointer_to_BeginData + 1);
        }
      }

      //--------------------------------------Посчитаем кол-во байт небходимо для новой строки с учетом замены:Начало---------------------------------------


      //-----------------------------------------------------
      int start_byte = 0;

      Uint8List string_result = Uint8List(start_byte + Final_size);
      //-----------------------------------------------------


      //-----------------------------------------Перекопируем теперь части из pointer_to_BeginData в новую строку "string_result":Начало------------------------------------------
      for (int i = 0; i < vec_SplitResult.length; i++)
      {
        if (vec_SplitResult[i].left_out_size > -1)
        {
          memcpy(string_result, start_byte, Buffer, vec_SplitResult[i].left_out_p, vec_SplitResult[i].left_out_size);
        }

        start_byte = start_byte + vec_SplitResult[i].left_out_size;

        memcpy(string_result, start_byte, pointer_to_substr_ForReplaced, 0, size_substr_ForReplaced);

        start_byte = start_byte + size_substr_ForReplaced;
      }

      if (vec_SplitResult.last.right_out_p != -1)
      {
        memcpy(string_result, start_byte, Buffer, vec_SplitResult.last.right_out_p, vec_SplitResult.last.right_out_size);
      }
      //-----------------------------------------Перекопируем теперь части из pointer_to_BeginData в новую строку "string_result":Конец------------------------------------------

      return (result, string_result);
    }
    else
    {
      return (result, null);  //Значит заменяемой построки не было найдено в строке.
    }
    //-------------------------------------------------------------------------------------------------------------------------------


  }


  //-------------------------------------------------------------------------------private:----------------------------------------------------------------------------

  Get_Split_AllPointerRanges__class Get_Split_AllPointerRanges_ = new Get_Split_AllPointerRanges__class();
  request_struct req_split                                      = request_struct(Uint8List(0), 0);
  List<result_struct> vec_SplitResult = [];

}
