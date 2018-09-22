.. framework_guide_admincmd

开始第一个命令行程序[admin管理工具]
=======================================

在 `asbamboo/framework-strandard`_ 中，添加命令行程序只需要在 ./command 目录下创建相应的脚本文件。命令行程序 `console`_ 入口文件会解析该目录下的脚本文件，并将这个脚本注册到命令行程序服务中去。

创建AdminCommand文件
----------------------------

路径: /asbamboo-study/command/AdminCommand.php

::

    <?php
    namespace asbamboo\frameworkStandard\command;
    
    use asbamboo\console\ProcessorInterface;
    use asbamboo\console\command\CommandAbstract;
    use asbamboo\di\ContainerAwareTrait;
    use asbamboo\framework\Constant;
    use asbamboo\database\Factory;
    use asbamboo\frameworkStandard\model\user\UserEntity;
    use asbamboo\frameworkStandard\model\user\Constant AS UserConstant;
    use asbamboo\database\FactoryInterface;
    use asbamboo\database\ManagerInterface;
    
    class AdminCommand extends CommandAbstract
    {
        use ContainerAwareTrait;
    
        /**
         *
         * @var ManagerInterface
         */
        private $DbManager;
    
        /**
         *
         * @param FactoryInterface $Db
         */
        public function __construct(FactoryInterface $Db)
        {
            parent::__construct();
            $this->DbManager   = $Db->getManager();
            $this->AddOption('list', null, '列出所有管理员账号', 'l');
            $this->AddOption('insert', null, '添加新的管理员账号', 'i');
        }
    
        /**
         * 列出所有管理员账号
         *
         * @param ProcessorInterface $Processor
         */
        private function lists(ProcessorInterface $Processor) : void
        {
            /**
             *
             * @var Factory $Db
             */
            $UserEntitys    = $this->DbManager->getRepository(UserEntity::class)->findBy(['user_type' => UserConstant::TYPE_ADMIN]);
            foreach($UserEntitys AS $UserEntity){
                $Processor->output()->print($UserEntity->getUserId(), "\t");
            }
        }
    
        /**
         * 创建新的管理员账号
         *
         * @param ProcessorInterface $Processor
         */
        private function insert(ProcessorInterface $Processor) : void
        {
            /**
             * 用户输入参数
             */
            $user_id            = $Processor->input()->prompt('请输入管理员账号:');
            $user_password      = $Processor->input()->prompt('请输入管理员密码:');
            $confirm_password   = $Processor->input()->prompt('请确认管理员密码:');
    
            /**
             * 验证
             */
            check:
            if($user_password != $confirm_password){
                $Processor->output()->print('两次密码输入不一致,请重新确认。', "\r\n");
                $user_password      = $Processor->input()->prompt('请输入管理员密码:');
                $confirm_password   = $Processor->input()->prompt('请确认管理员密码:');
                goto check;
            }
    
            /**
             * 管理员实例
             *
             * @var \asbamboo\frameworkStandard\model\user\UserEntity $UserEntity
             */
            $UserEntity         = new UserEntity();
            $UserEntity->setUserId($user_id);
            $UserEntity->setUserPassword($confirm_password);
            $UserEntity->setUserType(UserConstant::TYPE_ADMIN);
    
            /**
             *
             * @var Factory $Db
             */
            $this->DbManager->persist($UserEntity);
            $this->DbManager->flush();
            $Processor->output()->print('管理员添加成功', "\r\n");
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\console\command\CommandInterface::exec()
         */
        public function exec(ProcessorInterface $Processor)
        {
            if($this->getOptionValueByProcessor('list', $Processor)){
                return $this->lists($Processor);
            }
            if($this->getOptionValueByProcessor('insert', $Processor)){
                return $this->insert($Processor);
            }
            return $this->insert($Processor);
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\console\command\CommandInterface::desc()
         */
        public function desc() : string
        {
            return '管理员账号管理';
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\console\command\CommandInterface::help()
         */
        public function help() : string
        {
            $console    = $_SERVER['SCRIPT_FILENAME'];
    
            return <<<HELP
        注意:选项insert和list不能同时使用,如果命令行不带任何参数，则表示省略insert选项。
        例: 添加新的管理员账号
            php {$console} {$this->getName()} --insert
            php {$console} {$this->getName()}
        例: 管理员账号列表
            php {$console} {$this->getName()} --list
    
    HELP;
        }
    
        /**
         * 定义命令行名称
         *
         * @return string
         */
        public function getName() : string
        {
           return 'admin';
        }
    }

构造函数__construct说明
-------------------------------

这个命令行脚本文件继承了抽象类asbamboo\\console\\command\\CommandAbstract，有两个重要的方法
    * addOption 添加可选选项列表
    * addArgument 添加参数列表

构造函数通常应该通过调用这两个方法为脚本添加参数列表和选项列表

AdminCommand中添加了选项列表

    * list 没有默认值 列出所有管理员账号 简写形式 l
    * insert 没有默认值 添加新的管理员账号 简写形式 i

脚本文件的方法说明
----------------------------------------

#. getName 命令行脚本程序的名称

#. help 命令行脚本程序的帮助详情信息[./bin/console admin --help] 会展示admin脚本的帮助信息

#. desc 命令行脚本程序的简要说明[./bin/console asbamboo:console:lists] 会展示简要说明

#. exec 这样是重要方法，脚本执行时调用的方法。可以从参数$Processor中获取输入信息,和处理结果输出。

#. getOptionValueByProcessor 这个方法从CommandAbstract继承用来获取选项的值

#. getArgumentValueByProcessor 这个方法也是从CommandAbstract继承用来获取参数的值

脚本执行
---------------------------

#. ./bin/console admin -h 查看帮助信息

#. ./bin/console admin -i 添加新的管理员

#. ./bin/console admin -l 列出管理员名单


系统初始化脚本程序
-----------------------------------------------

::

    <?php
    namespace asbamboo\frameworkStandard\command;
    
    use asbamboo\console\ProcessorInterface;
    use asbamboo\console\command\CommandAbstract;
    use asbamboo\di\ContainerAwareTrait;
    use asbamboo\framework\Constant;
    use asbamboo\database\ManagerInterface;
    use asbamboo\database\FactoryInterface;
    
    class InitCommand extends CommandAbstract
    {
        use ContainerAwareTrait;
    
        /**
         *
         * @var ManagerInterface
         */
        private $DbManager;
    
        /**
         *
         * @param FactoryInterface $Db
         */
        public function __construct(FactoryInterface $Db)
        {
            parent::__construct();
            $this->DbManager   = $Db->getManager();
        }
    
        /**
         * 删除数据信息
         *
         * @param ProcessorInterface $Processor
         */
        private function dropDbData(ProcessorInterface $Processor) : void
        {
            /**
             *
             * @var Factory $Db
             */
            $this->DbManager->getConnection()->exec("
                DROP TABLE IF EXISTS `t_user`;
            ");
            $this->DbManager->getConnection()->exec("
                DROP TABLE IF EXISTS `t_post`;
            ");
        }
    
        /**
         * 创建初始数据表
         *
         * @param ProcessorInterface $Processor
         */
        private function createDbData(ProcessorInterface $Processor) : void
        {
            /**
             *
             * @var Factory $Db
             */
            $this->DbManager->getConnection()->exec("
                CREATE TABLE `t_user`(`user_seq` INTEGER PRIMARY KEY, `user_id`, `user_password`, `user_type`);
            ");
            $this->DbManager->getConnection()->exec("
                CREATE TABLE `t_post`(`post_seq` INTEGER PRIMARY KEY, `post_title`, `post_content`, `user_seq`, `post_create_time`, `post_update_time`);
            ");
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\console\command\CommandInterface::exec()
         */
        public function exec(ProcessorInterface $Processor)
        {
            if($Processor->input()->prompt('初始化将导致以后数据被清除，你确定要初始化系统吗?请回复yes或no: ') == 'yes'){
                $Processor->output()->print('正在删除原有数据信息...', "\r\n");
                $this->dropDbData($Processor);
                $Processor->output()->print('正在重新创建初始数据信息...', "\r\n");
                $this->createDbData($Processor);
                $Processor->output()->print('系统初始化成功.', "\r\n");
            }
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\console\command\CommandInterface::help()
         */
        public function help(): string
        {
            $console    = $_SERVER['SCRIPT_FILENAME'];
    
            return <<<HELP
        例: php {$console} {$this->getName()}
    
    HELP;
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\console\command\CommandInterface::desc()
         */
        public function desc(): string
        {
            return '系统初始化';
        }
    
        /**
         * 定义命令行名称
         *
         * @return string
         */
        public function getName() : string
        {
            return 'init';
        }
    }

.. _asbamboo/framework-strandard: https://github.com/asbamboo/framework-strandard
.. _`console`: command