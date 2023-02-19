use atguigudb;

/*
第9章————子查询
*/
# 需求：谁的工资比Abel高
# 方法1：
# 与服务器做两次交互，效率很低
select salary
from employees
where last_name = 'Abel';

select last_name, salary
from employees
where salary > 11000;

# 方法2：
# 自连接，只查询一次
select e2.last_name, e2.salary
from employees e1
join employees e2
on e1.last_name = 'Abel'
and e2.salary > e1.salary;

# 方法3：
# 外查询(主查询)和内查询(子查询)
select last_name, salary
from employees
where salary > (
                select salary
                from employees
                where last_name = 'Abel'
                );


# 子查询的分类
# 角度1：从内查询返回的结果的条目数
#       当行子查询  vs  多行子查询

# 角度2：内查询是否被执行多次
#       相关子查询  vs  不相关子查询

# 相关子查询的需求：内外查询具有相关性，外查询的不同，导致内查询的结果是不一样的
# 相关子查询需求：查询工资大于本部门平均工资的员工信息        你很帅，媳妇很帅，孩子不会丑
# 不相关子查询需求：查询工资大于本公司平均工资的员工信息       你跟你邻居比帅，没关系

# 子查询的编写技巧：从里往外写，从外往里写
# 单行子查询操作符
# 题目：查询工资大于149号员工工资的员工信息
select last_name, salary
from employees
where salary > (
                select salary
                from employees
                where employee_id = 149
                );

# 题目：返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
select last_name, job_id, salary
from employees
where job_id = (
                select job_id
                from employees
                where employee_id = 141
                )
and salary > (
                select salary
                from employees
                where employee_id = 143
                );

# 题目：返回公司工资最少的员工的last_name,job_id和salary
select last_name, job_id, salary
from employees
where salary = (
    select min(salary)
    from employees
    );


# 题目：查询与141号员工的manager_id和department_id相同的其他员工的employee_id，
# manager_id，department_id
select employee_id, manager_id, department_id
from employees
where manager_id = (
    select manager_id
    from employees
    where employee_id = 141
    )
and department_id = (
    select department_id
    from employees
    where employee_id = 141
    );

# Having中的子查询
# 题目：查询最低工资大于50号部门最低工资的部门id和其最低工资
Select department_id, min(salary)
from employees
where department_id is not null
group by department_id
having min(salary) > (select min(salary)
                 from employees
                 where department_id = 50);

# case中使用子查询
# 题目：显式员工的employee_id,last_name和location。其中，若员工department_id与location_id为1800
# 的department_id相同，则location为’Canada’，其余则为’USA’。
select employee_id, last_name, case department_id when (select department_id from departments where location_id =  1800) then 'Canada'
                                                   else 'USA' end "location"
from employees;

# 空值
SELECT last_name, job_id
FROM employees
WHERE job_id =
                (SELECT job_id
                FROM employees
                WHERE last_name = 'Haas');

# 非法使用子查询
SELECT employee_id, last_name
FROM employees
WHERE salary =
            (SELECT MIN(salary)
            FROM employees
            GROUP BY department_id);


# 多行子查询，就是子查询返回了多行数据，=连接就不行了
# 多行子查询的操作符：in any all some

# in
SELECT employee_id, last_name
FROM employees
WHERE salary in (SELECT MIN(salary)
                FROM employees
                GROUP BY department_id);

# any
# 题目：返回其它job_id中比job_id为‘IT_PROG’部门任一工资低的员工的员工号、姓名、job_id 以及salary
select employee_id, last_name, job_id, salary
from employees
where job_id <> 'IT_PROG'
and salary < any (
    select salary
    from employees
    where job_id = 'IT_PROG'
);

# all
# 题目：返回其它job_id中比job_id为‘IT_PROG’部门所有工资低的员工的员工号、姓名、job_id 以及salary
select employee_id, last_name, job_id, salary
from employees
where job_id <> 'IT_PROG'
and salary < all (
    select salary
    from employees
    where job_id = 'IT_PROG'
);

# 题目：查询平均工资最低的部门id
# 方式1：
select department_id
from employees
group by department_id
having avg(salary) = (
    select min(avg_sal)
    from(
        select avg(salary) avg_sal
        from employees
        group by department_id
        ) t_dept_avg_sal
    );

# 方式2：
select department_id
from employees
group by department_id
having avg(salary) <= all(
    select avg(salary)
    from employees
    group by department_id
);



# 相关子查询
# 题目：查询员工中工资大于本公司平均工资的员工的last_name,salary和其department_id
select last_name, salary, department_id
from employees
where salary > (
    select avg(salary)
    from employees
    );

# 题目：查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
# 把外连接的数据传入内查询，每次
# 方式1
select last_name, salary, department_id
from employees e1
where salary > (
    select avg(salary)
    from employees e2
    where e2.department_id = e1.department_id
    );

# 方式2
select e.last_name, e.salary, e.department_id
from employees e join (
                select department_id, avg(salary) avg_sal
                from employees
                group by department_id) t_dept_avg_sal
on e.department_id = t_dept_avg_sal.department_id
and e.salary > t_dept_avg_sal.avg_sal;

# 题目：查询员工的id,salary,按照department_name 排序
select employee_id, salary
from employees e
order by (
    select department_name
    from departments d
    where e.department_id = d.department_id
             );

# 题目：若employees表中employee_id与job_history表中employee_id相同的数目
# 不小于2，输出这些相同id的员工的employee_id,last_name和其job_id
select employee_id, last_name, job_id
from employees e
where 2 <= (
    select count(*)
    from job_history j
    where e.employee_id = j.employee_id
    );

# exists 与 not exists
# 题目：查询公司管理者的employee_id，last_name，job_id，department_id信息
