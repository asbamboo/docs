.. framework_guide_initcmd

创建系统初始化工具[init]命令
==================================

init 命令用来初始化系统程序。负责创建系统所需的数据表，和初始的数据信息。

::

    <?php
    namespace asbamboo\frameworkStandard\command;
    
    use asbamboo\console\ProcessorInterface;
    use asbamboo\console\command\CommandAbstract;
    use asbamboo\di\ContainerAwareTrait;
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

:doc:`命令行脚本文件说明 <command>`

命令的使用
-----------------------------------------

#. ./bin/console init -h 查看帮助
#. ./bin/console init 执行初始化操作
