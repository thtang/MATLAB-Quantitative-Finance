classdef ComplexClass
	properties
		X,Y
	end
	methods
		function obj3 = complex_add(obj1,obj2) % �ӷ�
		obj3.X = obj1.X+obj2.X;
		obj3.Y = obj1.Y+obj2.Y;
		end
		function obj3 = multiplyByScalar(obj,n) % ���Գ���
		obj3.X = obj.X * n;
		obj3.Y = obj.Y * n;
		end
	end
end
