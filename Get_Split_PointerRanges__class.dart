import 'dart:typed_data';    //Нужен для "Uint8List"

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


class result_struct
{
  int split_range_p    = -1; //Указатель на первый левый символ найденной подстроки.
  int split_range_size = -1; //Размер подстроки начиная с left_p

  result_struct(this.split_range_p, this.split_range_size);
}

class request_struct
{
  late Uint8List pointer_to_subsrt;
  late int subsrt_size;

  request_struct(this.pointer_to_subsrt, this.subsrt_size);
}

class Get_Split_PointerRanges__class
{

//---------------------------------------------------------public:Begin-----------------------------------------------------------------------------------
int get_vector_pointer__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result)
{
     //---------------------------------------------------------------
      int offset = 0;
     //---------------------------------------------------------------
      int save_size = vector_for_result.length;
     //---------------------------------------------------------------
      int pointer_find_prev = 0;
     //---------------------------------------------------------------


//---------------------------------------------------------------
  for (;;)
  {
    final int pointer_find = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.pointer_to_subsrt, request_struct_.subsrt_size);

    if (pointer_find == -1)
    {
      FinishRecording_BackTail(vector_for_result, offset, pointer_end, request_struct_, pointer_find_prev); //Записываем послдений задний "хвост", то есть то, что осталось после найденой послденей подстроки до конца строки.

      return vector_for_result.length - save_size;
    }
    else
    {
      //Значит нашли подстроку:


      //------------------------------------------------------------------
      if (offset == 0)
      {
        //Значит это первая найденная последотвалеьность:

        if (pointer_beg != pointer_find)
        {
          //Значит первый символ не совпадает с первым символом найденой подстроки и значит,что ДО найденной полстроки есть диапазон:

          vector_for_result.add(new result_struct(pointer_beg, pointer_find - pointer_beg));
        }
      }
      else
      {
        //Значит это минимум вторая найденная последотвалеьность:

        final int split_range_p = (pointer_find_prev + request_struct_.subsrt_size); //Указатель на начало диапазона перед найденой подстрокой "pointer_find"

        if (split_range_p != pointer_find)
        {
          vector_for_result.add(new result_struct(split_range_p, pointer_find - split_range_p));
        }
        //------------------------------------------------------------------

      }


      pointer_find_prev = pointer_find;


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

  int get_vector_string__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<Uint8List?> vector_for_result)
  {
    //-----------------------------------------------------------------------------------------------------------------
    List<result_struct> vector_for_result_pointer = [];

    final int result = get_vector_pointer__EndPointer(Buffer, pointer_beg, pointer_end, request_struct_, vector_for_result_pointer);

    if (result < 1)
    {
      return result;
    }
    //-----------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------
    final int save_size = vector_for_result.length;

    vector_for_result.length = save_size + vector_for_result_pointer.length;

    for (int i = 0; i < vector_for_result_pointer.length; i++)
    {
      vector_for_result[save_size + i] = Uint8List(vector_for_result_pointer[i].split_range_size);

      memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].split_range_p, vector_for_result_pointer[i].split_range_size);
    }


    return vector_for_result.length - save_size;
//-----------------------------------------------------------------------------------------------------------------

  }

  int get_vector_pointer__Limit_Counter(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result, int Limit_Counter) {
//---------------------------------------------------------------
    int offset = 0;
//---------------------------------------------------------------
    int save_size = vector_for_result.length;
//---------------------------------------------------------------
    int pointer_find_prev = 0;
//---------------------------------------------------------------
    int Limit_Counter_inner = 0;
//---------------------------------------------------------------


//---------------------------------------------------------------
    for (;;)
    {
      final int pointer_find = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.pointer_to_subsrt, request_struct_.subsrt_size);

      if (pointer_find == -1)
      {
        if (Limit_Counter_inner < Limit_Counter)
        {
          FinishRecording_BackTail(vector_for_result, offset, pointer_end, request_struct_, pointer_find_prev); //Записываем послдений задний "хвост", то есть то, что осталось после найденой послденей подстроки до конца строки.
        }

        return vector_for_result.length - save_size;
      }
      else
      {
//Значит нашли подстроку:


//------------------------------------------------------------------
        if (offset == 0)
        {
//Значит это первая найденная последотвалеьность:

          if (pointer_beg != pointer_find)
          {
//Значит первый символ не совпадает с первым символом найденой подстроки и значит,что ДО найденной полстроки есть диапазон:

            if (Limit_Counter_inner < Limit_Counter)
            {
              vector_for_result.add(new result_struct(pointer_beg, pointer_find - pointer_beg));

              Limit_Counter_inner++;
            }
            else
            {
              return vector_for_result.length - save_size;
            }
          }
        }
        else
        {
//Значит это минимум вторая найденная последотвалеьность:

          final int split_range_p = (pointer_find_prev + request_struct_.subsrt_size); //Указатель на начало диапазона перед найденой подстрокой "pointer_find"

          if (split_range_p != pointer_find)
          {
            if (Limit_Counter_inner < Limit_Counter)
            {
              vector_for_result.add(new result_struct(split_range_p, pointer_find - split_range_p));

              Limit_Counter_inner++;
            }
            else
            {
              return vector_for_result.length - save_size;
            }
          }
        }
//------------------------------------------------------------------


        pointer_find_prev = pointer_find;


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

  int get_vector_string__Limit_Counter(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List <Uint8List?> vector_for_result, int Limit_Counter)
  {
//-----------------------------------------------------------------------------------------------------------------
    List <result_struct> vector_for_result_pointer = [];

    final int result = get_vector_pointer__Limit_Counter(Buffer, pointer_beg, pointer_end, request_struct_, vector_for_result_pointer, Limit_Counter);

    if (result < 1)
    {
      return result;
    }
//-----------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------
    final int save_size = vector_for_result.length;

    vector_for_result.length = save_size + vector_for_result_pointer.length;

    for (int i = 0; i < vector_for_result_pointer.length; i++)
    {
      vector_for_result[save_size + i] = Uint8List(vector_for_result_pointer[i].split_range_size);

      memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].split_range_p, vector_for_result_pointer[i].split_range_size);
    }


    return vector_for_result.length - save_size;
//-----------------------------------------------------------------------------------------------------------------

  }
//---------------------------------------------------------public:End-----------------------------------------------------------------------------------


  //-----------------------------------------------------------private:Begin-----------------------------------------------------------------------------------
  void FinishRecording_BackTail(List<result_struct> vector_for_result, final int offset, final int pointer_end, final request_struct request_struct_, final int pointer_find_prev)
  {
    //-------------------------Дозаписываем задний хвост:начало-------------------
    if (offset != 0)
    {
    //Значит минимум одна последовтаельность уже была найдена и после нее до окнца строки остался "задний хвост", занесем его.

      vector_for_result.add(new result_struct((pointer_find_prev + request_struct_.subsrt_size), pointer_end - (pointer_find_prev + request_struct_.subsrt_size) + 1));
    }
    //-------------------------Дозаписываем задний хвост:конец-------------------

  }
  //-----------------------------------------------------------private:End-----------------------------------------------------------------------------------


}
