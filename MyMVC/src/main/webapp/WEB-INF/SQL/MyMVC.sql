---- **** MyMVC 다이내믹웹프로젝트 에서 작업한 것 **** ----

-- 오라클 계정 생성을 위해서는 SYS 또는 SYSTEM 으로 연결하여 작업을 해야 합니다. [SYS 시작] --
show user;
-- USER이(가) "SYS"입니다.

-- 오라클 계정 생성시 계정명 앞에 c## 붙이지 않고 생성하도록 하겠습니다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

-- 오라클 계정명은 MYMVC_USER 이고 암호는 gclass 인 사용자 계정을 생성합니다.
create user MYMVC_USER identified by sistsix default tablespace users; 
-- User MYMVC_USER이(가) 생성되었습니다.

-- 위에서 생성되어진 MYMVC_USER 이라는 오라클 일반사용자 계정에게 오라클 서버에 접속이 되어지고,
-- 테이블 생성 등등을 할 수 있도록 여러가지 권한을 부여해주겠습니다.
grant connect, resource, create view, unlimited tablespace to MYMVC_USER;
-- Grant을(를) 성공했습니다.

-----------------------------------------------------------------------

show user;
-- USER이(가) "MYMVC_USER"입니다.



create table tbl_main_page
(imgno        number  not null
,imgname      Nvarchar2(20) not null
,imgfilename  Nvarchar2(30) not null
,constraint   PK_tbl_main_page_imgno primary key(imgno)
);
-- Table TBL_MAIN_PAGE이(가) 생성되었습니다.

create sequence seq_main_image
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_MAIN_IMAGE이(가) 생성되었습니다.

insert into tbl_main_page(imgno, imgname, imgfilename) values(seq_main_image.nextval, '미샤', '미샤.png');
insert into tbl_main_page(imgno, imgname, imgfilename) values(seq_main_image.nextval, '원더플레이스', '원더플레이스.png');
insert into tbl_main_page(imgno, imgname, imgfilename) values(seq_main_image.nextval, '레노보', '레노보.png');
insert into tbl_main_page(imgno, imgname, imgfilename) values(seq_main_image.nextval, '동원', '동원.png');

commit;
-- 커밋 완료.

select imgno, imgname, imgfilename
from tbl_main_page
order by imgno asc;


show user;




-- ************* 회원 테이블 생성 *************
/*
    평문 => 암호화되지 않은 문장
    I am a boy
    
    암호화된 문장(encrypted text)
    평문 + 암호화키
    I am a boy + 1 ==> J bn cpz
    
    복호화된 문장(decrypted text) ==> 해독된 문장
    암호화된 문장(encrypted text) + 암호화키(key)
    J bn b cpz - 1 ==> I am a boy
    
    AES256 방식 ==> 양방향 암호화 (암호화 및 복호화 가능함) , 암호화키(key)가 반드시 필요함.
    SHA256 방식 ==> 단방향 암호화 (암호화만 되어지고 복호화가 불가능함), 암호화키(key)가 없음.
*/
create table tbl_member    
    (userid             varchar2(40)   not null  -- 회원아이디
    ,pwd                varchar2(200)  not null  -- 비밀번호 (SHA-256 암호화 대상)
    ,name               varchar2(30)   not null  -- 회원명
    ,email              varchar2(200)  not null  -- 이메일 (AES-256 암호화/복호화 대상)
    ,mobile             varchar2(200)            -- 연락처 (AES-256 암호화/복호화 대상) 
    ,postcode           varchar2(5)              -- 우편번호
    ,address            varchar2(200)            -- 주소
    ,detailaddress      varchar2(200)            -- 상세주소
    ,extraaddress       varchar2(200)            -- 참고항목
    ,gender             varchar2(1)              -- 성별   남자:1  / 여자:2
    ,birthday           varchar2(10)             -- 생년월일   
    ,coin               number default 0         -- 코인액
    ,point              number default 0         -- 포인트 
    ,registerday        date default sysdate     -- 가입일자 
    ,lastpwdchangedate  date default sysdate     -- 마지막으로 암호를 변경한 날짜  
    ,status             number(1) default 1 not null     -- 회원탈퇴유무   1: 사용가능(가입중) / 0:사용불능(탈퇴) 
    ,idle               number(1) default 0 not null     -- 휴면유무      0 : 활동중  /  1 : 휴면중 
    ,constraint PK_tbl_member_userid primary key(userid)
    ,constraint UQ_tbl_member_email  unique(email)
    ,constraint CK_tbl_member_gender check( gender in('1','2') )
    ,constraint CK_tbl_member_status check( status in(0,1) )
    ,constraint CK_tbl_member_idle check( idle in(0,1) )
);
-- Table TBL_MEMBER이(가) 생성되었습니다.

select *
from tbl_member
order by registerday desc;


----- 로그인 처리를 위한 SQL 문 작성 -----
update tbl_member set registerday = sysdate
                     ,lastpwdchangedate = sysdate
where userid IN('kangkc','leess');

update tbl_member set registerday = add_months(registerday, -14)
                     ,lastpwdchangedate = add_months(lastpwdchangedate, -14)
where userid = 'kangkc';

update tbl_member set registerday = add_months(registerday, -5)
                     ,lastpwdchangedate = add_months(lastpwdchangedate, -4)
where userid = 'leess';

commit;






--------------------- 로그인 테이블 생성 ---------------------
create table tbl_loginhistory
(historyno   number
,fk_userid   varchar2(40) not null  -- 회원아이디
,logindate   date default sysdate not null -- 로그인되어진 접속날짜및시간
,clientip    varchar2(20) not null
,constraint  PK_tbl_loginhistory primary key(historyno)
,constraint  FK_tbl_loginhistory_fk_userid foreign key(fk_userid) references tbl_member(userid)
);
-- Table TBL_LOGINHISTORY이(가) 생성되었습니다.

create sequence seq_historyno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_HISTORYNO이(가) 생성되었습니다.



update tbl_member set point = '500000'
where userid = 'solee7966';
update tbl_member set coin = '15000'
where userid = 'solee7966';

update tbl_loginhistory set logindate = add_months(logindate, -13)
where fk_userid = 'leess';

update tbl_loginhistory set logindate = add_months(logindate, -5)
where fk_userid = 'kangkc';

update tbl_member set lastpwdchangedate = add_months(lastpwdchangedate, -5)
where userid = 'kangkc';


delete tbl_member
where userid = 'kangkc';


commit;
------- 등록된 회원 모두 출력 --------
select *
from tbl_member
order by registerday desc;

------ 등록된 특정 회원 정보 출력하기 ------
SELECT userid, name, coin, point, 
    trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap, -- 현재일과 최종로그인 일자 간격을 계산한 결과
    to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as registerday, idle, email, mobile, postcode, address, detailaddress, extraaddress  
FROM tbl_member
WHERE status = 1 AND userid = 'leess' and pwd = '3aaa0573851cbdf0296a0c9bdc9a95992510176ca59fb083ddc41d9dde97c7d9';


----- 로그인 한 회원 정보 출력하기 -----
select HISTORYNO, FK_USERID, to_char(LOGINDATE, 'yyyy-mm-dd hh24:mi:ss') as LOGINDATE, CLIENTIP  
from tbl_loginhistory
order by historyno desc;


----- 가장 최근에 로그인 값을 출력하기 -----
select to_char(MAX(LOGINDATE), 'yyyy-mm-dd hh24:mi:ss') as LOGINDATE
FROM tbl_loginhistory
where fk_userid = 'leess';


----- 특정 회원의 정보와 마지막 로그인 일자, 현재일 간 간격을 조인하려 출력하기 -----
WITH
M AS (
 SELECT userid, name, coin, point, 
     trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap, -- 현재일과 최종로그인 일자 간격을 계산한 결과
     to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as registerday, idle, email, mobile, postcode, address, detailaddress, extraaddress  
 FROM tbl_member
 WHERE status = 1 AND userid = 'leess' and pwd = '3aaa0573851cbdf0296a0c9bdc9a95992510176ca59fb083ddc41d9dde97c7d9'
)
, H AS (
 select trunc( months_between(sysdate, MAX(LOGINDATE)) ) AS LAST_LOGINDATE_GAP
 FROM tbl_loginhistory
 where fk_userid = 'leess'
)
SELECT userid, name, coin, point, pwdchangegap, registerday, idle, email, mobile
      ,postcode, address, detailaddress, extraaddress, LAST_LOGINDATE_GAP
FROM M CROSS JOIN H;



-------- 내 회원정보와 로그인일자 간격 출력하기 --------
WITH
M AS (
 SELECT userid, name, coin, point, 
     trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap, -- 현재일과 최종로그인 일자 간격을 계산한 결과
     to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as registerday, idle, email, mobile, postcode, address, detailaddress, extraaddress  
 FROM tbl_member
 WHERE status = 1 AND userid = 'solee7966' and pwd = '18006e2ca1c2129392c66d87334bd2452c572058d406b4e85f43c1f72def10f5'
)
, H AS (
 select trunc( months_between(sysdate, MAX(LOGINDATE)) ) AS LAST_LOGINDATE_GAP
 FROM tbl_loginhistory
 where fk_userid = 'solee7966'
)
SELECT userid, name, coin, point, pwdchangegap, registerday, idle, email, mobile
      ,postcode, address, detailaddress, extraaddress, LAST_LOGINDATE_GAP
FROM M CROSS JOIN H;


select USERID ,
PWD ,
NAME ,
EMAIL ,
MOBILE ,
POSTCODE ,
ADDRESS ,
DETAILADDRESS ,
EXTRAADDRESS ,
GENDER ,
BIRTHDAY ,
COIN ,
POINT ,
REGISTERDAY ,
to_char(LASTPWDCHANGEDATE, 'yyyy-mm-dd hh24:mi:ss') as LASTPWDCHANGEDATE,
STATUS ,
IDLE 
from tbl_member
where status = 1 AND name = '안태훈' AND email = 'NfWfPBsdzU526rVqt4drQ21aPAaUkHN9eUaN0Wr33oc=';


select email
from tbl_member
where email = 'NfWfPBsdzU526rVqt4drQ21aPAaUkHN9eUaN0Wr33oc=' and userid = 'solee7966';

select userid
from tbl_member
where status = 1 AND name = '안태훈' AND email = 'NfWfPBsdzU526rVqt4drQ21aPAaUkHN9eUaN0Wr33oc=';

select *
from tbl_member;

delete tbl_member
where userid = 'admin';


commit;



-- 오라클에서 프로시저를 사용하여 회원을 대량으로 입력(insert)하겠습니다. --
select * 
from user_constraints
where table_name = 'TBL_MEMBER';

-- 이메일을 대량으로 넣기 위해서 어쩔수 없이 email 에 대한 unique 제약을 없애도록 한다.
alter table tbl_member
drop constraint UQ_TBL_MEMBER_EMAIL;
-- Table TBL_MEMBER이(가) 변경되었습니다.

select * 
from user_constraints
where table_name = 'TBL_MEMBER';

select *
from tbl_member
order by registerday desc;

--------------------------------------------


create or replace procedure pcd_member_insert
(p_userid   IN  varchar2
,p_name     IN  varchar2
,p_gender   IN  char)
is
begin
   for i in 1..100 loop --1부터 100까지의 총 100개를 만들겠다.
      insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) 
      values(p_userid||i, '18006e2ca1c2129392c66d87334bd2452c572058d406b4e85f43c1f72def10f5', p_name||i, 'NfWfPBsdzU526rVqt4drQ21aPAaUkHN9eUaN0Wr33oc=', '/zqBhbHQWDhBuJe/fduAHA==', 
            '15864', '경기 군포시 오금로 15-17', '101동 102호', ' (금정동)', p_gender, '1993-10-11'); 
   end loop;
end pcd_member_insert; 
/

-- Procedure PCD_MEMBER_INSERT이(가) 컴파일되었습니다.
exec pcd_member_insert('iyou', '아이유', 2);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
commit;


exec pcd_member_insert('kangsora', '강소라', 2);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
commit;

exec pcd_member_insert('choiws', '최우식', 1);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.
commit;


insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) 
values('kimyousin', '18006e2ca1c2129392c66d87334bd2452c572058d406b4e85f43c1f72def10f5', '김유신', 'NfWfPBsdzU526rVqt4drQ21aPAaUkHN9eUaN0Wr33oc=', '0vXon9k7kbCGeP9/MfAzrQ==', 
        '15864', '경기 군포시 오금로 15-17', '101동 102호', ' (금정동)', 1, '1984-10-11'); 

insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) 
values('youinna', '18006e2ca1c2129392c66d87334bd2452c572058d406b4e85f43c1f72def10f5', '유인나', 'NfWfPBsdzU526rVqt4drQ21aPAaUkHN9eUaN0Wr33oc=', '0vXon9k7kbCGeP9/MfAzrQ==', 
        '15864', '경기 군포시 오금로 15-17', '101동 102호', ' (금정동)', 2, '2001-10-11'); 

commit;

select *
from tbl_member
order by userid asc;

select count(*)
from tbl_member
where userid != 'admin'
order by userid asc;
-- 207

select count(*)
from tbl_member
order by userid asc;
-- 208

select userid, name, email, gender
from tbl_member
where userid != 'admin'
and name like '%'||'유'||'%'
order by registerday desc;

select * from tbl_member;

select *
from tbl_member
where userid != 'admin'
and email = 'solee7966@naver.com'
order by registerday desc;


commit;




---- **** ORACLE 12C 이후부터 지원되는 OFFSET - FETCH 를 사용하여 페이징 처리하기 ----
/*
        >> !!문법!! <<
    ORDER BY boardno desc
    OFFSET (@PAGE_NO-1)*@PAGE_SIZE ROW   -- @PAGE_NO ==> 페이지 번호 , @PAGE_SIZE ==> 한 페이지에 보여줄 row 수
    FETCH NEXT @PAGE_SIZE ROW ONLY
    
    order by 로 정렬 기준 정하고
    offset을 통해 페이징 할 때마다 건너뛸 행의 수 설정
    fetch next에서 몇 개의 행을 가져올지 결정
*/
--1 페이지--
select userid, name, email, gender
from tbl_member
where userid != 'admin'
and name like '%'||'강'||'%'
--and userid like '%'||'3'||'%'
--and email = 'solee7966@naver.com'
order by registerday desc
offset (1-1)*10 row
fetch next 10 row only;

--2 페이지--
select userid, name, email, gender
from tbl_member
where userid != 'admin'
and name like '%'||'강'||'%'
--and userid like '%'||'3'||'%'
--and email = 'solee7966@naver.com'
order by registerday desc
offset (2-1)*10 row
fetch next 10 row only;

--3 페이지--
select userid, name, email, gender
from tbl_member
where userid != 'admin'
and name like '%'||'강'||'%'
--and userid like '%'||'3'||'%'
--and email = 'solee7966@naver.com'
order by registerday desc
offset (3-1)*10 row
fetch next 10 row only;


-- <<< 1페이지 >>>
select boardno, subject, userid, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as REGISTER_DAY
from tbl_member
order by boardno desc
OFFSET (1-1)*3 ROW
FETCH NEXT 3 ROW ONLY;

-- <<< 2페이지 >>>
select boardno, subject, userid, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as REGISTER_DAY
from tbl_board
order by boardno desc
OFFSET (2-1)*3 ROW
FETCH NEXT 3 ROW ONLY;

-- <<< 3페이지 >>>
select boardno, subject, userid, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as REGISTER_DAY
from tbl_board
order by boardno desc
OFFSET (3-1)*3 ROW
FETCH NEXT 3 ROW ONLY;

-- <<< 4페이지 >>>
select boardno, subject, userid, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as REGISTER_DAY
from tbl_board
order by boardno desc
OFFSET (4-1)*3 ROW
FETCH NEXT 3 ROW ONLY;

-- <<< 5페이지 >>>
select boardno, subject, userid, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as REGISTER_DAY
from tbl_board
order by boardno desc
OFFSET (5-1)*3 ROW
FETCH NEXT 3 ROW ONLY;

-- <<< 6페이지 >>>
select boardno, subject, userid, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as REGISTER_DAY
from tbl_board
order by boardno desc
OFFSET (6-1)*3 ROW
FETCH NEXT 3 ROW ONLY;


select *
from tbl_member
where status = 1 and name like '%'||'강'||'%'
order by userseq desc;

delete from tbl_member
where name = '강소라56';

delete from tbl_member
where userid = 'kangsora54';

commit;