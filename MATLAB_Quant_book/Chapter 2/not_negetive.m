function not_negetive
A=input('input a number:\n');
C=0;
if A>=0
    B='A';
else
    B='C';
end
expression=['OUTPUT=' B ';'];
fprintf('the expression is ''%s''\n', expression)
eval(expression);
fprintf('the result is %d\n',OUTPUT)
