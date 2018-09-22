.. framework_guide_command

命令行程序的使用
========================

在 `asbamboo/framework-strandard`_ 中命令行程序的入口文件会将./command目录下的脚本当做的命令行程序, 由入口文件 ./bin/console 解析并且将命令程序注册到命令行程序服务。一般情况下命令行程序脚本文件应该继承 asbamboo\\console\\command\\CommandAbstract

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



构造函数__construct说明使用
-------------------------------

抽象类asbamboo\\console\\command\\CommandAbstract，有两个重要的方法
    * addOption 添加可选选项列表（附参数列表:）
        * $name 选项名称
        * $default_value 默认值， 默认等于null
        * desc 描述信息，默认等于空字符串
        * $short_name 缩略名称
    * addArgument 添加参数列表（附参数列表:）
        * $name 参数名称
        * $desc 描述信息
        * $default_value 默认值，默认等于空字符串
        * $position 位置 表示参数该参数是所有参数里面的第几个，下标从0开始算。默认自动递增的方式添加参数的下标。
        * $is_require 表示参数是否必须。

你应该通过构造函数调用这两个方法为脚本添加参数列表和选项列表。

脚本文件的方法说明
----------------------------------------

#. getName 命令行脚本程序的名称

#. help 命令行脚本程序的帮助详情信息[./bin/console admin --help] 会展示admin脚本的帮助信息

#. desc 命令行脚本程序的简要说明[./bin/console asbamboo:console:lists] 会展示简要说明

#. exec 这样是重要方法，脚本执行时调用的方法。可以从参数$Processor中获取输入信息,和处理结果输出。

#. getOptionValueByProcessor 这个方法从CommandAbstract继承用来获取选项的值

#. getArgumentValueByProcessor 这个方法也是从CommandAbstract继承用来获取参数的值

.. _asbamboo/framework-strandard: https://github.com/asbamboo/framework-strandard
.. _asbamboo/console: ../../console/index