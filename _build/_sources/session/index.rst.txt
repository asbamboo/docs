.. _session:

SESSION模块[Session]
=============================

SESSION模块的作用主要，管理自定义的session handler。规范统一asbamboo项目中，session相关的代码处理方式。

如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/session
    
#. 从 https://github.com/asbamboo/session 获取。


如何使用？
-------------------------

#. 基本的使用方式

    ::

        $session = new Session(); // 新的session实例
        $session->start(); // 同session_start();
        $session->set('session_key', 'session_value'); // $_SESSION['session_key'] = 'session_value';
        $session->get('session_key'); // $_SESSION['session_key']
        $session->save(); // session_write_close();
        $session->unset(); // unset($_SESSION);

#. 使用session handler
    自定义的session handler需要实现 asbamboo\session\handler\SessionHandlerInterface, 可以参考asbamboo\session\handler\PdoHandler. （请参阅 http://php.net/manual/zh/class.sessionhandler.php )

    ::
    
        $dsn        = 'mysql:host=127.0.0.1;dbname=asbamboo_test';
        $username   = 'root';
        $password   = 'root';
        $PdoHandler = new asbamboo\session\handler\PdoHandler($dsn, $username, $password);
        $session    = new Session($PdoHandler); // 新的session实例

Handler
------------------------------

:doc:`PdoHandler <handler/pdo-handler>`

.. toctree::
    :hidden:

    handler/pdo-handler


.. _composer: https://getcomposer.org/