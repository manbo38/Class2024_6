-- 댓글 게시판
select * from tab;
select * from seq;
select * from reboard;

create table reboard( num number primary key,
writer varchar2(20) not null,
email varchar2(30),
subject varchar2(50) not null,
passwd varchar2(20) not null,
reg_date timestamp not null,
readcount number default 0,
ref number not null,
re_step number not null,
re_level number not null,
content varchar2(2000) not null,
ip varchar2(20) not null );

create sequence reboard_seq
start with 1
increment by 1
nocache;