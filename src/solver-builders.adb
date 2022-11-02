package body Solver.Builders is
   function Get_Literal_Vector_Array is new Literal_Vectors.Internal_Array
     (Literal_Array_Access);

   procedure Reserve (C : in out Clause_Builder; Size : Natural) is
   begin
      C.V.Reserve (Size);
   end Reserve;

   procedure Add (C : in out Clause_Builder; L : Literal) is
   begin
      C.V.Append (L);
   end Add;

   function Copy (C : Clause_Builder) return Clause_Builder is
   begin
      return (V => C.V.Copy);
   end Copy;

   function Build (C : Clause_Builder) return Clause is
   begin
      return Get_Literal_Vector_Array (C.V);
   end Build;

   procedure Destroy (C : in out Clause_Builder) is
   begin
      C.V.Destroy;
   end Destroy;

   function Build_And_Destroy (C : in out Clause_Builder) return Clause is
      R : constant Clause := C.Build;
   begin
      C.V := Literal_Vectors.Empty_Vector;
      return R;
   end Build_And_Destroy;

   procedure Add (F : in out Formula_Builder; C : Clause) is
   begin
      F.V.Append (C);
   end Add;

   function Is_Subset (C1, C2 : Clause) return Boolean is
     (for all X of C1.all => (for some Y of C2.all => X = Y));

   procedure Add_Simplify (F : in out Formula_Builder; C : Clause) is
      I : Natural := 1;
      D : Clause;
   begin
      while I <= F.V.Length loop
         D := F.V.Get (I);
         if Is_Subset (C, D) then
            F.V.Swap_And_Remove (I);
         elsif Is_Subset (D, C) then
            return;
         else
            I := I + 1;
         end if;
      end loop;
      F.V.Append (C);
   end Add_Simplify;

   function Is_Feasible (F : Formula_Builder; V : Variable) return Boolean is
   begin
      for C of F.V loop
         if C'Length = 1 and then C (C'First) = -V then
            return False;
         end if;
      end loop;
      return True;
   end Is_Feasible;

   procedure Destroy (F : in out Formula_Builder) is
   begin
      F.V.Destroy;
   end Destroy;

   function Build_And_Destroy (F : in out Formula_Builder) return Formula is
      R : constant Formula := F.V;
   begin
      F.V := Clause_Vectors.Empty_Vector;
      return R;
   end Build_And_Destroy;
end Solver.Builders;
