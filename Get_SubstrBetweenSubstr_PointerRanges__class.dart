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
  int left_p = -1; //Указатель на первый левый символ найденной подстроки.
  int size   = -1; //Размер подстроки начиная с left_p/

  result_struct(this.left_p, this.size);
}

class request_struct
{
  late Uint8List left_p;
  late int left_size;

  late Uint8List right_p;
  late int right_size;

  request_struct(this.left_p, this.left_size, this.right_p, this.right_size);
}




class Get_SubstrBetweenSubstr_PointerRanges__class
{

  //----------------------------------------------------------public:Begin-----------------------------------------------------------------------

  int get_vector_pointer__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result)
  {
//---------------------------------------------------------------
  int offset = 0;
//---------------------------------------------------------------
  int save_size = vector_for_result.length;
//---------------------------------------------------------------


//---------------------------------------------------------------
  for (;;)
  {
    final int pointer_find_Left = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.left_p, request_struct_.left_size);

    if (pointer_find_Left == -1)
    {
      return vector_for_result.length - save_size;
    }
    else
    {
       //Ищем ответную правую часть:

      int CharBeg_for_FindRight = pointer_find_Left + request_struct_.left_size; //Указатель непосредвенно сразу после найденой левой подстроки.

      if (CharBeg_for_FindRight > pointer_end)
      {
       //Значит вышли за границы строки, значит после найденной левой ограничивающей подстроки больше ничего нет:

        return vector_for_result.length - save_size;
      }
      else
      {
        int pointer_find_Right = find_substring(Buffer, CharBeg_for_FindRight, pointer_end, request_struct_.right_p, request_struct_.right_size);

        if (pointer_find_Right == -1)
        {
          return vector_for_result.length - save_size;
        }
        else
        {
         //Значит правая последовательность найдена:

         //--------------------------------------------------------------------------
          if ((pointer_find_Left + request_struct_.left_size) == pointer_find_Right)
          {
            //Значит между двумя подстроками ничего нет. Значит заносить в вектор ничего, то есть подстроки между подстроками нет, НО мы занесем укзатель на Левую найденную подсроку и размер Ноль, чтобы было понятно, что искомая комбинация Левой и Правой подстроки была найдена, но она была "пустая":

            vector_for_result.add(new result_struct(pointer_find_Left, 0));
          }
          else
          {
            vector_for_result.add(new result_struct(pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size)));
          }
         //--------------------------------------------------------------------------


         //--------------------------------------------------------------------------
          if ((pointer_find_Right + request_struct_.right_size) > pointer_end)
          {
             //Значит за найденой Правой Ограничивающей подстрокой больше ничего нет:

            return vector_for_result.length - save_size;
          }
          else
          {
            offset = (pointer_find_Right + request_struct_.right_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
          }
        //--------------------------------------------------------------------------

        }
      }
    }
  }
}

  int get_vector_string__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final  request_struct request_struct_, List<Uint8List?> vector_for_result)
  {


//-----------------------------------------------------------------------------------------------------------------
List <result_struct> vector_for_result_pointer = [];

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
  vector_for_result[save_size + i] = new Uint8List(vector_for_result_pointer[i].size);

  memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].left_p, vector_for_result_pointer[i].size);
}


return vector_for_result.length - save_size;
//-----------------------------------------------------------------------------------------------------------------

}

  int get_vector_pointer__EndPointer__Limit_Counter(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result, final int Limit_Counter)
  {
//---------------------------------------------------------------
    int offset = 0;
//---------------------------------------------------------------
    int save_size = vector_for_result.length;
//---------------------------------------------------------------
    int Limit_Counter_inner = 0;
    //---------------------------------------------------------------




//---------------------------------------------------------------
    for (;;)
    {
      final int pointer_find_Left = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.left_p, request_struct_.left_size);

      if (pointer_find_Left == -1)
      {
        return vector_for_result.length - save_size;
      }
      else
      {
        //Ищем ответную правую часть:

        int CharBeg_for_FindRight = pointer_find_Left + request_struct_.left_size; //Указатель непосредвенно сразу после найденой левой подстроки.

        if (CharBeg_for_FindRight > pointer_end)
        {
          //Значит вышли за границы строки, значит после найденной левой ограничивающей подстроки больше ничего нет:

          return vector_for_result.length - save_size;
        }
        else
        {
          int pointer_find_Right = find_substring(Buffer, CharBeg_for_FindRight, pointer_end, request_struct_.right_p, request_struct_.right_size);

          if (pointer_find_Right == -1)
          {
            return vector_for_result.length - save_size;
          }
          else
          {
            //Значит правая последовательность найдена:

            //--------------------------------------------------------------------------
            if ((pointer_find_Left + request_struct_.left_size) == pointer_find_Right)
            {
              //Значит между двумя подстроками ничего нет. Значит заносить в вектор ничего, то есть подстроки между подстроками нет, НО мы занесем укзатель на Левую найденную подсроку и размер Ноль, чтобы было понятно, что искомая комбинация Левой и Правой подстроки была найдена, но она была "пустая":

              vector_for_result.add(new result_struct(pointer_find_Left, 0));

              Limit_Counter_inner++;
            }
            else
            {

              if (Limit_Counter_inner < Limit_Counter)
              {
                vector_for_result.add(new result_struct(pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size)));

                Limit_Counter_inner++;
              }
              else
              {
                return vector_for_result.length - save_size;
              }

            }
            //--------------------------------------------------------------------------


            //--------------------------------------------------------------------------
            if ((pointer_find_Right + request_struct_.right_size) > pointer_end)
            {
              //Значит за найденой Правой Ограничивающей подстрокой больше ничего нет:

              return vector_for_result.length - save_size;
            }
            else
            {
              offset = (pointer_find_Right + request_struct_.right_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
            }
            //--------------------------------------------------------------------------

          }
        }
      }
    }
  }

  int get_vector_string__EndPointer__Limit_Counter(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final  request_struct request_struct_, List<Uint8List?> vector_for_result, final int Limit_Counter)
  {


//-----------------------------------------------------------------------------------------------------------------
    List <result_struct> vector_for_result_pointer = [];

    final int result = get_vector_pointer__EndPointer__Limit_Counter(Buffer, pointer_beg, pointer_end, request_struct_, vector_for_result_pointer, Limit_Counter);

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
      vector_for_result[save_size + i] = new Uint8List(vector_for_result_pointer[i].size);

      memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].left_p, vector_for_result_pointer[i].size);
    }


    return vector_for_result.length - save_size;
//-----------------------------------------------------------------------------------------------------------------

  }

  int get_vector_pointer__with_pass(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, final int user_numm_pass, List<result_struct> vector_for_result) {
    //---------------------------------------------------------------
    int offset = 0;
    //---------------------------------------------------------------
    int save_size = vector_for_result.length;
    //---------------------------------------------------------------
    int pass_cntr = 0;
    //---------------------------------------------------------------
    int CharBeg_for_FindRight = 0;
    List<result_struct> vector_for_result_inner = [];
    //---------------------------------------------------------------


    //---------------------------------------------------------------
    for (;;)
    {
      final int pointer_find_Left = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.left_p, request_struct_.left_size);

      if (pointer_find_Left == -1)
      {
        return vector_for_result.length - save_size;
      }
      else
      {
        //Ищем ответную правую часть:

        CharBeg_for_FindRight = pointer_find_Left + request_struct_.left_size; //Указатель непосредвенно сразу после найденой левой подстроки.

        repeat:

        if (CharBeg_for_FindRight > pointer_end)
        {
          //Значит вышли за границы строки, значит после найденной левой ограничивающей подстроки больше ничего нет:

          return vector_for_result.length - save_size;
        }
        else
        {
          final int pointer_find_Right = find_substring(Buffer, CharBeg_for_FindRight, pointer_end, request_struct_.right_p, request_struct_.right_size);

          if (pointer_find_Right == -1)
          {
            return vector_for_result.length - save_size;
          }
          else
          {
            //Значит правая последовательность найдена: ТЕПЕРЬ с того места "CharBeg_for_FindRight" откуда мы искали ответную Правую подстроку - будем искать комбнацию Левой и Правой подстроки в указанном в "user_numm_pass" кол-ве:


            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            vector_for_result_inner.length = 0;

            final int res = get_vector_pointer__EndPointer__Limit_Counter(Buffer, CharBeg_for_FindRight, pointer_end, request_struct_, vector_for_result_inner, user_numm_pass);

            if (res != 0)
            {
              //Значит найдены комбинации в кол-ве минимум одной или максимум "user_numm_pass" - теперь нужно найти итоговую ответную правую часть.
              //Если указатель на ранее найденную Правую подстроку "pointer_find_Right" - Равен первому указателя на Правую посдтроку в векторе рузультатов "vector_for_result_inner" - то значит, что внутри "pointer_find_Left" - "pointer_find_Right"  находится точно также искомая комбанация, которую нужно пруостить. И теперь нужно пере-найти итоговую ответную правую часть - начиная поиск сразу за Последней Правой найденной подстрокой в векторе результатов.


              //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
              int front_pointer = 0;
              int back_pointer = 0;
              //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

              //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
              if (vector_for_result_inner.first.size == 0)
              {
                front_pointer = vector_for_result_inner.first.left_p + request_struct_.left_size;
              }
              else
              {
                front_pointer = vector_for_result_inner.first.left_p + vector_for_result_inner.first.size;
              }
              //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

              //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
              if (vector_for_result_inner.last.size == 0)
              {
                back_pointer = vector_for_result_inner.first.left_p + request_struct_.left_size + request_struct_.left_size;
              }
              else
              {
                back_pointer = vector_for_result_inner.last.left_p + vector_for_result_inner.last.size + request_struct_.right_size;
              }
              //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


              if (pointer_find_Right == front_pointer)
              {
                CharBeg_for_FindRight = back_pointer; //Указатель непосредвенно сразу после Послденей Правой ограничивающей подстроки

                final int pointer_find_Right = find_substring(Buffer, CharBeg_for_FindRight, pointer_end, request_struct_.right_p, request_struct_.right_size);

                if (pointer_find_Right == -1)
                {
                  return vector_for_result.length - save_size;
                }
                else
                {
                  //--------------------------------------------------------------------------
                  if ((pointer_find_Left + request_struct_.left_size) == pointer_find_Right)
                  {
                    //Значит между двумя подстроками ничего нет. Значит заносить в вектор ничего.
                  }
                  else
                  {
                    vector_for_result.add(new result_struct(pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size)));
                  }
                  //--------------------------------------------------------------------------


                  //--------------------------------------------------------------------------
                  if ((pointer_find_Right + request_struct_.right_size) > pointer_end)
                  {
                    //Значит за найденой Правой Ограничивающей подстрокой больше ничего нет:

                    return vector_for_result.length - save_size;
                  }
                  else
                  {
                    offset = (pointer_find_Right + request_struct_.right_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
                  }
                  //--------------------------------------------------------------------------
                }
              }
              else
              {
                //Значит внутри "pointer_find_Left" - "pointer_find_Right" - нет таких же комбинация, значит пропускать нечего.

                //--------------------------------------------------------------------------
                if ((pointer_find_Left + request_struct_.left_size) == pointer_find_Right)
                {
                  //Значит между двумя подстроками ничего нет. Значит заносить в вектор ничего, то есть подстроки между подстроками нет, НО мы занесем укзатель на Левую найденную подсроку и размер Ноль, чтобы было понятно, что искомая комбинация Левой и Правой подстроки была найдена, но она была "пустая":

                  vector_for_result.add(new result_struct(pointer_find_Left, 0));
                }
                else
                {
                  vector_for_result.add(new result_struct(pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size)));
                }
                //--------------------------------------------------------------------------


                //--------------------------------------------------------------------------
                if ((pointer_find_Right + request_struct_.right_size) > pointer_end)
                {
                  //Значит за найденой Правой Ограничивающей подстрокой больше ничего нет:

                  return vector_for_result.length - save_size;
                }
                else
                {
                  offset = (pointer_find_Right + request_struct_.right_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
                }
                //--------------------------------------------------------------------------
              }
            }
            else
            {
              //Значит не одна комбинация не была найдена, значит между Левой и Правой найденным подстроками нет таких же комбианция, которые нужно пропусть, значит искомая подстрока находитяся между "pointer_find_Left" и "pointer_find_Right".


              //--------------------------------------------------------------------------
              if ((pointer_find_Left + request_struct_.left_size) == pointer_find_Right)
              {
                //Значит между двумя подстроками ничего нет. Значит заносить в вектор ничего, то есть подстроки между подстроками нет, НО мы занесем укзатель на Левую найденную подсроку и размер Ноль, чтобы было понятно, что искомая комбинация Левой и Правой подстроки была найдена, но она была "пустая":

                vector_for_result.add(new result_struct(pointer_find_Left, 0));
              }
              else
              {
                vector_for_result.add(new result_struct(pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size)));
              }
              //--------------------------------------------------------------------------


              //--------------------------------------------------------------------------
              if ((pointer_find_Right + request_struct_.right_size) > pointer_end)
              {
                //Значит за найденой Правой Ограничивающей подстрокой больше ничего нет:

                return vector_for_result.length - save_size;
              }
              else
              {
                offset = (pointer_find_Right + request_struct_.right_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
              }
              //--------------------------------------------------------------------------
            }
            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

          }
        }
      }
    }
  }

  int get_vector_string__with_pass(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final  request_struct request_struct_, final  int user_numm_pass, List<Uint8List?> vector_for_result) {
    //-----------------------------------------------------------------------------------------------------------------
    List <result_struct> vector_for_result_pointer = [];

    final int result = get_vector_pointer__with_pass(Buffer, pointer_beg, pointer_end, request_struct_, user_numm_pass, vector_for_result_pointer);

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
      vector_for_result[save_size + i] = new Uint8List(vector_for_result_pointer[i].size);

      memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].left_p, vector_for_result_pointer[i].size);
    }

    return vector_for_result.length - save_size;
    //-----------------------------------------------------------------------------------------------------------------

  }

}


