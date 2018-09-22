.. framework_guide_admincmd

管理员admin账号管理工具
=======================================

admin 命令程序用于创建和管理系统超级管理员的账号。

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

:doc:`命令行脚本文件说明 <command>`

命令的使用
---------------------------

#. ./bin/console admin -h 查看帮助信息

#. ./bin/console admin -i 添加新的管理员

#. ./bin/console admin -l 列出管理员名单

.. _asbamboo/framework-strandard: https://github.com/asbamboo/framework-strandard
.. _`console`: command