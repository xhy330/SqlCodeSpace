use atguigudb;

desc employees;
desc departments;
desc locations;

select *
from employees
where last_name = 'Abel';

select *
from departments
where department_id = 80;

select *
from locations
where location_id = 2500;

# 多表连接
select employee_id, department_name
from employees, departments
where employees.department_id = departments.department_id;

select employee_id, department_name, employees.department_id
from employees, departments
where employees.department_id = departments.department_id;


select employee_id, last_name, department_name, city
from employees, departments, locations
where employees.department_id=departments.department_id and departments.location_id = locations.location_id;

select *
from job_grades;

select last_name,salary,grade_level
from employees e, job_grades j
where e.salary between j.lowest_sal and j.highest_sal;

select e.employee_id, e.last_name, m.employee_id, m.last_name
from employees e, employees m
where e.manager_id = m.manager_id;

# SQL99实现内连接
select last_name, department_name
from employees e join departments d
on e.department_id = d.department_id;

select last_name, department_name, city
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id;

# 查询所有员工的last_name，department_name信息
# 左外连接：
select last_name, department_name
from employees e left join departments d
on e.department_id = d.department_id;

# 右外连接
select last_name, department_name
from employees e right join departments d
on e.department_id = d.department_id;

