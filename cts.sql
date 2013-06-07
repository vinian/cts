DROP DATABASE IF EXISTS cts;
CREATE DATABASE cts;
use cts;

CREATE USER cts;
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.60' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.61' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.62' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.63' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.64' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.65' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.66' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.67' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.68' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.70' IDENTIFIED BY 'cts';
GRANT ALL PRIVILEGES ON cts.* TO 'cts'@'192.168.0.71' IDENTIFIED BY 'cts';

FLUSH PRIVILEGES;

/*
-- status: 0 任务未被获取; 13 转码出现错误; 1-8 正在转码中
-- DVD status=6; BluRay status=8
*/

DROP TABLE IF EXISTS task;
CREATE TABLE task (
     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     pathName VARCHAR(200),
     subtitle INT,
     fileType INT,
     videoType INT,
     f_type VARCHAR(20) NOT NULL DEFAULT 'Progressive',
     status INT DEFAULT 0,
     priority INT DEFAULT 0,
     addTime TIMESTAMP DEFAULT NOW(),
     beginTime TIMESTAMP DEFAULT 0,
     finishTime TIMESTAMP DEFAULT 0,
     error INT DEFAULT 0
);

DROP TABLE IF EXISTS onepass;
CREATE TABLE onepass (
     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     sourceId INT,
     script INT,
     status INT DEFAULT 0,
     error INT DEFAULT 0,
     time TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS video;
CREATE TABLE video (
     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     sourceId INT,
     outputFileName VARCHAR(200),
     script INT,
     status INT DEFAULT 0,
     encode_type VARCHAR(15),
     beginTime TIMESTAMP DEFAULT 0,
     endTime TIMESTAMP DEFAULT 0,
     time TIMESTAMP DEFAULT NOW()
);

DROP TABLE  IF EXISTS subtitle;
CREATE TABLE subtitle(
     id INT NOT NULL, 
     name VARCHAR(30),
     options VARCHAR(30)
);

DROP TABLE IF EXISTS audio_options;
CREATE TABLE audio_options (
     id INT,
     name VARCHAR(30),
     options VARCHAR(500)
);

DROP TABLE IF EXISTS video_options;
CREATE TABLE video_options (
     id INT,
     name VARCHAR(50),
     interlaced VARCHAR(30),
     bitrate INT,
     subme INT,
     scale VARCHAR(30),
     bluray VARCHAR(30),
     options INT
);

CREATE TABLE encode_options(
     id INT,
     argument VARCHAR(2000)
);

/*
-- SCALE: -vf scale=[SCALE],harddup
-- BITRATE: 2500
-- BLURAY: --bluray-compat
-- SUBME: --subme 9
*/

DROP TABLE IF EXISTS image;
CREATE TABLE image (
     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     sourceId INT,
     fileName VARCHAR(50),
     outputPath VARCHAR(50),
     time TIMESTAMP DEFAULT 0,
     status INT DEFAULT 0,
     error INT DEFAULT 0
);

DROP TABLE IF EXISTS machine;
CREATE TABLE machine (
     id INT,
     ip VARCHAR(30),
     weight INT,
     time TIMESTAMP DEFAULT NOW(),
     status INT DEFAULT 0
);


DROP TABLE IF EXISTS worker;
CREATE TABLE worker (
     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     sourceId INT,
     video_id INT,
     ipId VARCHAR(15),
     command1 VARCHAR(2000),
     command2 VARCHAR(1000),
     command3 VARCHAR(1000),
     type VARCHAR(10),
     priority INT DEFAULT 0,
     time TIMESTAMP DEFAULT NOW(),
     status INT DEFAULT 0,
     error INT DEFAULT 0
);

DROP TABLE IF EXISTS error;
CREATE TABLE error (
     id INT,
     reason VARCHAR(1000)
);


INSERT INTO audio_options (id, options, name) values (
       0, '-an', 'noaudio'
);

INSERT INTO audio_options (id, options, name) values (
       1, '-acodec libfaac -ab 64k -ac 2 -ar 48000 -async 1', '64k'
);

INSERT INTO audio_options (id, options, name) values (
       2, '-acodec libfaac -ab 128k -ac 2 -ar 48000 -async 1', '128k'
);

DROP TABLE IF EXISTS encode_options;
CREATE TABLE encode_options(
     id INT,
     name VARCHAR(20) DEFAULT NULL,
     arguments VARCHAR(3000) NOT NULL
);

INSERT INTO encode_options(name, id, arguments) VALUES (
       'x264_first',  1, 'MPLAYER_PROG -nosound -benchmark -sws 9 -vo yuv4mpeg:file=>(X264_PROG --bitrate BITRATE BLURAY --vbv-maxrate 0 --vbv-bufsize 0 --keyint 50 --min-keyint 25 --scenecut 40 --bframes 6 --b-adapt 2 --b-bias 0 --b-pyramid strict --qpmin 10 --qpmax 51 --qpstep 4 --ratetol 1.0 --ipratio 0.71 --chroma-qp-offset 2 --aq-strength 1.0 --qcomp 0.60 --cplxblur 20.0 --qblur 0.5 --direct auto --weightp 2 --me umh --merange 24 --subme SUBME_VALUE --psy-rd 1.0:0.0 --ref 6 --deblock -2:-1 --mixed-refs --8x8dct --partitions p8x8,b8x8,i8x8,i4x4 --trellis 2 --sar 1:1 --no-mbtree --level 3.1 --pass PASS_VALUE --demuxer y4m --threads auto -o OUTPUTFILE - 2>/dev/null) -vf FILTERharddup INPUTFILE');

DROP TABLE IF EXISTS video_options;
CREATE TABLE video_options (
     id INT,
     name VARCHAR(50),
     bitrate INT,
     subme INT,
     filter VARCHAR(50),
     bluray VARCHAR(30),
     options VARCHAR(1500)
);

INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       1, 'd_onepass_nointerlaced',  2500, 1, '', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       2, 'd_twopass_368_nointerlaced', 368, 7, 'scale=400:-3,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       3, 'd_twopass_600_nointerlaced', 600, 7, 'scale=640:-3,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       4, 'd_twopass_750_nointerlaced', 750, 8, 'scale=640:-3,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       5, 'd_twopass_900_nointerlaced', 900, 8, 'scale=720:-3,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       6, 'd_twopass_1200_nointerlaced', 1200, 9, 'scale=854:-3,', '', 1
);

INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       21, 'd_onepass_deinterlaced', 2500, 1, 'pp=fd,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       22, 'd_twopass_368_deinterlaced', 368, 7, 'scale=400:-3,pp=fd,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       23, 'd_twopass_600_deinterlaced', 600, 7, 'scale=640:-3,pp=fd,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       24, 'd_twopass_750_deinterlaced', 750, 8, 'scale=640:-3,pp=fd,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       25, 'd_twopass_900_deinterlaced', 900, 8, 'scale=720:-3,pp=fd,', '', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       26, 'd_twopass_1200_deinterlaced', 1200, 9, 'scale=854:-3,pp=fd,', '', 1
);


INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       41, 'b_onepass_nointerlaced', 2500, 1, '', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       42, 'b_twopass_368_nointerlaced', 368, 7, 'scale=400:-3,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       43, 'b_twopass_600_nointerlaced', 600, 7, 'scale=640:-3,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       44, 'b_twopass_750_nointerlaced', 750, 8, 'scale=640:-3,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       45, 'b_twopass_900_nointerlaced', 900, 8, 'scale=720:-3,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       46, 'b_twopass_1200_nointerlaced', 1200, 9, 'scale=854:-3,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       47, 'b_twopass_1600_nointerlaced', 1600, 9, 'scale=1280:-3,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       48, 'b_twopass_2500_nointerlaced', 2500, 9, 'scale=1920:-3,', '--bluray-compat', 1
);

INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       61, 'b_onepass_deinterlaced', 2500, 1, 'pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       62, 'b_twopass_368_deinterlaced', 368, 7, 'scale=400:-3,pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       63, 'b_twopass_600_deinterlaced', 600, 7, 'scale=640:-3,pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       64, 'b_twopass_750_deinterlaced', 750, 8, 'scale=640:-3,pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       65, 'b_twopass_900_deinterlaced', 900, 8, 'scale=720:-3,pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       66, 'b_twopass_1200_deinterlaced', 1200, 9, 'scale=854:-3,pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       67, 'b_twopass_1600_deinterlaced', 1600, 9, 'scale=1280:-3,pp=fd,', '--bluray-compat', 1
);
INSERT INTO video_options(id, name, bitrate, subme, filter, bluray,  options) VALUES (
       68, 'b_twopass_2500_deinterlaced', 2500, 9, 'scale=1920:-3,pp=fd,', '--bluray-compat', 1
);

DROP TABLE IF EXISTS script;
CREATE TABLE script (
     id INT,
     name VARCHAR(50),
     audio_options INT,
     video_options INT,
     subtitle INT DEFAULT NULL
);

INSERT INTO script(id, name, audio_options, video_options) values (1, 'dvd_onepass', 0, 1);
INSERT INTO script(id, name, audio_options, video_options) values (2, 'dvd_368', 1, 2);
INSERT INTO script(id, name, audio_options, video_options) values (3, 'dvd_600', 1, 3);
INSERT INTO script(id, name, audio_options, video_options) values (4, 'dvd_750', 1, 4);
INSERT INTO script(id, name, audio_options, video_options) values (5, 'dvd_900', 1, 5);
INSERT INTO script(id, name, audio_options, video_options) values (6, 'dvd_1200', 2, 6);

INSERT INTO script(id, name, audio_options, video_options) values (21, 'dvd_onepass_de', 0, 21);
INSERT INTO script(id, name, audio_options, video_options) values (22, 'dvd_368_de', 1, 22);
INSERT INTO script(id, name, audio_options, video_options) values (23, 'dvd_600_de', 1, 23);
INSERT INTO script(id, name, audio_options, video_options) values (24, 'dvd_750_de', 1, 24);
INSERT INTO script(id, name, audio_options, video_options) values (25, 'dvd_900_de', 1, 25);
INSERT INTO script(id, name, audio_options, video_options) values (26, 'dvd_1200_de', 2, 26);

INSERT INTO script(id, name, audio_options, video_options) values (41, 'blu_onepass', 0, 41);
INSERT INTO script(id, name, audio_options, video_options) values (42, 'blu_368', 1, 42);
INSERT INTO script(id, name, audio_options, video_options) values (43, 'blu_600', 1, 43);
INSERT INTO script(id, name, audio_options, video_options) values (44, 'blu_750', 1, 44);
INSERT INTO script(id, name, audio_options, video_options) values (45, 'blu_900', 1, 45);
INSERT INTO script(id, name, audio_options, video_options) values (46, 'blu_1200', 2, 46);
INSERT INTO script(id, name, audio_options, video_options) values (47, 'blu_1600', 2, 47);
INSERT INTO script(id, name, audio_options, video_options) values (48, 'blu_2500', 2, 48);

INSERT INTO script(id, name, audio_options, video_options) values (61, 'blu_onepass_de', 0, 61);
INSERT INTO script(id, name, audio_options, video_options) values (62, 'blu_368_de', 1, 62);
INSERT INTO script(id, name, audio_options, video_options) values (63, 'blu_600_de', 1, 63);
INSERT INTO script(id, name, audio_options, video_options) values (64, 'blu_750_de', 1, 64);
INSERT INTO script(id, name, audio_options, video_options) values (65, 'blu_900_de', 1, 65);
INSERT INTO script(id, name, audio_options, video_options) values (66, 'blu_1200_de', 2, 66);
INSERT INTO script(id, name, audio_options, video_options) values (67, 'blu_1600_de', 2, 67);
INSERT INTO script(id, name, audio_options, video_options) values (68, 'blu_2500_de', 2, 68);

/*
--- INSERT INTO interlace (id, name, options) VALUES (1, 'f_interlace', '-deinterlace');
*/

INSERT INTO subtitle(id, name, options) values (1, 'no_subtitle', ' ');
INSERT INTO subtitle(id, name, options) values (2, 'm_subtitle', '-slang chi');

/*
--- machine
*/

INSERT INTO machine (id, ip, weight, status) values (0, '192.168.0.60', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (1, '192.168.0.61', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (2, '192.168.0.62', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (3, '192.168.0.63', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (4, '192.168.0.64', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (5, '192.168.0.65', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (6, '192.168.0.66', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (7, '192.168.0.67', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (8, '192.168.0.68', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (9, '192.168.0.70', 0, 1);
INSERT INTO machine (id, ip, weight, status) values (10, '192.168.0.71', 0, 1);

CREATE TABLE upload (
     id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
     sourceId INT,
     ip VARCHAR(20),
     path VARCHAR(100),
     priority INT DEFAULT 0,
     status int DEFAULT 0
);

CREATE TABLE IF NOT EXISTS backup (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    filename varchar(100),
    md5 varchar(35) NOT NULL,
    ip varchar(16),
    type varchar(10),
    size varchar(15),
    time TIMESTAMP DEFAULT NOW()
);

