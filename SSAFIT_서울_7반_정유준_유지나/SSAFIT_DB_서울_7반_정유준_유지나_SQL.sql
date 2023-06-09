-- 데이터베이스 SSAFIT 생성
drop database IF EXISTS ssafit;
create database ssafit;
-- 데이터베이스 사용 설정
use ssafit;

-- vIDEO 테이블 생성
create table if not exists `video` (
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(100) NOT NULL,
    `fitPart` VARCHAR(45) NOT NULL,
    `channelName` VARCHAR(45) NOT NULL,
    `url` VARCHAR(2048) NOT NULL,
    `viewCnt` INT DEFAULT 0,
    `regDate` TIMESTAMP DEFAULT now() --  데이터가 추가 되는 시점
);

-- 사용자 테이블 생성 
CREATE TABLE IF NOT EXISTS `user` (
	`num` INT AUTO_INCREMENT PRIMARY KEY,
    `id` VARCHAR(20) NOT NULL,
    `pw` VARCHAR(20) NOT NULL,
    `name` VARCHAR(45) NOT NULL,
    `email` VARCHAR(20) NOT NULL,
    `follower_cnt` INT DEFAULT 0,
    `following_cnt` INT DEFAULT 0
);
-- 리뷰 테이블 생성
CREATE TABLE IF NOT EXISTS `review` (
	`review_num` INT AUTO_INCREMENT PRIMARY KEY,
    `video_id` int not null,
    `user_num` int not null,
    -- VIDEO 테이블의 ID 외래키, USER 테이블의 사용자번호(NUM) 참조,  연쇄 삭제 설정
	FOREIGN KEY(video_id) REFERENCES VIDEO(id) ON DELETE CASCADE,
    FOREIGN KEY(user_num) REFERENCES USER(num) ON DELETE CASCADE,
    comment TEXT NOT NULL
);
-- 찜 정보를 저장할 테이블 생성
CREATE TABLE IF NOT EXISTS `jim` (
	`video_id` int not null,
    `user_num` int not null,
    -- VIDEO 테이블의 ID 외래키, USER 테이블의 사용자번호(NUM) 참조,  연쇄 삭제 설정
	FOREIGN KEY(video_id) REFERENCES VIDEO(id) ON DELETE CASCADE,
    FOREIGN KEY(user_num) REFERENCES USER(num) ON DELETE CASCADE
);
-- 팔로워 정보를 저장할 테이블 생성
CREATE TABLE IF NOT EXISTS `following` (
	`my_num` int not null,
    `following_num` int not null,
    -- VIDEO 테이블의 ID 외래키, USER 테이블의 사용자번호(NUM) 참조,  연쇄 삭제 설정
	FOREIGN KEY(my_num) REFERENCES USER(num) ON DELETE CASCADE,
    FOREIGN KEY(following_num) REFERENCES USER(num) ON DELETE CASCADE
);
    
-- 비디오 등록
INSERT INTO video(id, title, fitpart, channelName, url, viewCnt, regDate)
VALUES	(0, "하체 근육 강화 15분운동", "하체", "궁둥이","https://www.youtube.com/watch?v=afqeynamUD4", 123, "2022-03-14 13:34:43" ),
		(0, "복근 만들기", "상체", "복복이","https://www.youtube.com/watch?v=En6Fq9jsQgs", 324, "2021-07-24 21:28:14" ),
		(0, "어깨 넓어지는 하루 5분 운동", "상체", "갑바","https://www.youtube.com/watch?v=5r5lbLY_mbs", 456, "2023-02-28 22:43:52" );
        
-- 유저 등록
INSERT INTO user(num, id, pw, name, email, follower_cnt, following_cnt) VALUES
(0, "jina", "jina123", "jina", "jina@naver.com", 100, 3),
(0, "yoojun", "yoojun123", "yoojun", "yoojun@naver.com", 1010, 30),
(0, "sahong", "sahong123", "sahong", "sahong@naver.com", 1, 1),
(0, "hongwoong", "hongwoong123", "hongwoong", "hongwoong@naver.com", 7, 2),
(0, "yoonyoung", "yoonyoung123", "yoonyoung", "yoonyoung@naver.com", 123, 321);


-- 리뷰 등록
INSERT INTO review(review_num, video_id, user_num, comment)
VALUES	(0, 1, 1, "너무 재미있어요 ~"),
		(0, 1, 2, "너무 재미없어요 ~"),
		(0, 1, 3, "오늘따라 운동이 잘 됩니다 ~"),
		(0, 2, 3, "오늘 50kg감량 간다"),
        (0, 2, 4, "운동하고 오늘 집에 안간다"),
		(0, 3, 5, "오예");
        
-- 운동 부위 별 비디오 조회
SELECT * FROM video GROUP BY fitPart;

-- 조회 수 별 비디오 조회 (내림차순)
SELECT * FROM video ORDER BY viewCnt DESC;


        
-- 리뷰 목록 조회
SELECT * FROM review;

-- 리뷰 수정
UPDATE review SET comment = "사실 너무 힘들어요" WHERE review_num = 1;

-- 리뷰 상세
SELECT * FROM review WHERE review_num = 1;

-- 리뷰 삭제
DELETE FROM review WHERE review_num = 1;

-- 리뷰 삭제 확인
SELECT * FROM review;

-- 회원 정보 수정
UPDATE user SET id = "fantasic" WHERE name = "sahong";

-- 회원 정보 상세보기
SELECT * FROM user WHERE name = "sahong";

-- 수정 확인
SELECT * FROM user;

-- 회원 탈퇴
DELETE FROM user WHERE name = "sahong";

-- 회원 팔로잉
INSERT INTO following(my_num, following_num) VALUES(1, 4), (1, 5), (4, 1), (2, 5), (4, 5);

-- 팔로잉 목록 조회
SELECT following_num FROM following WHERE my_num = 4;

-- 팔로워 목록 조회(5번을 팔로잉 하는 사람 조회)
SELECT my_num FROM following WHERE following_num = 5;

-- 팔로우 정보 조회
SELECT * FROM following;

-- 팔로우 정보 삭제 (4번이 1번 팔로우 취소)
DELETE FROM following WHERE my_num = 4 and following_num = 1;

-- 팔로우 정보 조회
SELECT * FROM following;

-- 찜 정보 추가
INSERT INTO jim VALUES(1, 1), (1, 2);
INSERT INTO jim VALUES(2, 4), (2, 5);

-- 찜 정보 조회
SELECT * FROM jim ORDER BY video_id;

-- 사람 한명 삭제
DELETE FROM user WHERE num = 1;

-- 찜 목록 조회
SELECT * FROM jim ORDER BY video_id;

-- 비디오 하나 삭제
DELETE FROM video WHERE id = 2;

-- 찜 목록 조회
SELECT * FROM jim ORDER BY video_id;

-- 사용자가 작성한 리뷰 전체 조회
SELECT * FROM user;
SELECT * FROM review;
SELECT * FROM user
LEFT JOIN review 
ON review.user_num = user.num;


