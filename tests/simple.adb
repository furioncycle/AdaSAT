with Ada.Text_IO; use Ada.Text_IO;

with AdaSAT.DPLL;
with AdaSAT.Formulas;
with AdaSAT.Theory;

procedure Simple is
   use AdaSAT;
   use AdaSAT.Formulas;

   type Empty_Context is null record;
   function Check
     (Ctx : in out Empty_Context;
      M   : Model;
      F   : in out Formula) return Boolean;

   function Check
     (Ctx : in out Empty_Context;
      M   : Model;
      F   : in out Formula) return Boolean
   is (True);

   package Empty_Theory is new Theory (Empty_Context, Check);
   package DPLLT is new DPLL (Empty_Theory);

   F : Formula;
   M : Model := [1 .. 7 => Unset];
   C : Empty_Context;
begin
   F.Append (new Literal_Array'(-1, +2));
   F.Append (new Literal_Array'(-3, +4));
   F.Append (new Literal_Array'(-6, -5, -2));
   F.Append (new Literal_Array'(-5, +6));
   F.Append (new Literal_Array'(+5, +7));
   F.Append (new Literal_Array'(-1, +5, -7));
   if DPLLT.Solve (F, C, M) then
      Put_Line ("Solved");
   else
      Put_Line ("Failed solving");
   end if;
   for E of M loop
      Put (E'Image);
      Put (" ");
   end loop;
   New_Line;
end Simple;
