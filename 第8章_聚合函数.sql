use atguigudb;

# 1. 常见的聚合函数
# 1.1 avg/sum  只适用数值类型的字段
# 计算都会过滤空值
select avg(salary), sum(salary)
from employees;

# 1.2 max/min
select max(salary), min(salary)
from employees;

select max(last_name), min(last_name), max(hire_date), min(hire_date)
from employees;


# 1.3 count
# 作用：计算指定字段在查询结果中出现的个数
select count(employee_id), count(salary), count(1)
from employees;

# 计算表中有多少条记录
# count(1)  count(*)
# count(1)和count(*)不考虑空值
# count(具体字段):不一定对
# null不算，属于空值，遇见null就会跳过而不加一
# count不计算空值
select count(commission_pct)
from employees;

select commission_pct
from employees
where commission_pct is not null;

select avg(salary), sum(salary)/count(salary),
       avg(commission_pct), sum(commission_pct)/count(commission_pct), sum(commission_pct)/107
from employees;

# 需求：查询公司中平均奖金率
# 错误的
select avg(commission_pct)
from employees;

# 正确的
# ifnull(exp1, exp2)，如果exp1不是null的话，那么返回值为exp1，否则返回exp2
select sum(commission_pct)/count(ifnull(commission_pct, 0)),
       avg(ifnull(commission_pct, 0))
from employees;

# 2. Group by的使用
# 需求：查询各个部门的平均工资，最高工资
select department_id, avg(salary), sum(salary)
from employees
group by department_id;

# 需求：查询各个job_id的平均工资
select job_id, avg(salary), sum(salary)
from employees
group by job_id;

# 需求：查询各个department_id，job_id的平均工资
select department_id, job_id, avg(salary)
from employees
group by department_id, job_id;
# 或者 效果是一样的，只是先后顺序不一样，但是属性确实一样的
select department_id, job_id, avg(salary)
from employees
group by job_id, department_id;

# 错误的
select department_id, job_id, avg(salary)
from employees
group by department_id;

# 结论1：select中出现的字段必须申明在group by字段中，反之group by中的字段
#       可以不出现在select中
# 结论2：group by声明在from后，where后，order by前面，limit前面
# 结论3：group by中使用with rollup，这个功能说白了就是在求完分组的平均值后然后对所有组再平均一次
select department_id, avg(salary)
from employees
group by department_id with rollup;

# 需求：查询各个部分的平均工资，按照评价工资升序排列
select department_id, avg(salary) avg_sal
from employees
group by department_id
order by avg_sal asc;



# 3. having的使用（用来过滤数据的）
# 练习：查询各个部门中最高工资比10000高的部门的部门信息
# 错误的
select department_id, max(salary)
from employees
where max(salary) > 10000
group by department_id;

# 要求1：如果过滤条件中使用了聚合函数，则必须使用having来替换where，否则报错
# 要求2：having必须声明在group by后面
# 正确的写法：
select department_id, max(salary)
from employees
group by department_id
having max(salary) > 10000;

# 要求3： 开发中，我们使用了having函数的前提是使用了group by
# 练习：查询部门id为10，20，30，40这4个部门中最高工资比10000高的部门信息
# 方式1：推荐，执行效率比方式2更高
select department_id, max(salary)
from employees
where department_id in (10 ,20, 30, 40)
group by department_id
having max(salary) > 10000;

# 方式2：
select department_id, max(salary)
from employees
group by department_id
having max(salary) > 10000 and department_id in (10 ,20, 30, 40);

# 结论：当过滤条件中有聚合函数时，则此过滤条件必须声明在having中
#      当过滤条件中没有聚合函数时，则过滤条件声明在where中或者having中都可以，但是
#      建议声明在where中


# 4. SQL底层原理