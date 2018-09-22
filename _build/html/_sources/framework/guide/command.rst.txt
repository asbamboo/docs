.. framework_guide_command

命令行程序的使用
========================

在 `asbamboo/framework-strandard`_ 中命令行程序的入口文件会将./command目录下的脚本当做的命令行程序 

./bin/console

::

    #!/usr/bin/env php
    <?php
    namespace asbamboo\frameworkDemo\bin;
    
    ...
         
    EventScheduler::instance()->bind(Event::KERNEL_CONSOLE_PRE_EXEC, function(KernelInterface $Kernel){
        ....
    });
    
    (new Console())->run(new AppKernel($debug = true));

console会通过监听 kernel.console.pre.exec 事件, 将./command目录下的命令行程序注册到服务 asbamboo\\console\\ProcessorInterface。(new Console())->run(new AppKernel($debug = true))中将执行 asbamboo\\console\\ProcessorInterface::exec()方法

`请参阅命令行程序模块`: `asbamboo/console`_

.. _asbamboo/framework-strandard: https://github.com/asbamboo/framework-strandard
.. _asbamboo/console: ../../console/index