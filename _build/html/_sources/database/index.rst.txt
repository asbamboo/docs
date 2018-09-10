.. _database:

数据操作模块[database]
=========================

数据操作模块database, 是一个在 `doctrine`_/orm 的基础上继续开发的模块。
你可以通过 `doctrine`_ 获取相关的使用帮助。


如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/database
    
#. 从 https://github.com/asbamboo/database 获取。

如何使用？
-------------------------

database模块主要有两个类：一个是connection用来创建新的数据库链接，另一个是Factory用来管理数据库链接方面的操作。

::

    <?php

    use Doctrine\DBAL\Driver\Connection;
    use asbamboo\database\Factory;

    // 数据库链接创建方法的第一个参数是数据哭类型，和相关配置。
    // 数据库链接创建方法的第二个参数是指定数据库字段与php实体类的属性之间的mapping关系的文件目录。
    // 数据库链接创建方法的第三个参数是指定数据库字段与php实体类的属性之间的mapping关系的类型。可选的有(annotation，yaml， xml)。
    // 数据库链接创建方法的第四个参数是字段当前是否是开发[dev]模式。
    $Connection_sqlite = Connection::create([
            'driver'    => 'pdo_sqlite',
            'path'      => 'db.sqlite',
    ], metadata_config_path, Connection::MATADATA_ANNOTATION);
    $Connection_mysql = Connection::create([
            'driver'   => 'pdo_mysql',
            'user'     => 'root',
            'password' => '',
            'dbname'   => 'foo'
    ], metadata_config_path, Connection::YAML);

    // 创建好的数据链接器添加到Factory统一管理。
    // 第二个参数是链接的Id，默认值是default
    $DbFactory    = new Factory();
    $Factory->addConnection($Connection_sqlite, 'sqlite');
    $Factory->addConnection($Connection_mysql, 'mysql');

    // 从Factory获取一个链接管理器
    // 方法的参数是上面addConnection对应的id， 默认值是default
    $MysqlManager    = $DbFactory->getManager('mysql');
    $SqliteManager   = $DbFactory->getManager('sqlite');

你可以通过 `asbamboo/framework-demo`_ 参考asbamboo/framework是如何使用这个database模块的。




.. _composer: https://getcomposer.org/
.. _doctrine: https://www.doctrine-project.org/
.. _asbamboo/framework-demo: https://github.com/asbamboo/framework-demo