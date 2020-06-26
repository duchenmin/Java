--创建表空间
create tablespace test datafile 'I:\app\Administrator\oradata\orcl\test01.dbf'SIZE 10M;
--创建用户manager
create USER manager IDENTIFIED BY abc123 DEFAULT Tablespace test QUOTA 5m on test;
--授权系统权限
GRANT CREATE　session,create table to manager; 
--用manager账号登陆
connect manager/abc123;
--创建teacher教师表
create table teacher(
tname char(20) not null,
sex char(2) check(sex in('男','女'))，
tno char(12) primary key,
tphone char(20) not null
);
--创建course课程表
create table course(
cname char(20) UNIQUE,
cno NUMBER(6)primary key,
credit NUMBER(2,1),
sdept char(12)
);
--创建student学生表
create table student(
sname char(20) not null,
sex char(2) check(sex in('男','女')),
sno char(12) primary key,
sdept char(12),
sphone char(11),
birthday date
);
--创建KC开设课程表
create table KC(
tno char(12) references teacher(tno) on delete cascade,
cno number(2) references course(cno) on delete cascade,
shijian char(20),
primary key(shijian,tno,cno)
);
--创建SC表
create table SC(
sno char(12) references student(sno) on delete cascade,
cno number(6),
tno char(12),
shijian char(20),
grade number(2)not null,
foreign key(shijian,tno,cno)references KC(shijian,tno,cno) 
on delete cascade, 
primary key(shijian,tno,cno,sno)
);
--创建视图avg_v
create view avg_v(tname,cname,shijian,Gavg)
as select tname,cname,shijian,avg(grade)
from teacher a,course b,sc c
where a.tno = c.tno and b.cno = c.cno
group by (tname,cname,shijian);
--创建视图cou_v
create view cou_v(shijian,cname,Gavg)
as select shijian,cname,avg(grade)
from course a,sc b
where a.cno = b.cno
group by (shijian,cname);
--创建索引
create unique index SCno on SC(sno desc,tno asc,CNO asc,shijian desc);
--用户登录的存储过程
create or replace procedure denglu(flag out number,username varchar2,upwd number)---登录
as
i varchar2(20);
p number;
begin
  flag:=0;
  select t.ename into i fronm scott.yonghu t where t.ename=username and t.eno = upwd;
  if upwd is not null then
    flag := 2;--登录成功
    else
      flag := 1;--密码不正确
      end if;
    else
      flag := 0;--用户不存在
      end if
    commit;
    exception when no_data_found then
      rollback;
    end;
--测试数据
--teacher教师表测试
insert into teacher(tname,sex,tno,tphone)values('李娜'，'女','2012131409','13821129211');
insert into teacher(tname,sex,tno,tphone)values('赵满来'，'男','2012131427','17721129437');
insert into teacher(tname,sex,tno,tphone)values('齐斐'，'男','2012131439','19923127788');
insert into teacher(tname,sex,tno,tphone)values('余鋆'，'男','2012131446','16834126689');
insert into teacher(tname,sex,tno,tphone)values('郭涛'，'男','2012131458','13245125347');
insert into teacher(tname,sex,tno,tphone)values('邵泽云'，'男','2012131466','1505141212');
select * from teacher;
--student学生表测试
insert into student(sname,sex,sno,sdept,sphone,birthday)values('杜晨敏'，'男','2017051202','计算机'，'17793479223',to_date('1999-04-13','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('刘艳'，'女','2017051202','通信工程'，'17793471234',to_date('1998-05-12','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('杨乐'，'男','2017051267','网络工程'，'17793479223',to_date('1999-07-18','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('王东东'，'男','2017051223','电子信息'，'17793479223',to_date('1999-09-28','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('郭鹏'，'男','2017051245','物联网'，'17793479223',to_date('1999-11-11','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('张丽娟'，'男','2017051289','数学统计'，'17793479223',to_date('1999-06-09','yyyy-mm-dd'));
select * from student;
--测试course课程表
insert into course(cname,cno,credit,sdept)values('企业级框架',89,5,'计算机');
insert into course(cname,cno,credit,sdept)values('计算机网络',34,3,'通信工程');
insert into course(cname,cno,credit,sdept)values('Oracle',45,4,'物联网');
insert into course(cname,cno,credit,sdept)values('计算机组成原理',67,2,'电子信息');
select *  from course;

--KC开设课程表数据如下
insert into KC(tno,cno,shijian)values('2012131409',89,'2019-2020第二学期');
insert into KC(tno,cno,shijian)values('2012131466',34,'2019-2020第二学期');
insert into KC(tno,cno,shijian)values('2012131439',45,'2019-2020第二学期');
insert into KC(tno,cno,shijian)values('2012131458',67,'2019-2020第二学期');
select * from KC;
--选课数据测试
insert into sc(sno,cno,tno,shijian,grade)values('2017051202','89','2012131409','2019-2020第二学期',90);
insert into sc(sno,cno,tno,shijian,grade)values('2017051267','34','2012131466','2019-2020第二学期',88);
insert into sc(sno,cno,tno,shijian,grade)values('2017051223','45','2012131439','2019-2020第二学期',92);
insert into sc(sno,cno,tno,shijian,grade)values('2017051289','67','2012131458','2019-2020第二学期',67);
select * from sc;
--数据备份
alter tablespace test begin backup;
host copy I:\app\Administrator\oradata\orcl\test01.dbf
I:\app\Administrator\oradata\documents\test01.dbf
alter tablespace test end backup;
