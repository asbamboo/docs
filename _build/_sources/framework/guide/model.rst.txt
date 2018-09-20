.. framework_guide_model

建立数据模型
=============

数据模型的建立，依赖 `asbamboo/database`_ 模块。

创建实体类postEntity
-----------------------

::

    <?php
    namespace asbamboo\frameworkStandard\model\post;
    
    use asbamboo\frameworkStandard\model\user\UserEntity;
    
    /**
     * @Entity
     * @Table(name="t_post")
     */
    class PostEntity
    {
        /**
         * @var integer
         *
         * @Id
         * @Column(type="integer")
         * @GeneratedValue
         */
        private $post_seq;
    
    
        /**
         * @var UserEntity
         *
         * @ManyToOne(targetEntity="asbamboo\frameworkStandard\model\user\UserEntity")
         * @JoinColumn(name="user_seq", referencedColumnName="user_seq")
         */
        private $User;
    
        /**
         * @var string
         *
         * @Column(type="string")
         */
        private $post_title;
    
        /**
         * @var string
         *
         * @Column(type="string")
         */
        private $post_content;
    
        /**
         * @var integer
         *
         * @Column(type="integer")
         */
        private $post_create_time;
    
        /**
         *
         * @var integer
         *
         * @Column(type="integer")
         */
        private $post_update_time;
    
    
        /**
         *
         */
        public function __construct()
        {
            $this->post_create_time = time();
            $this->post_update_time = time();
        }
    
        /**
         *
         * @return number
         */
        public function getPostSeq()
        {
            return $this->post_seq;
        }
    
        /**
         *
         * @param UserEntity $user
         * @return \asbamboo\frameworkStandard\model\post\PostEntity
         */
        public function setUser(UserEntity $User)
        {
            $this->User = $User;
            return $this;
        }
    
        /**
         *
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function getUser()
        {
            return $this->User;
        }
    
        /**
         *
         * @param string $post_title
         * @return \asbamboo\frameworkStandard\model\post\PostEntity
         */
        public function setPostTitle(string $post_title)
        {
            $this->post_title   = $post_title;
            return $this;
        }
    
        /**
         *
         * @return string
         */
        public function getPostTitle()
        {
            return $this->post_title;
        }
    
        /**
         *
         * @param string $post_content
         * @return \asbamboo\frameworkStandard\model\post\PostEntity
         */
        public function setPostContent(string $post_content)
        {
            $this->post_content = $post_content;
            return $this;
        }
    
        /**
         *
         * @return string
         */
        public function getPostContent()
        {
            return $this->post_content;
        }
    
        /**
         *
         * @return number
         */
        public function getPostCreateTime()
        {
            return $this->post_create_time;
        }
    
        /**
         *
         * @param int $time
         * @return \asbamboo\frameworkStandard\model\post\PostEntity
         */
        public function setPostUpdateTime(int $time)
        {
            $this->post_update_time  = $time;
            return $this;
        }
    
        /**
         *
         * @return number
         */
        public function getPostUpdateTime()
        {
            return $this->post_update_time;
        }
    }

创建实体类userEntity
------------------------------

::

    <?php
    namespace asbamboo\frameworkStandard\model\user;
    
    /**
     * @Entity
     * @Table(name="t_user")
     */
    class UserEntity
    {
        /**
         * @var int
         *
         * @Id
         * @Column(type="integer")
         * @GeneratedValue
         */
        private $user_seq;
    
        /**
         * @var string
         *
         * @Column(type="string", unique=true)
         */
        private $user_id;
    
        /**
         * @var string
         *
         * @Column(type="string")
         */
        private $user_password;
    
        /**
         * @var int
         *
         * @Column(type="integer")
         */
        private $user_type;
    
        /**
         *
         * @return number
         */
        public function getUserSeq()
        {
            return $this->user_seq;
        }
    
        /**
         *
         * @param string $user_id
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function setUserId(string $user_id)
        {
            $this->user_id = $user_id;
            $this->setLoginName($user_id);
            return $this;
        }
    
        /**
         *
         * @return string
         */
        public function getUserId()
        {
            return $this->user_id;
        }
    
        /**
         *
         * @param string $user_password
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function setUserPassword(string $user_password)
        {
            $this->user_password    = password_hash($user_password, PASSWORD_BCRYPT);
            return $this;
        }
    
        /**
         *
         * @return string
         */
        public function getUserPassword()
        {
            return $this->user_password;
        }
    
        /**
         *
         * @param string $user_type
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function setUserType(string $user_type)
        {
            $this->user_type    = $user_type;
            $this->setRoles([$user_type]);
            return $this;
        }
    
        /**
         *
         * @return number
         */
        public function getUserType()
        {
            return $this->user_type;
        }
    }

创建文件 
-----------------------
./data/db.sqlite

只需要新建一个空的文件就可以，配置文件指定sqlite类型数据库，将数据存储在这个文件中

注册数据库操作配置信息
-----------------------------------------

#. 创建数据库配置信息./config/db.php
    ::

        <?php
        return [
            'connection'    => [
                'driver'    => 'pdo_sqlite',
                'path'      =>  dirname(__DIR__) . '/data/db.sqlite',
            ],'metadata'    => [
                'path'      => dirname(__DIR__) . '/model',
                'type'      => 'annotation',
            ],'is_dev'      => true,
        ];

#. 使用asbamboo\\framework\\config\\DbConfig服务注册数据库配置信息.在主数据库配置文件./config/config.php添加asbamboo\\framework\\config\\DbConfig服务。

    ::
    
        <?php
                
        return [
            ...
            
            DbConfig::class             => ['init_params' => ['configs' => include __DIR__ . DIRECTORY_SEPARATOR . 'db.php']],

            ...
        ];


数据库模型和配置信息设置以后操作方式如下
-----------------------------------------

#. 添加新数据

    ::

        <?php
        
        use asbamboo\database\FactoryInterface;
        
        ...
        
        $UserEntity         = new UserEntity();
        $UserEntity->setUserId($user_id);
        $UserEntity->setUserPassword($confirm_password);
        $UserEntity->setUserType(UserConstant::TYPE_ADMIN);

        $DbManager = $this->container->get(FactoryInterface::class)->getManager();
        $DbManager->persist($UserEntity);
        $DbManager->flush();    

#. 查询列表

    ::

        <?php

        use asbamboo\database\FactoryInterface;
        use asbamboo\frameworkStandard\model\user\UserEntity;

        ...
        
        $DbManager = $this->container->get(FactoryInterface::class)->getManager();
        $DbManager->getRepository(UserEntity::class)->findBy([]);

#. 查询单个数据

    ::

        <?php

        use asbamboo\database\FactoryInterface;
        use asbamboo\frameworkStandard\model\user\UserEntity;

        ...
        
        $DbManager = $this->container->get(FactoryInterface::class)->getManager();
        $DbManager->getRepository(UserEntity::class)->findOneBy(['user_id' => $user_id]);

#. 修改数据

    ::

        <?php

        use \asbamboo\frameworkDemo\model\user\Constant AS UserConstant;
        use asbamboo\database\FactoryInterface;
        use asbamboo\frameworkStandard\model\user\UserEntity;

        ...
        
        $DbManager = $this->container->get(FactoryInterface::class)->getManager();
        $UserEntity = $DbManager->getRepository(UserEntity::class)->findOneBy(['user_id' => $user_id]);
        
        $UserEntity->setUserPassword($user_password);
        $UserEntity->setUserType(UserConstant::TYPE_USER);
        $DbManager->flush();
    

#. 删除数据

    ::

        <?php

        use \asbamboo\frameworkDemo\model\user\Constant AS UserConstant;
        use asbamboo\database\FactoryInterface;
        use asbamboo\frameworkStandard\model\user\UserEntity;

        ...
        
        $DbManager = $this->container->get(FactoryInterface::class)->getManager();
        $UserEntity = $DbManager->getRepository(UserEntity::class)->findOneBy(['user_id' => $user_id]);        
        $DbManager->remove($UserEntity);
        $DbManager->flush();

.. _`asbamboo/database`: ../../database/index
