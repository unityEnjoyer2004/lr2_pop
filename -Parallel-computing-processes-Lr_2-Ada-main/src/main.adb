with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;


procedure Main is

   Size : constant Integer := 1000;
   Thread_Num : constant Integer := 5;

   Arr : array(1..Size) of Integer;
   Min_Element : Integer := Integer'Last;
   Min_Index : Integer := 1;




   procedure Init_Arr is
      subtype Random_Range is Integer range 1 .. 10000;
      package R is new Ada.Numerics.Discrete_Random (Random_Range);
      use R;

      G : Generator;
      X : Random_Range;
   begin
      Reset(G);

      for I in 1..Size loop
         X := Random(G);
         Arr(I) := X;

          --  if X mod 2 = 0 then
          --   Arr(I) := -Arr(I);
          --  end if;
      end loop;
end Init_Arr;


   procedure Part_Min(Start_Index, Finish_Index : in Integer) is
   begin
      for I in Start_Index..Finish_Index loop
         if Arr(I) < Min_Element then
            Min_Element := Arr(I);
            Min_Index := I;
         end if;
      end loop;
   end Part_Min;

   task type Starter_Thread is
      entry Start(Start_Index, Finish_Index : in Integer);
   end Starter_Thread;

   protected Part_Manager is
      procedure Set_Part_Min(Element : in Integer; Index : in Integer);
      entry Get_Min(Element : out Integer; Index : out Integer);
   private
      Tasks_Count : Integer := 0;
      Min_Element1 : Integer := Integer'Last;
      Min_Index1 : Integer := 1;
   end Part_Manager;

   protected body Part_Manager is
      procedure Set_Part_Min(Element : in Integer; Index : in Integer) is
      begin
         if Element < Min_Element1 then
            Min_Element1 := Element;
            Min_Index1 := Index;
         end if;
         Tasks_Count := Tasks_Count + 1;
      end Set_Part_Min;

      entry Get_Min(Element : out Integer; Index : out Integer) when Tasks_Count = Thread_Num is
      begin
         Element := Min_Element1;
         Index := Min_Index1;
      end Get_Min;

   end Part_Manager;

   task body Starter_Thread is
      Start_Index, Finish_Index : Integer;
   begin
      accept Start(Start_Index, Finish_Index : in Integer) do
         Starter_Thread.Start_Index := Start_Index;
         Starter_Thread.Finish_Index := Finish_Index;
      end Start;
      Part_Min(Start_Index  => Start_Index,
               Finish_Index => Finish_Index);
      Part_Manager.Set_Part_Min(Min_Element, Min_Index);
   end Starter_Thread;

   function Parallel_Min return Integer is
      Min : Integer := Integer'Last;
      Index : Integer := 1;
      Thread : array(1..Thread_Num) of Starter_Thread;
   begin
      for I in 1..Thread_Num loop
         Thread(I).Start((I - 1) * Size / Thread_Num + 1, I * Size / Thread_Num);
      end loop;
      Part_Manager.Get_Min(Min, Index);
      return Min;
   end Parallel_Min;





begin

   Init_Arr;
   Put_Line("The number of elements: "&Size'Img);
   Put_line("The number of threads: "&Thread_Num'Img);
   Put_Line("Minimum element: " & Parallel_Min'Img);
   Put_Line("Index of minimum element: " & Min_Index'Img);


end Main;
