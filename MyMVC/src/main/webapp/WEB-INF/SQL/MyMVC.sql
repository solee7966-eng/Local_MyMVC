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



show user;







--------------------------------------------------------------------------



/*
   카테고리 테이블명 : tbl_category 

   컬럼정의 
     -- 카테고리 대분류 번호  : 시퀀스(seq_category_cnum)로 증가함.(Primary Key)
     -- 카테고리 코드(unique) : ex) 전자제품  '100000'
                                  의류  '200000'
                                  도서  '300000' 
     -- 카테고리명(not null)  : 전자제품, 의류, 도서           
  
*/ 
-- drop table tbl_category purge; 
create table tbl_category
(cnum    number(8)     not null  -- 카테고리 대분류 번호
,code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_tbl_category_cnum primary key(cnum)
,constraint UQ_tbl_category_code unique(code)
);

-- drop sequence seq_category_cnum;
create sequence seq_category_cnum 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '100000', '전자제품');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '200000', '의류');
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '300000', '도서');
commit;

-- 나중에 넣습니다.
insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '400000', '식품');
commit;

insert into tbl_category(cnum, code, cname) values(seq_category_cnum.nextval, '500000', '신발');
commit;


delete from tbl_category
where code = '500000';
commit;

delete from tbl_category
where code = '400000';
commit;


select cnum, code, cname
from tbl_category
order by cnum asc;



-- drop table tbl_spec purge;
create table tbl_spec
(snum    number(8)     not null  -- 스펙번호       
,sname   varchar2(100) not null  -- 스펙명         
,constraint PK_tbl_spec_snum primary key(snum)
,constraint UQ_tbl_spec_sname unique(sname)
);

-- drop sequence seq_spec_snum;
create sequence seq_spec_snum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'HIT');
insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'NEW');
insert into tbl_spec(snum, sname) values(seq_spec_snum.nextval, 'BEST');

commit;

select snum, sname
from tbl_spec
order by snum asc;


---- *** 제품 테이블 : tbl_product *** ----
-- drop table tbl_product purge; 
create table tbl_product
(pnum           number(8) not null       -- 제품번호(Primary Key)
,pname          varchar2(100) not null   -- 제품명
,fk_cnum        number(8)                -- 카테고리코드(Foreign Key)의 시퀀스번호 참조
,pcompany       varchar2(50)             -- 제조회사명
,pimage1        varchar2(100) default 'noimage.png' -- 제품이미지1   이미지파일명
,pimage2        varchar2(100) default 'noimage.png' -- 제품이미지2   이미지파일명 
,prdmanual_systemFileName varchar2(200)             -- 파일서버에 업로드되어지는 실제 제품설명서 파일명 (중복된 파일명을 방지하기위해 파일명뒤에 날짜시간나노초를 붙여서 만든다) 
,prdmanual_orginFileName  varchar2(200)             -- 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명 
,pqty           number(8) default 0      -- 제품 재고량
,price          number(8) default 0      -- 제품 정가
,saleprice      number(8) default 0      -- 제품 판매가(할인해서 팔 것이므로)
,fk_snum        number(8)                -- 'HIT', 'NEW', 'BEST' 에 대한 스펙번호인 시퀀스번호를 참조
,pcontent       varchar2(4000)           -- 제품설명  varchar2는 varchar2(4000) 최대값이므로
                                         --          4000 byte 를 초과하는 경우 clob 를 사용한다.
                                         --          clob 는 최대 4GB 까지 지원한다.
                                         
,point          number(8) default 0      -- 포인트 점수                                         
,pinputdate     date default sysdate     -- 제품입고일자
,constraint  PK_tbl_product_pnum primary key(pnum)
,constraint  FK_tbl_product_fk_cnum foreign key(fk_cnum) references tbl_category(cnum)
,constraint  FK_tbl_product_fk_snum foreign key(fk_snum) references tbl_spec(snum)
);

-- drop sequence seq_tbl_product_pnum;
create sequence seq_tbl_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;



delete from tbl_product;
rollback;


-- 아래는 fk_snum 컬럼의 값이 1 인 'HIT' 상품만 입력한 것임. 
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '스마트TV', 1, '삼성', 'tv_samsung_h450_1.png','tv_samsung_h450_2.png', 100,1200000,800000, 1,'42인치 스마트 TV. 기능 짱!!', 50);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북', 1, '엘지', 'notebook_lg_gt50k_1.png','notebook_lg_gt50k_2.png', 150,900000,750000, 1,'노트북. 기능 짱!!', 30);  

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '바지', 2, 'S사', 'cloth_canmart_1.png','cloth_canmart_2.png', 20,12000,10000, 1,'예뻐요!!', 5);       

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '남방', 2, '버카루', 'cloth_buckaroo_1.png','cloth_buckaroo_2.png', 50,15000,13000, 1,'멋져요!!', 10);       
       
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '보물찾기시리즈', 3, '아이세움', 'book_bomul_1.png','book_bomul_2.png', 100,35000,33000, 1,'만화로 보는 세계여행', 20);       
       
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '만화한국사', 3, '녹색지팡이', 'book_koreahistory_1.png','book_koreahistory_2.png', 80,130000,120000, 1,'만화로 보는 이야기 한국사 전집', 60);
       
commit;




----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 아래는 fk_cnum 컬럼의 값이 1 인 '전자제품' 중 fk_snum 컬럼의 값이 1 인 'HIT' 상품만 입력한 것임. 
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북1', 1, 'DELL', '1.jpg','2.jpg', 100,1200000,1000000,1,'1번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북2', 1, '에이서','3.jpg','4.jpg',100,1200000,1000000,1,'2번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북3', 1, 'LG전자','5.jpg','6.jpg',100,1200000,1000000,1,'3번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북4', 1, '레노버','7.jpg','8.jpg',100,1200000,1000000,1,'4번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북5', 1, '삼성전자','9.jpg','10.jpg',100,1200000,1000000,1,'5번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북6', 1, 'HP','11.jpg','12.jpg',100,1200000,1000000,1,'6번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북7', 1, '레노버','13.jpg','14.jpg',100,1200000,1000000,1,'7번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북8', 1, 'LG전자','15.jpg','16.jpg',100,1200000,1000000,1,'8번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북9', 1, '한성컴퓨터','17.jpg','18.jpg',100,1200000,1000000,1,'9번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북10', 1, 'MSI','19.jpg','20.jpg',100,1200000,1000000,1,'10번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북11', 1, 'LG전자','21.jpg','22.jpg',100,1200000,1000000,1,'11번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북12', 1, 'HP','23.jpg','24.jpg',100,1200000,1000000,1,'12번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북13', 1, '레노버','25.jpg','26.jpg',100,1200000,1000000,1,'13번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북14', 1, '레노버','27.jpg','28.jpg',100,1200000,1000000,1,'14번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북15', 1, '한성컴퓨터','29.jpg','30.jpg',100,1200000,1000000,1,'15번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북16', 1, '한성컴퓨터','31.jpg','32.jpg',100,1200000,1000000,1,'16번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북17', 1, '레노버','33.jpg','34.jpg',100,1200000,1000000,1,'17번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북18', 1, '레노버','35.jpg','36.jpg',100,1200000,1000000,1,'18번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북19', 1, 'LG전자','37.jpg','38.jpg',100,1200000,1000000,1,'19번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북20', 1, 'LG전자','39.jpg','40.jpg',100,1200000,1000000,1,'20번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북21', 1, '한성컴퓨터','41.jpg','42.jpg',100,1200000,1000000,1,'21번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북22', 1, '에이서','43.jpg','44.jpg',100,1200000,1000000,1,'22번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북23', 1, 'DELL','45.jpg','46.jpg',100,1200000,1000000,1,'23번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북24', 1, '한성컴퓨터','47.jpg','48.jpg',100,1200000,1000000,1,'24번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북25', 1, '삼성전자','49.jpg','50.jpg',100,1200000,1000000,1,'25번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북26', 1, 'MSI','51.jpg','52.jpg',100,1200000,1000000,1,'26번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북27', 1, '애플','53.jpg','54.jpg',100,1200000,1000000,1,'27번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북28', 1, '아수스','55.jpg','56.jpg',100,1200000,1000000,1,'28번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북29', 1, '레노버','57.jpg','58.jpg',100,1200000,1000000,1,'29번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북30', 1, '삼성전자','59.jpg','60.jpg',100,1200000,1000000,1,'30번 노트북', 60);

commit;

-- 아래는 fk_cnum 컬럼의 값이 1 인 '전자제품' 중 fk_snum 컬럼의 값이 2 인 'NEW' 상품만 입력한 것임. 
insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북31', 1, 'MSI','61.jpg','62.jpg',100,1200000,1000000,2,'31번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북32', 1, '삼성전자','63.jpg','64.jpg',100,1200000,1000000,2,'32번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북33', 1, '한성컴퓨터','65.jpg','66.jpg',100,1200000,1000000,2,'33번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북34', 1, 'HP','67.jpg','68.jpg',100,1200000,1000000,2,'34번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북35', 1, 'LG전자','69.jpg','70.jpg',100,1200000,1000000,2,'35번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북36', 1, '한성컴퓨터','71.jpg','72.jpg',100,1200000,1000000,2,'36번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북37', 1, '삼성전자','73.jpg','74.jpg',100,1200000,1000000,2,'37번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북38', 1, '레노버','75.jpg','76.jpg',100,1200000,1000000,2,'38번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북39', 1, 'MSI','77.jpg','78.jpg',100,1200000,1000000,2,'39번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북40', 1, '레노버','79.jpg','80.jpg',100,1200000,1000000,2,'40번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북41', 1, '레노버','81.jpg','82.jpg',100,1200000,1000000,2,'41번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북42', 1, '레노버','83.jpg','84.jpg',100,1200000,1000000,2,'42번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북43', 1, 'MSI','85.jpg','86.jpg',100,1200000,1000000,2,'43번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북44', 1, '한성컴퓨터','87.jpg','88.jpg',100,1200000,1000000,2,'44번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북45', 1, '애플','89.jpg','90.jpg',100,1200000,1000000,2,'45번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북46', 1, '아수스','91.jpg','92.jpg',100,1200000,1000000,2,'46번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북47', 1, '삼성전자','93.jpg','94.jpg',100,1200000,1000000,2,'47번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북48', 1, 'LG전자','95.jpg','96.jpg',100,1200000,1000000,2,'48번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북49', 1, '한성컴퓨터','97.jpg','98.jpg',100,1200000,1000000,2,'49번 노트북', 60);

insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, pqty, price, saleprice, fk_snum, pcontent, point)
values(seq_tbl_product_pnum.nextval, '노트북50', 1, '레노버','99.jpg','100.jpg',100,1200000,1000000,2,'50번 노트북', 60);

commit;        

select *
from tbl_product
order by pnum desc;



select count(*)
from tbl_product
where fk_snum = '1'; -- HIT (36)

select count(*)
from tbl_product
where fk_snum = '2'; -- NEW (20)

select count(*)
from tbl_product
where fk_snum = '3'; -- BEST (0)

select *
from tbl_product;

select cnum, code, cname
from tbl_category;


select snum, sname
from tbl_spec;






--- *** 더보기 방식(페이징처리)으로 상품정보를 8개씩 잘라서(start ~ end) 조회해오기 *** ---
---     Oracle 12c 이상에서 사용되는 OFFSET FETCH 를 사용하여 구하기 
/* >> !! ORACLE 12C 이후 부터 지원되어지는 OFFSET - FETCH 을 사용하여 페이징 처리 !! <<
           
   ORDER BY pnum DESC 
   OFFSET (@PAGE_NO-1)*@PAGE_SIZE ROW   -- @PAGE_NO ==> 페이지 번호 , @PAGE_SIZE ==> 한 페이지에 보여줄 row 수
   FETCH NEXT @PAGE_SIZE ROW ONLY

   order by 로 정렬 기준 정하고
   offset을 통해 페이징 할 때마다 건너뛸 행의 수 설정
   fetch next에서 몇 개의 행을 가져올지 결정
*/ 
SELECT pnum, pname, C.cname, pcompany, pimage1, pimage2, pqty, price, saleprice, S.sname, pcontent, point 
     , to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate
FROM tbl_product P JOIN tbl_category C 
ON P.fk_cnum = C.cnum
JOIN tbl_spec S 
ON P.fk_snum = S.snum
WHERE S.sname = 'HIT'
ORDER BY pnum DESC
OFFSET 8/(8 - 1 + 1)*(8 - 1 + 1) ROW
FETCH NEXT (8 - 1 + 1) ROW ONLY; -- 첫 번째 더보기(1페이지) ==> 1부터 8까지
/*
    @PAGE_NO = end/(end - start + 1)
    @PAGE_SIZE = end - start + 1
    
    @PAGE_NO = 8/(8 - 1 + 1)
    @PAGE_SIZE = (8 - 1 + 1)
*/


SELECT pnum, pname, C.cname, pcompany, pimage1, pimage2, pqty, price, saleprice, S.sname, pcontent, point 
     , to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate
FROM tbl_product P JOIN tbl_category C 
ON P.fk_cnum = C.cnum
JOIN tbl_spec S 
ON P.fk_snum = S.snum
WHERE S.sname = 'HIT'
ORDER BY pnum DESC
OFFSET 16/(16 - 9 + 1)*(16 - 9 + 1) ROW
FETCH NEXT (16 - 9 + 1) ROW ONLY; -- 두 번째 더보기(2페이지) ==> 9부터 16까지
/*
    @PAGE_NO = end/(end - start + 1)
    @PAGE_SIZE = end - start + 1
    
    @PAGE_NO = 16/(16 - 9 + 1)
    @PAGE_SIZE = (16 - 9 + 1)
*/


SELECT pnum, pname, C.cname, pcompany, pimage1, pimage2, pqty, price, saleprice, S.sname, pcontent, point 
     , to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate
FROM tbl_product P JOIN tbl_category C 
ON P.fk_cnum = C.cnum
JOIN tbl_spec S 
ON P.fk_snum = S.snum
WHERE S.sname = 'HIT'
ORDER BY pnum DESC
OFFSET 24/(24 - 17 + 1)*(24 - 17 + 1) ROW
FETCH NEXT (24 - 17 + 1) ROW ONLY; -- 세 번째 더보기(3페이지) ==> 17부터 24까지
/*
    @PAGE_NO = end/(end - start + 1)
    @PAGE_SIZE = end - start + 1
    
    @PAGE_NO = 24/(24 - 17 + 1)
    @PAGE_SIZE = (24 - 17 + 1)
*/


-- HIT 상품의 전체 개수를 알아오기
SELECT count(*)
FROM tbl_product
WHERE fk_snum = 1;



SELECT snum, sname
FROM tbl_spec;

select * from tbl_product;




----- >>> 하나의 제품속에 여러개의 이미지 파일 넣어주기 <<< ------ 
create table tbl_product_imagefile
(imgfileno     number         not null   -- 시퀀스로 입력받음.
,fk_pnum       number(8)      not null   -- 제품번호(foreign key)
,imgfilename   varchar2(100)  not null   -- 제품이미지파일명
,constraint PK_tbl_product_imagefile primary key(imgfileno)
,constraint FK_tbl_product_imagefile foreign key(fk_pnum) references tbl_product(pnum) on delete cascade 
);
-- Table TBL_PRODUCT_IMAGEFILE이(가) 생성되었습니다.

create sequence seqImgfileno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQIMGFILENO이(가) 생성되었습니다.

select imgfileno, fk_pnum, imgfilename
from tbl_product_imagefile
order by imgfileno desc;

select * from tbl_product
order by pnum desc;




SELECT sname, pnum, pname, pcompany, price, saleprice, point, pqty, 
       pcontent, pimage1, pimage2, prdmanual_systemFileName, 
       NVL(prdmanual_orginFileName, '없음') AS prdmanual_orginFileName
FROM
(
select fk_snum, pnum, pname, pcompany, price, saleprice, point, pqty, 
       pcontent, pimage1, pimage2, prdmanual_systemFileName, prdmanual_orginFileName
from tbl_product
where pnum = to_number('119')
) P
JOIN tbl_spec S
ON P.fk_snum = S.snum;


SELECT imgfileno
FROM tbl_product_imagefile
WHERE fk_pnum = '119'
ORDER BY imgfileno desc;





select PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME
from tbl_product
where pnum = 119; --결과 있음

select PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME
from tbl_product
where pnum = 32; --결과 없음






-------- **** 장바구니 테이블 생성하기 **** ----------
 desc tbl_member;
 desc tbl_product;

 create table tbl_cart
 (cartno        number               not null   --  장바구니 번호             
 ,fk_userid     varchar2(20)         not null   --  사용자ID            
 ,fk_pnum       number(8)            not null   --  제품번호                
 ,oqty          number(8) default 0  not null   --  주문량                   
 ,registerday   date default sysdate            --  장바구니 입력날짜
 ,constraint PK_shopping_cart_cartno primary key(cartno)
 ,constraint FK_shopping_cart_fk_userid foreign key(fk_userid) references tbl_member(userid) 
 ,constraint FK_shopping_cart_fk_pnum foreign key(fk_pnum) references tbl_product(pnum)
 );
 -- Table TBL_CART이(가) 생성되었습니다.

 create sequence seq_tbl_cart_cartno
 start with 1
 increment by 1
 nomaxvalue
 nominvalue
 nocycle
 nocache;
 
 select * from tbl_member
 where userid = 'iyou';
 
 select cartno, fk_userid, fk_pnum, oqty, registerday 
 from tbl_cart
 order by cartno asc;
 
 
SELECT C.cartno, C.fk_userid, C.fk_pnum, C.oqty, P.pname, P.pimage1, P.saleprice, P.point, P.pqty 
FROM (
    select cartno, fk_userid, fk_pnum, oqty, registerday 
    from tbl_cart
    where fk_userid = 'solee7966') C
JOIN tbl_product P
ON C.fk_pnum = P.pnum 
ORDER BY C.cartno DESC;


SELECT NVL(SUM(C.oqty * P.saleprice), 0) AS SUMTOTALPRICE,
       NVL(SUM(C.oqty * P.point), 0) AS SUMTOTALPOINT
FROM (
    select fk_pnum, oqty
    from tbl_cart
    where fk_userid = 'iyou1') C
JOIN tbl_product P
ON C.fk_pnum = P.pnum;



show user;
 ------------------ >>> 주문관련 테이블 <<< -----------------------------
-- [1] 주문 테이블    : tbl_order
-- [2] 주문상세 테이블 : tbl_orderdetail


-- *** "주문" 테이블 *** --
create table tbl_order
(odrcode        varchar2(20) not null          -- 주문코드(명세서번호)  주문코드 형식 : s+날짜+sequence ==> s20260114-1 , s20260114-2 , s20260114-3
                                               --                                                  s20260115-4 , s20260115-5 , s20260115-6
,fk_userid      varchar2(20) not null          -- 사용자ID
,odrtotalPrice  number       not null          -- 주문총액
,odrtotalPoint  number       not null          -- 주문총포인트
,odrdate        date default sysdate not null  -- 주문일자
,constraint PK_tbl_order_odrcode primary key(odrcode)
,constraint FK_tbl_order_fk_userid foreign key(fk_userid) references tbl_member(userid)
);
-- Table TBL_ORDER이(가) 생성되었습니다.

-- "주문코드(명세서번호) 시퀀스" 생성
create sequence seq_tbl_order
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_ORDER이(가) 생성되었습니다.

select 's'||to_char(sysdate,'yyyymmdd')||'-'||seq_tbl_order.nextval AS odrcode
from dual;
-- s20250103-1 

select odrcode, fk_userid, 
       odrtotalPrice, odrtotalPoint,
       to_char(odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate
from tbl_order
order by odrcode desc;


-- *** "주문상세" 테이블 *** --
create table tbl_orderdetail
(odrseqnum      number               not null   -- 주문상세 일련번호
,fk_odrcode     varchar2(20)         not null   -- 주문코드(명세서번호)
,fk_pnum        number(8)            not null   -- 제품번호
,oqty           number               not null   -- 주문량
,odrprice       number               not null   -- "주문할 그때 그당시의 실제 판매가격" ==> insert 시 tbl_product 테이블에서 해당제품의 saleprice 컬럼값을 읽어다가 넣어주어야 한다.
,deliverStatus  number(1) default 1  not null   -- 배송상태( 1 : 주문만 받음,  2 : 배송중,  3 : 배송완료)
,deliverDate    date                            -- 배송완료일자  default 는 null 로 함.
,constraint PK_tbl_orderdetail_odrseqnum  primary key(odrseqnum)
,constraint FK_tbl_orderdetail_fk_odrcode foreign key(fk_odrcode) references tbl_order(odrcode) on delete cascade
,constraint FK_tbl_orderdetail_fk_pnum foreign key(fk_pnum) references tbl_product(pnum)
,constraint CK_tbl_orderdetail check( deliverStatus in(1, 2, 3) )
);
-- Table TBL_ORDERDETAIL이(가) 생성되었습니다.


-- "주문상세 일련번호 시퀀스" 생성
create sequence seq_tbl_orderdetail
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_ORDERDETAIL이(가) 생성되었습니다.

commit;
-----------------------------------------------------------------
select *
from tbl_order
order by odrdate desc; 
 
select *
from tbl_orderdetail
order by odrseqnum desc;

select * from tbl_member
where userid = 'solee7966';

update tbl_member set coin = coin + 2600000
where userid = 'solee7966';
commit;

select * from tbl_orderdetail;

select * from tbl_product;
select * from tbl_product_imagefile;


show user;

-------- **** 매장찾기(카카오지도) 테이블 생성하기 **** ----------
create table tbl_map 
(storeID       varchar2(20) not null   --  매장id
,storeName     varchar2(100) not null  --  매장명
,storeUrl      varchar2(200)            -- 매장 홈페이지(URL)주소
,storeImg      varchar2(200) not null   -- 매장소개 이미지파일명  
,storeAddress  varchar2(200) not null   -- 매장주소 및 매장전화번호
,lat           number not null          -- 위도
,lng           number not null          -- 경도 
,zindex        number not null          -- zindex 
,constraint PK_tbl_map primary key(storeID)
,constraint UQ_tbl_map_zindex unique(zindex)
);
-- Table TBL_MAP이(가) 생성되었습니다.

create sequence seq_tbl_map_zindex
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_MAP_ZINDEX이(가) 생성되었습니다.

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store1','롯데백화점 본점','https://place.map.kakao.com/7858517','lotte02.png','서울 중구 을지로 30 (T)02-771-2500',37.56511284953554,126.98187860455485,1);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store2','신세계백화점 본점','https://place.map.kakao.com/7969138','shinsegae.png','서울 중구 소공로 63 (T)1588-1234',37.56091181255155,126.98098265772731,2);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store3','미래에셋센터원빌딩','https://place.map.kakao.com/13057692','miraeeset.png','서울 중구 을지로5길 26 (T)02-6030-0100',37.567386065415086,126.98512381778167,3);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store4','현대백화점신촌점','https://place.map.kakao.com/21695719','hyundai01.png','서울 서대문구 신촌로 83 현대백화점신촌점 (T)02-3145-2233',37.556005,126.935699,4);

insert into tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
values('store5','쌍용강북교육센터','https://place.map.kakao.com/16530319','sist01.jpg','서울 마포구 월드컵북로 21 풍성빌딩 2~4층 (T)02-336-8546',37.556583,126.919557,5);

commit; 

select storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex
from tbl_map
order by zindex asc;

select * from tbl_product;
select * from tbl_product_imagefile;


select * from tbl_member
where userid = 'eomjh';

update tbl_member set coin = 500000, point = 30000
where userid = 'eomjh';
commit;


select *
from tbl_order
order by odrdate desc;
 
select *
from tbl_orderdetail
order by odrseqnum desc;


-- 나의 카테고리 별 주문통계 보기
WITH
O AS(
    SELECT odrcode
    FROM tbl_order --주문 테이블
    WHERE fk_userid = 'solee7966'
) ,
OD AS (
    SELECT fk_odrcode, fk_pnum, oqty, odrprice
    FROM tbl_orderdetail --주문상세 테이블
)
SELECT C.cname
      ,count(C.cname) AS cnt
      ,SUM(OD.oqty * OD.odrprice) AS SUMPAY
      ,ROUND(SUM(OD.oqty * OD.odrprice)/(SELECT SUM(OD.oqty * OD.odrprice)
                                         FROM O JOIN OD
                                         ON O.odrcode = OD.fk_odrcode) * 100 ,2) AS SUMPAY_PCT
FROM O JOIN OD
ON O.odrcode = OD.fk_odrcode
JOIN tbl_product P --상품 테이블
ON OD.fk_pnum = P.pnum
JOIN tbl_category C -- 카테고리 테이블
ON P.fk_cnum = C.cnum
GROUP BY C.cname
ORDER BY 3 DESC;


-- 나의 카테고리 별 월별 주문통계 보기 --
WITH 
O AS 
(SELECT odrcode, odrdate 
 FROM tbl_order 
 WHERE fk_userid = 'solee7966' and to_char(odrdate, 'yyyy') = to_char(sysdate, 'yyyy') 
 ) 
, 
OD AS 
(SELECT fk_odrcode, fk_pnum, oqty, odrprice 
 FROM tbl_orderdetail 
) 
SELECT C.cname 
    ,COUNT(C.cname) AS CNT 
    ,SUM(OD.oqty * OD.odrprice) AS SUMPAY 
    ,round( SUM(OD.oqty * OD.odrprice)/( SELECT SUM(OD.oqty * OD.odrprice) 
                                           FROM O JOIN OD 
                                           ON O.odrcode = OD.fk_odrcode)*100, 2) AS SUMPAY_PCT 
    ,SUM( decode( to_char(O.odrdate,'mm'), '01', OD.oqty * OD.odrprice, 0) ) AS M_01 
    ,SUM( decode( to_char(O.odrdate,'mm'), '02', OD.oqty * OD.odrprice, 0) ) AS M_02 
    ,SUM( decode( to_char(O.odrdate,'mm'), '03', OD.oqty * OD.odrprice, 0) ) AS M_03 
    ,SUM( decode( to_char(O.odrdate,'mm'), '04', OD.oqty * OD.odrprice, 0) ) AS M_04 
    ,SUM( decode( to_char(O.odrdate,'mm'), '05', OD.oqty * OD.odrprice, 0) ) AS M_05 
    ,SUM( decode( to_char(O.odrdate,'mm'), '06', OD.oqty * OD.odrprice, 0) ) AS M_06 
    ,SUM( decode( to_char(O.odrdate,'mm'), '07', OD.oqty * OD.odrprice, 0) ) AS M_07 
    ,SUM( decode( to_char(O.odrdate,'mm'), '08', OD.oqty * OD.odrprice, 0) ) AS M_08 
    ,SUM( decode( to_char(O.odrdate,'mm'), '09', OD.oqty * OD.odrprice, 0) ) AS M_09 
    ,SUM( decode( to_char(O.odrdate,'mm'), '10', OD.oqty * OD.odrprice, 0) ) AS M_10 
    ,SUM( decode( to_char(O.odrdate,'mm'), '11', OD.oqty * OD.odrprice, 0) ) AS M_11 
    ,SUM( decode( to_char(O.odrdate,'mm'), '12', OD.oqty * OD.odrprice, 0) ) AS M_12 
FROM O JOIN OD 
ON O.odrcode = OD.fk_odrcode 
JOIN tbl_product P 
ON OD.fk_pnum = P.pnum 
JOIN tbl_category C 
ON P.fk_cnum = C.cnum 
GROUP BY C.cname 
ORDER BY 3 desc;




----- *** 좋아요, 싫어요 (투표) 테이블 생성하기 *** ----- 
create table tbl_product_like
(fk_userid   varchar2(40) not null 
,fk_pnum     number(8) not null
,constraint  PK_tbl_product_like primary key(fk_userid,fk_pnum)
,constraint  FK_tbl_product_like_userid foreign key(fk_userid) references tbl_member(userid)
,constraint  FK_tbl_product_like_pnum foreign key(fk_pnum) references tbl_product(pnum) on delete cascade
);
-- Table TBL_PRODUCT_LIKE이(가) 생성되었습니다.

create table tbl_product_dislike
(fk_userid   varchar2(40) not null 
,fk_pnum     number(8) not null
,constraint  PK_tbl_product_dislike primary key(fk_userid,fk_pnum)
,constraint  FK_tbl_product_dislike_userid foreign key(fk_userid) references tbl_member(userid)
,constraint  FK_tbl_product_dislike_pnum foreign key(fk_pnum) references tbl_product(pnum) on delete cascade
);
-- Table TBL_PRODUCT_DISLIKE이(가) 생성되었습니다.
----------------------------------------------------------------------------------------------

select D.odrseqnum, D.fk_pnum
from tbl_orderdetail D JOIN tbl_order O
on D.fk_odrcode = O.odrcode
where D.fk_pnum = to_number('119') and O.fk_userid = 'solee7966';



select * 
from tbl_product_like;

select *
from tbl_product_dislike;


SELECT (
    SELECT count(*)
    FROM tbl_product_like
    WHERE fk_pnum = 119) AS likeCNT,
    (
    SELECT count(*)
    FROM tbl_product_dislike
    WHERE fk_pnum = 119) AS dislikeCNT
FROM dual;


select * from tbl_product_imagefile;



-------- **** 상품구매 후기 테이블 생성하기 **** ----------
create table tbl_purchase_reviews
(review_seq          number 
,fk_userid           varchar2(20)   not null   -- 사용자ID       
,fk_pnum             number(8)      not null   -- 제품번호(foreign key)
,contents            varchar2(4000) not null
,writeDate           date default sysdate
,constraint PK_purchase_reviews primary key(review_seq)
,constraint UQ_purchase_reviews unique(fk_userid, fk_pnum)
,constraint FK_purchase_reviews_userid foreign key(fk_userid) references tbl_member(userid) on delete cascade 
,constraint FK_purchase_reviews_pnum foreign key(fk_pnum) references tbl_product(pnum) on delete cascade
);
-- 로그인하여 실제 해당 제품을 구매했을 때만 딱 1번만 작성할 수 있는 것. 제품후기를 삭제했을 경우에는 다시 작성할 수 있는 것임. 


create sequence seq_purchase_reviews
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_PURCHASE_REVIEWS이(가) 생성되었습니다.

select *
from tbl_purchase_reviews
order by review_seq desc;