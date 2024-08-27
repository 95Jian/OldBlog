-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: blog
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `blog`
--

/*!40000 DROP DATABASE IF EXISTS `blog`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `blog` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `blog`;

--
-- Table structure for table `about`
--

DROP TABLE IF EXISTS `about`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `about` (
  `id` bigint NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `name_zh` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `value` longtext CHARACTER SET utf8 COLLATE utf8_general_ci,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `about`
--

LOCK TABLES `about` WRITE;
/*!40000 ALTER TABLE `about` DISABLE KEYS */;
INSERT INTO `about` VALUES (1,'title','标题','小鉴的故事'),(2,'musicId','网易云歌曲ID','346089'),(3,'content','正文Markdown','大家好，我是一名研零的学生\n\n'),(4,'commentEnabled','评论开关','false');
/*!40000 ALTER TABLE `about` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文章标题',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文章正文',
  `description` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '描述',
  `is_published` bit(1) NOT NULL COMMENT '公开或私密',
  `is_recommend` bit(1) NOT NULL COMMENT '推荐开关',
  `is_appreciation` bit(1) NOT NULL COMMENT '赞赏开关',
  `is_comment_enabled` bit(1) NOT NULL COMMENT '评论开关',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `views` int NOT NULL COMMENT '浏览次数',
  `category_id` bigint NOT NULL COMMENT '文章分类',
  `user_id` bigint DEFAULT NULL COMMENT '文章作者',
  `is_top` bit(1) NOT NULL COMMENT '是否置顶',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '密码保护',
  `first_picture` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文章首图，用于随机文章展示',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type_id` (`category_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
INSERT INTO `blog` VALUES (1,'对IOC控制反转的理解?','# 是什么\n\nIOC全称是 `Inversion of Control`控制反转。按照字面意思理解，将控制反转过来，这里的控制指的是什么？为什么要进行反转，ioc可以解决什么问题？要回答这些问题，我们需要先了解一下IOC为什么会产生。\n\n# 怎么来的？\n\nJava是一门面向对象的语言，我们的应用程序通过一个个对象之间的**相互关联**和作用来完成功能，就像手表里的机械结构。每一个齿轮代表一个对象，对象之间彼此紧密咬合形成一个系统，这样的系统对象之间的**耦合度**非常高，所谓的耦合度就是关系的依赖程度，高耦合度带来的问题显而易见，只要有一个齿轮发生故障，其它齿轮也无法工作，进而整个系统都无法正常工作，这种牵一发而动全身情况如何才能改善呢？\n\n![](https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/static/default-post-image.jpg)\n\n再来一个Service层实际的例子：\n\n```Java\npublic class UserServiceImpl {\n    private UserDao userDao = new UserDaoImpl();\n    private UserDao userDao = (UserDao)BeanFactory.getBean(\"userDao\");\n\n    public List<User> getAllUser(){\n        return userDao.getAllUser();\n    }\n}\n```\n\n一个是**独立控制**通过**new**一个UserDao实现类来完成，一个是**Bean工厂**通过全限定类名找到Bean对象并创建多例对象，**无法自主控制**。第二者把控制权交给了Bean工厂来创建对象，带来的好处就是降低程序间的依赖关系，也叫削减计算机的耦合。\n\n# 改善方法？\n\n上面机械齿轮的例子可以通过一个中间齿轮的方式来解决，也就是后面的**中间IOC容器**。所有的齿轮都交由中间这个齿轮管理，试着把中间这个齿轮拿掉我们可以看到这两个齿轮之间彼此毫无关系，即使一个齿轮出了故障，也不会影响到其它齿轮。\n中间这个齿轮就好比ioc容器，其它齿轮就是对象，可以看出引入了ioc容器，对象之间的耦合度降低了。当我们修改一个对象的时候不需要去考虑其它对象，因为它不会对其它对象造成影响。\n\n# ioc的原理？\n\n这里说到的ioc容器到底是个什么东东，又是什么让它具有如此神奇的力量？\n\n先来看一下没有ioc容器的时候，对象A依赖对象B，A在运行到某一时刻的时候会去创建B的对象，在这里A具有主动权，它控制了对象B的创建。\n\n引入ioc以后对象A和对象B之间没有了直接联系，当A运行的时候由ioc容器创建B对象在适当的时候注入到A中，在这里，控制权由A对象转移到了ioc容器。这也就是控制反转名称的由来。\n\n基于上述UserDao的例子我们可以通过**反射**来**解耦**，反射可以根据类的全限定名在程序运行时创建对象，可以这样做，将类的全限定名配置在xml文件中，在程序运行时通过反射读取该类的全限定名，动态的创建对象，赋值给userDao接口userDaoImpl。这样做后UserServiceImpl和UserDaoImpl之间没有了直接的关系，当我们需要替换UserDaoImpl对象的时候只需要在配置文件中去修改类的全限定名就可以了，非常的灵活方便，ioc容器的实现就是这个原理。\n\nIOC容器可以自动的帮我们完成以上一系列操作，我们需要做的就是通过配置文件告诉ioc需要创建哪个类以及类和类之间的关系。\n\n# 控制反转和依赖注入\n\n在这里需要提到一个概念**依赖注入**，很多初学者搞不清楚控制反转和依赖注入之间的关系，其实他们是对同一事物的不同角度的描述。\n**控制反转是一种设计思想**而**依赖注入是这种思想的具体实现**\n\n具体说控制反转就是将创建userDaoImpl对象的控制权反转过来由UserServiceImpl交给了ioc容器，强调的是一种能力和思想，ioc容器具有了控制权。\n\n依赖注入就是ioc容器将UserServiceImpl所依赖的对象userDaoImpl，注入给UserServiceImpl，强调的是一个**过程和实现**。\n\nIOC很好的体现了面向对象设计法则之一—— 好莱坞法则：“别找我们，我们找你”。\n\n# 优缺点\n\n1. 软件系统中由于引入了第三方IOC容器，生成对象的步骤变得有些复杂，本来是两者之间的事情，又凭空多出一道手续，所以，我们在刚开始使用IOC框架的时候，会感觉系统变得不太直观。所以，引入了一个全新的框架，就会增加团队成员学习和认识的培训成本，并且在以后的运行维护中，还得让新加入者具备同样的知识体系。\n2. 由于IOC容器生成对象是通过反射方式，在运行效率上有一定的损耗。如果你要追求运行效率的话，就必须对此进行权衡。\n3. 具体到IOC框架产品(比如：Spring)来讲，需要进行大量的配制工作，比较繁琐，对于一些小的项目而言，客观上也可能加大一些工作成本。\n4. IOC框架产品本身的成熟度需要进行评估，如果引入一个不成熟的IOC框架产品，那么会影响到整个项目，所以这也是一个隐性的风险。\n\n我们大体可以得出这样的结论：一些工作量不大的项目或者产品，不太适合使用IOC框架产品。另外，如果团队成员的知识能力欠缺，对于IOC框架产品缺乏深入的理解，也不要贸然引入。最后，特别强调运行效率的项目或者产品，也不太适合引入IOC框架产品，像WEB2.0网站就是这种情况。\n\n> Spring框架文档：\n> [https://rawchen.com/spring5][2]\n\n[1]: https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/static/default-post-image.jpg\n[2]: https://rawchen.com/spring5\n\n','IOC全称是 `Inversion of Control`控制反转。按照字面意思理解，将控制反转过来，这里的控制指的是什么？为什么要进行反转，ioc可以解决什么问题？要回答这些问题，我们需要先了解一下IOC为什么会产生。',_binary '',_binary '',_binary '\0',_binary '\0','2021-03-17 14:07:25','2021-05-22 23:30:05',137,1,1,_binary '\0','','https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/ContentThumb/9.jpg'),(3,'金铲铲之战s9.5卡莉斯塔','**金铲铲之战s9.5卡莉斯塔装备怎么搭配。卡莉斯塔的装备选择需要灵活应变。为了确保她的战斗力，我们可以根据游戏版本的改动和卡莉斯塔属性的变化来调整装备。**\n\n卡莉斯塔：(光明)羊刀+裁决转，第三件按序推荐：光明巨杀 光明法爆 狙击手 普通法爆。如果海克斯拿了珠光莲花，也可以用水银或者帽子。当然，也可以给王冠。\n\n![](https://img1.gamedog.cn/2023/09/02/7275108-230Z21913060.jpg)\n\n慎：(光明)板甲+狂徒，第三件推荐暗影岛转，如果没有暗影岛转就空着等暗影岛转，前两件也够用。到5-3如果还没有，随便给个防具就行了。\n\n亚索：2\\~3个圣杯。\n\n因为装备需求比较严苛，所以英雄之力推荐拿卡牌，第一个一定要拿潘多拉的装备，后面两个刷掉。选秀尽量抢铲子，铲子永远不嫌多。\n\n','**金铲铲之战s9.5卡莉斯塔装备怎么搭配。卡莉斯塔的装备选择需要灵活应变。为了确保她的战斗力，我们可以根据游戏版本的改动和卡莉斯塔属性的变化来调整装备。**\n\n卡莉斯塔：(光明)羊刀+裁决转，第三件按序推荐：光明巨杀 光明法爆 狙击手 普通法爆。如果海克斯拿了珠光莲花，也可以用水银或者帽子。当然，也可以给王冠。\n\n',_binary '',_binary '',_binary '\0',_binary '\0','2024-08-27 14:27:58','2024-08-27 15:43:29',1,2,1,_binary '','','https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/ContentThumb/3.jpg'),(4,'唐哥是傻逼','sb\n\n','**shabi**\n\n',_binary '',_binary '',_binary '\0',_binary '\0','2024-08-27 15:50:01','2024-08-27 15:50:01',0,3,1,_binary '','','https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/ContentThumb/5.jpg'),(5,'新文章test8.27 19：56','新文章test8.27 19：56\n\n','新文章test8.27 19：56\n\n',_binary '',_binary '',_binary '\0',_binary '\0','2024-08-27 19:56:28','2024-08-27 19:56:28',0,1,1,_binary '\0','','https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/ContentThumb/8.jpg');
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_tag`
--

DROP TABLE IF EXISTS `blog_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_tag` (
  `blog_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_tag`
--

LOCK TABLES `blog_tag` WRITE;
/*!40000 ALTER TABLE `blog_tag` DISABLE KEYS */;
INSERT INTO `blog_tag` VALUES (1,1),(1,2),(3,1),(5,1);
/*!40000 ALTER TABLE `blog_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'test'),(2,'default'),(3,'类别1');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city_visitor`
--

DROP TABLE IF EXISTS `city_visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city_visitor` (
  `city` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市名称',
  `uv` int NOT NULL COMMENT '独立访客数量',
  PRIMARY KEY (`city`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city_visitor`
--

LOCK TABLES `city_visitor` WRITE;
/*!40000 ALTER TABLE `city_visitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `city_visitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nickname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '昵称',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '评论内容',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '头像(图片路径)',
  `create_time` datetime DEFAULT NULL COMMENT '评论时间',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '评论者ip地址',
  `is_published` bit(1) NOT NULL COMMENT '公开或回收站',
  `is_admin_comment` bit(1) NOT NULL COMMENT '博主回复',
  `page` int NOT NULL COMMENT '0普通文章，1关于我页面，2友链页面',
  `is_notice` bit(1) NOT NULL COMMENT '接收邮件提醒',
  `blog_id` bigint DEFAULT NULL COMMENT '所属的文章',
  `parent_comment_id` bigint NOT NULL COMMENT '父评论id，-1为根评论',
  `website` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '个人网站',
  `qq` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '如果评论昵称为QQ号，则将昵称和头像置为QQ昵称和QQ头像，并将此字段置为QQ号备份',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,'RawChen','2221999792@qq.com','测试下哈','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-03-18 21:34:24','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,-1,'https://rawchen.com','2221999792'),(2,'RawChen','2221999792@qq.com','测试回复','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-03-18 22:02:57','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,1,'https://rawchen.com','2221999792'),(3,'RawChen','2221999792@qq.com','测试t','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-03-22 08:20:40','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,2,'https://rawchen.com','2221999792'),(4,'RawChen','2221999792@qq.com','测试回复','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-03-22 08:30:35','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,3,'https://rawchen.com','2221999792'),(5,'RawChen','2221999792@qq.com','回复1','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-03-22 08:32:17','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,-1,'https://rawchen.com','2221999792'),(6,'棒棒糖堂主','2221999792@qq.com','回','http://q.qlogo.cn/g?b=qq&nk=362774405&s=100','2021-04-26 10:28:04','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,1,'https://rawchen.com','362774405'),(7,'棒棒糖堂主','2221999792@qq.com','测试啊啊啊啊啊啊啊啊','http://q.qlogo.cn/g?b=qq&nk=362774405&s=100','2021-04-26 10:32:10','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,5,'https://rawchen.com','362774405'),(8,'RawChen','2221999792@qq.com','aaa','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-05-10 11:08:45','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,-1,'https://rawchen.com','2221999792'),(9,'RawChen','2221999792@qq.com','@[tv_白眼]','http://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-05-11 13:46:31','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,-1,'https://rawchen.com','2221999792'),(10,'RawChen','rawchen@qq.com','啊','https://q.qlogo.cn/g?b=qq&nk=2221999792&s=100','2021-05-19 00:24:13','192.168.136.1',_binary '',_binary '\0',0,_binary '',1,-1,'https://rawchen.com','2221999792'),(11,'Admin','2221999792@qq.com','我的回复','/img/avatar.jpg','2021-05-19 00:29:20','192.168.136.1',_binary '',_binary '',0,_binary '\0',1,10,'/',NULL),(13,'Admin','2221999792@qq.com','加油呀','/img/avatar.jpg','2024-08-27 13:14:58','10.22.197.127',_binary '',_binary '',1,_binary '\0',NULL,-1,'/',NULL),(14,'Admin','2221999792@qq.com','很好','/img/avatar.jpg','2024-08-27 14:19:37','10.22.197.127',_binary '',_binary '',2,_binary '\0',NULL,-1,'/',NULL);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exception_log`
--

DROP TABLE IF EXISTS `exception_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exception_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uri` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求接口',
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求方式',
  `param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '请求参数',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作描述',
  `error` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '异常信息',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip',
  `ip_source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '浏览器',
  `create_time` datetime NOT NULL COMMENT '操作时间',
  `user_agent` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'user-agent用户代理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exception_log`
--

LOCK TABLES `exception_log` WRITE;
/*!40000 ALTER TABLE `exception_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `exception_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend`
--

DROP TABLE IF EXISTS `friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friend` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nickname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '昵称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '描述',
  `website` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '站点',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '头像',
  `is_published` bit(1) NOT NULL COMMENT '公开或隐藏',
  `views` int NOT NULL COMMENT '点击次数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend`
--

LOCK TABLES `friend` WRITE;
/*!40000 ALTER TABLE `friend` DISABLE KEYS */;
/*!40000 ALTER TABLE `friend` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_log`
--

DROP TABLE IF EXISTS `login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名称',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip',
  `ip_source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '浏览器',
  `status` bit(1) DEFAULT NULL COMMENT '登录状态',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作描述',
  `create_time` datetime NOT NULL COMMENT '登录时间',
  `user_agent` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'user-agent用户代理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_log`
--

LOCK TABLES `login_log` WRITE;
/*!40000 ALTER TABLE `login_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moment`
--

DROP TABLE IF EXISTS `moment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '动态内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `likes` int DEFAULT NULL COMMENT '点赞数量',
  `is_published` bit(1) NOT NULL COMMENT '是否公开',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moment`
--

LOCK TABLES `moment` WRITE;
/*!40000 ALTER TABLE `moment` DISABLE KEYS */;
INSERT INTO `moment` VALUES (1,'测试动态\n\n','2021-03-18 21:42:32',1,_binary ''),(4,'动态测试\n\n','2024-08-27 15:35:43',1,_binary ''),(5,'你好\n\n','2024-08-19 00:00:00',0,_binary '');
/*!40000 ALTER TABLE `moment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_log`
--

DROP TABLE IF EXISTS `operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作者用户名',
  `uri` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求接口',
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求方式',
  `param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '请求参数',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作描述',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip',
  `ip_source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '浏览器',
  `times` int NOT NULL COMMENT '请求耗时（毫秒）',
  `create_time` datetime NOT NULL COMMENT '操作时间',
  `user_agent` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'user-agent用户代理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_log`
--

LOCK TABLES `operation_log` WRITE;
/*!40000 ALTER TABLE `operation_log` DISABLE KEYS */;
INSERT INTO `operation_log` VALUES (105,'admin','/admin/blog','POST','{\"blog\":{\"id\":5,\"title\":\"新文章test8.27 19：56\",\"firstPicture\":\"https://cdn.jsdelivr.net/gh/rawchen/JsDelivr/ContentThumb/8.jpg\",\"content\":\"新文章test8.27 19：56\\n\\n\",\"description\":\"新文章test8.27 19：56\\n\\n\",\"published\":true,\"recommend\":true,\"appreciation\":false,\"commentEnabled\":false,\"top\":false,\"createTime\":1724759788083,\"updateTime\":1724759788083,\"views\":0,\"password\":\"\",\"user\":{\"id\":1,\"username\":null,\"password\":null,\"nickname\":null,\"avatar\":null,\"email\":null,\"createTime\":null,\"updateTime\":null,\"role\":null},\"category\":{\"id\":1,\"name\":\"test\",\"blogs\":[]},\"tags\":[],\"cate\":1,\"tagList\":[1]}}','发布博客','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',8,'2024-08-27 19:56:28','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(106,'admin','/admin/moment','DELETE','{\"id\":2}','删除动态','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',4,'2024-08-27 19:57:39','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0');
/*!40000 ALTER TABLE `operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_job`
--

DROP TABLE IF EXISTS `schedule_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `bean_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'spring bean名称',
  `method_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '方法名',
  `params` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '参数',
  `cron` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'cron表达式',
  `status` tinyint DEFAULT NULL COMMENT '任务状态',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_job`
--

LOCK TABLES `schedule_job` WRITE;
/*!40000 ALTER TABLE `schedule_job` DISABLE KEYS */;
INSERT INTO `schedule_job` VALUES (1,'redisSyncScheduleTask','syncBlogViewsToDatabase','','0 0 1 * * ?',1,'每天凌晨一点，从Redis将博客浏览量同步到数据库','2020-11-17 23:45:42'),(2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','','0 0 0 * * ? *',1,'清空当天Redis访客标识，记录当天的PV和UV，更新当天所有访客的PV和最后访问时间，更新城市新增访客UV数','2021-02-05 08:14:28');
/*!40000 ALTER TABLE `schedule_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_job_log`
--

DROP TABLE IF EXISTS `schedule_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_job_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志id',
  `job_id` bigint NOT NULL COMMENT '任务id',
  `bean_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'spring bean名称',
  `method_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '方法名',
  `params` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '参数',
  `status` tinyint NOT NULL COMMENT '任务执行结果',
  `error` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '异常信息',
  `times` int NOT NULL COMMENT '耗时（单位：毫秒）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_job_log`
--

LOCK TABLES `schedule_job_log` WRITE;
/*!40000 ALTER TABLE `schedule_job_log` DISABLE KEYS */;
INSERT INTO `schedule_job_log` VALUES (1,1,'redisSyncScheduleTask','syncBlogViewsToDatabase','',1,NULL,16,'2021-03-18 10:26:07'),(2,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,45,'2021-03-18 10:27:25'),(3,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,32,'2021-03-18 17:57:45'),(4,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,24,'2021-03-18 18:12:35'),(5,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,33,'2021-03-22 08:37:30'),(6,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,25,'2021-04-05 23:55:26'),(7,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,37,'2021-04-12 11:34:47'),(8,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,15,'2021-04-12 11:37:14'),(9,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,202302,'2021-04-12 11:44:50'),(10,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,53,'2021-04-26 08:38:47'),(11,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,11,'2021-04-26 09:04:31'),(12,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,188,'2021-05-12 00:00:00'),(13,2,'visitorSyncScheduleTask','syncVisitInfoToDatabase','',1,NULL,87,'2024-08-27 00:00:00');
/*!40000 ALTER TABLE `schedule_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_setting`
--

DROP TABLE IF EXISTS `site_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_setting` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `name_zh` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `value` longtext CHARACTER SET utf8 COLLATE utf8_general_ci,
  `type` int DEFAULT NULL COMMENT '1基础设置，2页脚徽标，3资料卡，4友链信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_setting`
--

LOCK TABLES `site_setting` WRITE;
/*!40000 ALTER TABLE `site_setting` DISABLE KEYS */;
INSERT INTO `site_setting` VALUES (1,'webTitleSuffix','网页标题后缀','-后缀',1),(2,'blogName','博客名称','博客的昵称',1),(14,'avatar','图片路径','/img/avatar.jpg',3),(15,'name','昵称','小鉴的昵称',3),(22,'favorite','自定义','{\"title\":\"感兴趣的事\",\"content\":\"写博客、极简化、后端开发、摄影、旅游\"}',3),(23,'favorite','自定义','{\"title\":\"最喜欢的人\",\"content\":\"马斯克、乔布斯\"}',3),(24,'favorite','自定义','{\"title\":\"最喜欢的电影\",\"content\":\"太多了\"}',3);
/*!40000 ALTER TABLE `site_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `color` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '标签颜色(可选)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'test','green'),(2,'IOC','purple'),(3,'金铲铲','red');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '头像地址',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `role` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色访问权限',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','$2a$10$V5.FLSNsCtJYarg2f2Xjc./s.qzp5Kxb744dz5Xf4dnMgEhhx56xu','Admin','/img/avatar.jpg','2221999792@qq.com','2020-09-21 16:47:18','2020-09-21 16:47:22','ROLE_admin');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_log`
--

DROP TABLE IF EXISTS `visit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '访客标识码',
  `uri` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求接口',
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求方式',
  `param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '请求参数',
  `behavior` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '访问行为',
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '访问内容',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip',
  `ip_source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '浏览器',
  `times` int NOT NULL COMMENT '请求耗时（毫秒）',
  `create_time` datetime NOT NULL COMMENT '访问时间',
  `user_agent` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'user-agent用户代理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=962 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_log`
--

LOCK TABLES `visit_log` WRITE;
/*!40000 ALTER TABLE `visit_log` DISABLE KEYS */;
INSERT INTO `visit_log` VALUES (947,'865cff8b-8b17-3508-9c9d-2f441c461095','/category','GET','{\"categoryName\":\"default\",\"pageNum\":1}','查看分类','default','分类名称：default，第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',3,'2024-08-27 19:58:36','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(948,'865cff8b-8b17-3508-9c9d-2f441c461095','/archives','GET','{}','访问页面','文章归档','','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',6,'2024-08-27 19:58:37','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(949,'865cff8b-8b17-3508-9c9d-2f441c461095','/moments','GET','{\"pageNum\":1,\"jwt\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbjphZG1pbiIsImV4cCI6MTcyNDk5MjA0Nn0.p2RRCVwP6BNTP3AsCTJJESStiw-tRbXCQgteWbrlNCxRz5IGwt_08NdS0ZkLiA08iXqNmrmjvVWU4ZCzrNzs0g\"}','访问页面','动态','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',3,'2024-08-27 19:58:37','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(950,'865cff8b-8b17-3508-9c9d-2f441c461095','/about','GET','{}','访问页面','关于我','','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',0,'2024-08-27 19:58:38','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(951,'865cff8b-8b17-3508-9c9d-2f441c461095','/moments','GET','{\"pageNum\":1,\"jwt\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbjphZG1pbiIsImV4cCI6MTcyNDk5MjA0Nn0.p2RRCVwP6BNTP3AsCTJJESStiw-tRbXCQgteWbrlNCxRz5IGwt_08NdS0ZkLiA08iXqNmrmjvVWU4ZCzrNzs0g\"}','访问页面','动态','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',3,'2024-08-27 19:58:39','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(952,'865cff8b-8b17-3508-9c9d-2f441c461095','/archives','GET','{}','访问页面','文章归档','','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',1,'2024-08-27 19:58:39','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(953,'865cff8b-8b17-3508-9c9d-2f441c461095','/blogs','GET','{\"pageNum\":1}','访问页面','首页','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',8,'2024-08-27 19:58:40','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(954,'865cff8b-8b17-3508-9c9d-2f441c461095','/category','GET','{\"categoryName\":\"default\",\"pageNum\":1}','查看分类','default','分类名称：default，第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',4,'2024-08-27 19:58:41','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(955,'865cff8b-8b17-3508-9c9d-2f441c461095','/archives','GET','{}','访问页面','文章归档','','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',0,'2024-08-27 19:58:42','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(956,'865cff8b-8b17-3508-9c9d-2f441c461095','/moments','GET','{\"pageNum\":1,\"jwt\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbjphZG1pbiIsImV4cCI6MTcyNDk5MjA0Nn0.p2RRCVwP6BNTP3AsCTJJESStiw-tRbXCQgteWbrlNCxRz5IGwt_08NdS0ZkLiA08iXqNmrmjvVWU4ZCzrNzs0g\"}','访问页面','动态','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',5,'2024-08-27 19:58:42','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(957,'865cff8b-8b17-3508-9c9d-2f441c461095','/about','GET','{}','访问页面','关于我','','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',1,'2024-08-27 19:59:34','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(958,'865cff8b-8b17-3508-9c9d-2f441c461095','/moments','GET','{\"pageNum\":1,\"jwt\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbjphZG1pbiIsImV4cCI6MTcyNDk5MjA0Nn0.p2RRCVwP6BNTP3AsCTJJESStiw-tRbXCQgteWbrlNCxRz5IGwt_08NdS0ZkLiA08iXqNmrmjvVWU4ZCzrNzs0g\"}','访问页面','动态','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',2,'2024-08-27 19:59:35','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(959,'865cff8b-8b17-3508-9c9d-2f441c461095','/blogs','GET','{\"pageNum\":1}','访问页面','首页','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',3,'2024-08-27 19:59:46','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(960,'865cff8b-8b17-3508-9c9d-2f441c461095','/blogs','GET','{\"pageNum\":1}','访问页面','首页','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',2,'2024-08-27 20:00:44','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0'),(961,'865cff8b-8b17-3508-9c9d-2f441c461095','/blogs','GET','{\"pageNum\":1}','访问页面','首页','第1页','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0',2,'2024-08-27 20:02:26','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0');
/*!40000 ALTER TABLE `visit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_record`
--

DROP TABLE IF EXISTS `visit_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pv` int NOT NULL COMMENT '访问量',
  `uv` int NOT NULL COMMENT '独立用户',
  `date` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '日期"02-23"',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_record`
--

LOCK TABLES `visit_record` WRITE;
/*!40000 ALTER TABLE `visit_record` DISABLE KEYS */;
INSERT INTO `visit_record` VALUES (1,151,5,'03-17'),(2,220,5,'03-18'),(3,0,0,'03-21'),(4,0,0,'04-04'),(5,0,0,'04-11'),(6,0,0,'04-11'),(7,0,0,'04-11'),(8,0,0,'04-25'),(9,0,0,'04-25'),(10,101,1,'05-11'),(11,0,0,'08-26');
/*!40000 ALTER TABLE `visit_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitor`
--

DROP TABLE IF EXISTS `visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访客标识码',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip',
  `ip_source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '浏览器',
  `create_time` datetime NOT NULL COMMENT '首次访问时间',
  `last_time` datetime NOT NULL COMMENT '最后访问时间',
  `pv` int DEFAULT NULL COMMENT '访问页数统计',
  `user_agent` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'user-agent用户代理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor`
--

LOCK TABLES `visitor` WRITE;
/*!40000 ALTER TABLE `visitor` DISABLE KEYS */;
INSERT INTO `visitor` VALUES (1,'7cbd1d76-f7ae-4926-9c93-94ff0a3927f6','192.168.136.1','内网IP|内网IP','Windows 10','Edge 89.0.774.54','2021-03-17 14:37:36','2021-03-17 14:37:36',3,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36 Edg/89.0.774.54'),(2,'86095574-34d0-4daa-a3d4-4a1284bd8b59','192.168.136.1','内网IP|内网IP','Windows 10','Chrome 87.0.4280.141','2021-03-17 18:13:33','2021-03-17 21:12:28',153,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36'),(3,'7d1eec6f-384a-42f2-b4e5-6735021bce07','192.168.136.1','内网IP|内网IP','Windows 10','Edge 89.0.774.54','2021-03-17 20:35:25','2021-03-17 20:36:36',9,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36 Edg/89.0.774.54'),(4,'f6f4ccd9-3526-4b71-ae56-246e84861c42','192.168.136.1','内网IP|内网IP','Windows 10','Chrome 87.0.4280.141','2021-03-17 21:40:27','2021-03-17 23:49:12',189,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36'),(5,'f12fb23b-15d0-41e7-9c74-aa979df6ca3e','192.168.136.1','内网IP|内网IP','Windows 10','Chrome 87.0.4280.141','2021-03-22 08:18:55','2021-03-22 08:18:55',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36'),(6,'3cfd4af5-74ae-48a6-9b60-5a224cdda761','192.168.136.1','内网IP|内网IP','Windows 10','Chrome 87.0.4280.141','2021-03-24 14:38:36','2021-03-24 14:38:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36'),(7,'be939895-1e38-4eff-a5a9-36eeab04cb1a','192.168.136.1','内网IP|内网IP','Windows 10','Chrome 89.0.4389.90','2021-04-26 10:24:19','2021-05-11 22:13:27',101,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36'),(8,'691475fd-eebf-363b-8bc3-a43d3b4c0346','192.168.136.1','内网IP|内网IP','Windows 10','Chrome 89.0.4389.90','2021-05-16 21:21:36','2021-05-16 21:21:36',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36'),(9,'865cff8b-8b17-3508-9c9d-2f441c461095','10.22.197.127','内网IP|内网IP','Windows 10','Edge 128.0.0.0','2024-08-27 10:35:43','2024-08-27 10:35:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0');
/*!40000 ALTER TABLE `visitor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-27 20:12:57
