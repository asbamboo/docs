.. _console:

控制台组件[Console]
===============================

控制台组件用于创建命令行程序。命令行程序可以用来处理任何经常发生的任务，如crontab定时任务，或者其他的批量操作。


如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/console
    
#. 从 https://github.com/asbamboo/console 获取。

如何使用？
-------------------------

#. 创建命令行工具（假设文件名为./bin/console）

    ::
    
        #!/usr/bin/env php
        <?php
        
        use asbamboo\console\Processor;
        
        require_once __DIR__ . '/vendor/autoload.php';
    
        new asbamboo\autoload\Autoload();
        
        $Processor  = new Processor();
        $Processor->exec();

#. 创建命令行程序
    #. 添加一个类，必须是asbamboo\\console\\command\\CommandInterface的实例，可以使用抽象类asbamboo\\console\\command， 例如系统内置的命令行程序asbamboo:console:lists
        ::
        
            namespace asbamboo\console\command;

            use asbamboo\console\ProcessorInterface;
            use asbamboo\console\Constant;
            
            /**
             * 列出所有命令行程序
             *
             * @author 李春寅 <licy2013@aliyun.com>
             * @since 2018年7月31日
             */
            class ListsCommand extends CommandAbstract
            {
                /**
                 * 命令行程序被执行时的入口方法
                 */
                public function exec(ProcessorInterface $Processor)
                {
                    ...
                }
            
                /**
                 * 命令行程序简单描述，在列出所有命令行程序的列表中会显示这个方法的返回值
                 */
                public function desc() : string
                {
                    ...
                }
            
                /**
                 * 命令行程序的帮助信息。使用选项 --help 可以查看帮助信息
                 */
                public function help() : string
                {
                    ...
                }
            }

        除了上面ListsCommand列出的三个方法意外，命令行程序CommandInterface还有其他两个必须的方法

            #. options 方法，返回命令行程序的所有选项。如运行下面的命令行程序，其中"--help"就是选项:

                ::
                
                    ./bin/console asbamboo:console:lists --help 

            #. arguments 方法, 返回命令行程序的所有参数。如运行下面的命令行程序，其中"asbamboo:console:lists"就是参数:

                ::

                    ./bin/console asbamboo:console:help asbamboo:console:lists

        如果使用抽象方法CommandAbstract，那么:

            #. 可以通过AddOption添加设置，命令行程序的可选的选项。该方法按顺序有几下几个参数：
                #. $name 选项名称，必须，通过 --{$name} 使用
                #. $default_value, 默认值，可选。
                #. $desc, 可选，选项的描述信息
                #. $short_name, 选项简称，可选，通常是一个字母，通过 -{$n} 使用

            #. 可以通过getOptionValueByProcessor获取用户输入的选项信息，该方法按顺序有几下几个参数：
                #. $option_name 选项的名称，如果用户没输入选项，返回null。如果用户输入了选项，默认值是true。
                #. $Processor asbamboo\console\Processor的实例。

            #. 可以通过addArgument添加设置，命令行程序的参数。该方法按顺序有几下几个参数：
                #. $name 参数名称， 必须。
                #. $desc 用于帮助信息的参数说明，必须。
                #. $default_value 默认值， 可选。
                #. $position 在所有参数中位于第几个（从0开始）可选。默认自动增加。
                #. $is_require说明该参数是否必须

            #. 可以通过getArgumentValueByProcessor获取用户输入的参数信息，该方法按顺序有几下几个参数：
                #. $argument_name 参数的名称。
                #. $Processor asbamboo\console\Processor的实例。

    #. 将这个新的命令行程序, 注册到控制台模块的处理器:
    
        ::

            ...
            $Processor  = new Processor();
            $Processor->commandCollection()->add('asbamboo:console:lists', 'asbamboo\console\command\ListsCommand'); //第一个参数是命令行程序名称，第二个参数是命令行程序运行的类名。
            $Processor->exec();
    
#. 使用命令行程序
    #. 命令行工具（可执行文件） 命令行程序名称 命令行程序的各个参数 命令行程序的各个选项。如：

    ::

        ./bin/console asbamboo:console:lists --help
        ./bin/console asbamboo:console:lists -h
        ./bin/console asbamboo:console:help asbamboo:console:lists -q

#. 命令行程序内获取用户输入信息
    #. 命令行程序的入口方法是exec方法，该方法接收$Processor变量。
    #. $Processor->input()获取用户的输入信息。
        #. $Processor->input()->options() 获取用户输入的选项信息。
        #. $Processor->input()->arguments() 获取用户输入的参数信息。
        #. $Processor->input()->shortOptions() 获取用户输入的简短选项信息。
        #. $Processor->input()->prompt($title) 与用户交互，提示用户输入信息。$title告诉用户输入的信息标题。
    

#. 用户交互输出


    

.. _composer: https://getcomposer.org/