--������ռ�
create tablespace test datafile 'I:\app\Administrator\oradata\orcl\test01.dbf'SIZE 10M;
--�����û�manager
create USER manager IDENTIFIED BY abc123 DEFAULT Tablespace test QUOTA 5m on test;
--��ȨϵͳȨ��
GRANT CREATE��session,create table to manager; 
--��manager�˺ŵ�½
connect manager/abc123;
--����teacher��ʦ��
create table teacher(
tname char(20) not null,
sex char(2) check(sex in('��','Ů'))��
tno char(12) primary key,
tphone char(20) not null
);
--����course�γ̱�
create table course(
cname char(20) UNIQUE,
cno NUMBER(6)primary key,
credit NUMBER(2,1),
sdept char(12)
);
--����studentѧ����
create table student(
sname char(20) not null,
sex char(2) check(sex in('��','Ů')),
sno char(12) primary key,
sdept char(12),
sphone char(11),
birthday date
);
--����KC����γ̱�
create table KC(
tno char(12) references teacher(tno) on delete cascade,
cno number(2) references course(cno) on delete cascade,
shijian char(20),
primary key(shijian,tno,cno)
);
--����SC��
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
--������ͼavg_v
create view avg_v(tname,cname,shijian,Gavg)
as select tname,cname,shijian,avg(grade)
from teacher a,course b,sc c
where a.tno = c.tno and b.cno = c.cno
group by (tname,cname,shijian);
--������ͼcou_v
create view cou_v(shijian,cname,Gavg)
as select shijian,cname,avg(grade)
from course a,sc b
where a.cno = b.cno
group by (shijian,cname);
--��������
create unique index SCno on SC(sno desc,tno asc,CNO asc,shijian desc);
--�û���¼�Ĵ洢����
create or replace procedure denglu(flag out number,username varchar2,upwd number)---��¼
as
i varchar2(20);
p number;
begin
  flag:=0;
  select t.ename into i fronm scott.yonghu t where t.ename=username and t.eno = upwd;
  if upwd is not null then
    flag := 2;--��¼�ɹ�
    else
      flag := 1;--���벻��ȷ
      end if;
    else
      flag := 0;--�û�������
      end if
    commit;
    exception when no_data_found then
      rollback;
    end;
--��������
--teacher��ʦ�����
insert into teacher(tname,sex,tno,tphone)values('����'��'Ů','2012131409','13821129211');
insert into teacher(tname,sex,tno,tphone)values('������'��'��','2012131427','17721129437');
insert into teacher(tname,sex,tno,tphone)values('���'��'��','2012131439','19923127788');
insert into teacher(tname,sex,tno,tphone)values('���]'��'��','2012131446','16834126689');
insert into teacher(tname,sex,tno,tphone)values('����'��'��','2012131458','13245125347');
insert into teacher(tname,sex,tno,tphone)values('������'��'��','2012131466','1505141212');
select * from teacher;
--studentѧ�������
insert into student(sname,sex,sno,sdept,sphone,birthday)values('�ų���'��'��','2017051202','�����'��'17793479223',to_date('1999-04-13','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('����'��'Ů','2017051202','ͨ�Ź���'��'17793471234',to_date('1998-05-12','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('����'��'��','2017051267','���繤��'��'17793479223',to_date('1999-07-18','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('������'��'��','2017051223','������Ϣ'��'17793479223',to_date('1999-09-28','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('����'��'��','2017051245','������'��'17793479223',to_date('1999-11-11','yyyy-mm-dd'));
insert into student(sname,sex,sno,sdept,sphone,birthday)values('������'��'��','2017051289','��ѧͳ��'��'17793479223',to_date('1999-06-09','yyyy-mm-dd'));
select * from student;
--����course�γ̱�
insert into course(cname,cno,credit,sdept)values('��ҵ�����',89,5,'�����');
insert into course(cname,cno,credit,sdept)values('���������',34,3,'ͨ�Ź���');
insert into course(cname,cno,credit,sdept)values('Oracle',45,4,'������');
insert into course(cname,cno,credit,sdept)values('��������ԭ��',67,2,'������Ϣ');
select *  from course;

--KC����γ̱���������
insert into KC(tno,cno,shijian)values('2012131409',89,'2019-2020�ڶ�ѧ��');
insert into KC(tno,cno,shijian)values('2012131466',34,'2019-2020�ڶ�ѧ��');
insert into KC(tno,cno,shijian)values('2012131439',45,'2019-2020�ڶ�ѧ��');
insert into KC(tno,cno,shijian)values('2012131458',67,'2019-2020�ڶ�ѧ��');
select * from KC;
--ѡ�����ݲ���
insert into sc(sno,cno,tno,shijian,grade)values('2017051202','89','2012131409','2019-2020�ڶ�ѧ��',90);
insert into sc(sno,cno,tno,shijian,grade)values('2017051267','34','2012131466','2019-2020�ڶ�ѧ��',88);
insert into sc(sno,cno,tno,shijian,grade)values('2017051223','45','2012131439','2019-2020�ڶ�ѧ��',92);
insert into sc(sno,cno,tno,shijian,grade)values('2017051289','67','2012131458','2019-2020�ڶ�ѧ��',67);
select * from sc;
--���ݱ���
alter tablespace test begin backup;
host copy I:\app\Administrator\oradata\orcl\test01.dbf
I:\app\Administrator\oradata\documents\test01.dbf
alter tablespace test end backup;
