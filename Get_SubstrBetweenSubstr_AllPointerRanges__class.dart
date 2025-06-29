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
  int left_out_p          = -1;      //Указатель на первый левый символ Левой внешней подстроки, то есть эта та подстрока, которая идет перед Левой ограничающей подстрокой.
  int left_out_size       = -1;      //Размер


  int left_external_p     = -1;      //Указатель на первый левый символ Левой ограничивающей подстроки.
  int left_external_size  = -1;      //Хотя Размер ограничевающей подстроки я доджен знать и так, ведь я его передаю в фунецию, но пусть будет для удобства.

  int left_internal_p     = -1;      //Указатель на первый левый символ найденной подстроки.
  int internal_size       = -1;      //Размер подстроки начиная с left_p

  int right_external_p    = -1;       //Указатель на первый левый символ Правой ограничивающей подстроки.
  int right_external_size = -1;       //Хотя Размер ограничевающей подстроки я доджен знать и так, ведь я его передаю в фунецию, но пусть будет для удобства.


  int right_out_p = -1;               //ВНИМАНИЕ: это хвост только для последнего элемента в переданном векторе "vector_for_result". Это Указатель на первый левый символ Правой внешней подстроки, то есть эта та подстрока, которая идет после Правой ограничающей подстроки уже до конца самой строки. Актуально только при right_out_size > 0.
  int right_out_size = -1;            //Размер


  result_struct(this.left_out_p, this.left_out_size, this.left_external_p, this.left_external_size, this.left_internal_p, this.internal_size, this.right_external_p, this.right_external_size);
}

class request_struct
{
  late Uint8List left_p;
  late int left_size;

  late Uint8List right_p;
  late int right_size;

  request_struct(this.left_p, this.left_size, this.right_p, this.right_size);
}






class Get_SubstrBetweenSubstr_AllPointerRanges__class
{

  //----------------------------------------------------------------------------public:----------------------------------------------------------------------------------
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
      final int pointer_find_Left = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.left_p, request_struct_.left_size);

      if (pointer_find_Left == -1)
      {
        FinishRecording_BackTail(vector_for_result, offset, pointer_end); //Записываем послдений задний "хвост", то есть то, что осталось после Правой ограничивающей подстроки до конца строки.

        return vector_for_result.length - save_size;
      }
      else
      {
//Ищем ответную правую часть:


        final int CharBeg_for_FindRight = pointer_find_Left + request_struct_.left_size; //Указатель непосредвенно сразу после найденой левой подстроки.

        if (CharBeg_for_FindRight > pointer_end)
        {
//Значит вышли за границы строки:

          FinishRecording_BackTail(vector_for_result, offset, pointer_end); //Записываем послдений задний "хвост", то есть то, что осталось после Правой ограничивающей подстроки до конца строки.

          return vector_for_result.length - save_size;
        }
        else
        {
          final int pointer_find_Right = find_substring(Buffer, CharBeg_for_FindRight, pointer_end, request_struct_.right_p, request_struct_.right_size);

          if (pointer_find_Right == 0)
          {
            FinishRecording_BackTail(vector_for_result, offset, pointer_end); //Записываем послдений задний "хвост", то есть то, что осталось после Правой ограничивающей подстроки до конца строки.

            return vector_for_result.length - save_size;
          }
          else
          {
//Значит правая последовательность найдена:


//------------------------------------------------------------------
            if (offset == 0)
            {
//Значит это первая найденная последотвалеьность:

              vector_for_result.add(new result_struct(pointer_beg, pointer_find_Left - pointer_beg, pointer_find_Left, request_struct_.left_size, pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size), pointer_find_Right, request_struct_.right_size));
            }
            else
            {
//Значит это минимум вторая найденная последотвалеьность:

              vector_for_result.add(new result_struct(vector_for_result.last.right_external_p + vector_for_result.last.right_external_size, pointer_find_Left - (vector_for_result.last.right_external_p + vector_for_result.last.right_external_size), pointer_find_Left, request_struct_.left_size, pointer_find_Left + request_struct_.left_size, pointer_find_Right - (pointer_find_Left + request_struct_.left_size), pointer_find_Right, request_struct_.right_size));
            }
//------------------------------------------------------------------


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


//---------------------------------------------------------------------------private:----------------------------------------------------------------------------

  void FinishRecording_BackTail(List<result_struct> vector_for_result, final int offset, final int pointer_end)
  {
//-------------------------Дозаписываем задний хвост:начало-------------------
    if (offset != 0)
    {
//Значит минимум одна последовтаельность уже была найдена и после нее до окнца строки остался "задний хвост", занесем его.

      vector_for_result.last.right_out_p = vector_for_result.last.right_external_p + vector_for_result.last.right_external_size;vector_for_result.last.right_out_size = pointer_end - vector_for_result.last.right_out_p + 1;
    }
//-------------------------Дозаписываем задний хвост:конец-------------------

  }


}
