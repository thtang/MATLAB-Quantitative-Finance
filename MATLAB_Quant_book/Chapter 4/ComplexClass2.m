classdef ComplexClass2
	properties
		X,Y
	end
	methods
		function obj3 = plus(obj1,obj2)
		obj3 = ComplexClass2; %����obj3����,�粻������Ϊ��ͨ�ṹ��
		obj3.X = obj1.X+obj2.X;
		obj3.Y = obj1.Y+obj2.Y;
		end
	end
end


