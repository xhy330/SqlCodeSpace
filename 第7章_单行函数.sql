use atguigudb;

SELECT
ABS(-123),ABS(32),SIGN(-23),SIGN(43),PI(),CEIL(32.32),CEILING(-43.23),FLOOR(32.32),
FLOOR(-43.23),MOD(12,5)
FROM DUAL;

SELECT RAND(),RAND(),RAND(10),RAND(10),RAND(-1),RAND(-1)
FROM DUAL;

SELECT
ROUND(12.33),ROUND(12.343,2),ROUND(12.324,-1),TRUNCATE(12.66,1),TRUNCATE(12.66,-1)
FROM DUAL;


#2. 字符串函数
# ASCII只返回第一字的ASCII码
select ASCII('Abcdefsf')
from dual;

# length 和 char_length
/*
一个字符占一个字节，所以length('hello')为5，char_length是字节字母的个数也是5
可以的出结论，汉字中，在UTF-8的编码环境下，一个中文占3个字节
*/
select length('hello'), char_length('hello'), length('我们'), char_length('我们')
from dual;

# concat()，变量与字符串的拼接
select concat(emp.last_name, ' works for ', mgr.last_name) "details"
from employees emp join employees mgr
on emp.manager_id = mgr.employee_id;

# concat_ws()
# 用第一个字符来拼接后面的字符串
# 如果是''就是concat()函数
select concat_ws('-', 'hello', 'world','hello')
from dual;

# insert()
# 字符串是从1开始的
# 用将第2个位置开始的三个长度的字符用aaaaa来替换
# replace就是找到对应的字符串来替换
select insert('hello', 2, 3, 'aaaaa'), replace('hello', 'll', 'mm')
from dual;

select upper('hello'), lower('Hello')
from dual;

select left('hello', 2), right('hello', 3), right('hello', 13)
from dual;

# lpad的第一个参数是str，第二个参数是str的长度
# left padding  左边填充，右边对齐
# 如果不够，就会用'*'来补齐，从左侧开始
# rpad同理，右边填充，左边对齐
select employee_id, last_name, lpad(salary, 10, '*')
from employees;

select concat('---', trim('   h ello  '), '---'), trim('o' from 'oohello')
from dual;



/*
3. 流程控制函数
if(c, v1, v2)，如果c
*/
select last_name, salary, if(salary >= 6000, '高工资', '低工资') "details"
from employees;

select last_name, commission_pct, if(commission_pct is not null, commission_pct, 0) "details",
       salary*12*(1+if(commission_pct is not null, commission_pct, 0)) "annual_sal"
from employees;

select last_name, commission_pct, ifnull(commission_pct, 0) "details"
from employees;

# case when then    case when then
# 类似于if else
select last_name, salary, case when salary >= 15000 then '白骨精'
                               when salary >= 10000 then '潜力股'
                               when salary >= 8000 then '小屌丝'
                               else '草根' end "datils", department_id
from employees;

/*
练习1：
查询部门号为 10,20, 30 的员工信息,
若部门号为 10, 则打印其工资的 1.1 倍,
20 号部门, 则打印其工资的 1.2 倍,
30 号部门打印其工资的 1.3 倍,
其他的部门则打印其工资的1.4倍。
*/

select employee_id, last_name, department_id, salary,
       case department_id when 10 then salary*1.1
                          when 20 then salary*1.2
                          when 30 then salary*1.3
                          else salary*1.4 end "details"
from employees;


/*
练习2：
查询部门号为 10,20, 30 的员工信息,
若部门号为 10, 则打印其工资的 1.1 倍,
20 号部门, 则打印其工资的 1.2 倍,
30 号部门打印其工资的 1.3 倍
*/

select employee_id, last_name, department_id, salary,
       case department_id when 10 then salary*1.1
                          when 20 then salary*1.2
                          when 30 then salary*1.3
                          end "details"
from employees
where department_id in (10, 20, 30);

