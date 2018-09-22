.. framework_guide_home

在主页显示文章的列表
================================

现在我们将 asbamboo\\frameworkStandard\\model\\post 数据列表展示在主页中

修改controller
-------------------

::

    <?php
    namespace asbamboo\frameworkStandard\controller;
    
    use asbamboo\framework\controller\ControllerAbstract;
    use asbamboo\frameworkStandard\model\post\PostEntity;
    use Doctrine\ORM\EntityRepository;
    use asbamboo\database\FactoryInterface;
    
    class Home extends ControllerAbstract
    {
        /**
         *
         * @var FactoryInterface
         */
        private $Db;
    
        /**
         *
         * @param FactoryInterface $Db
         */
        public function __construct(FactoryInterface $Db)
        {
            $this->Db   = $Db;
        }
    
        /**
         *
         * @return \asbamboo\http\ResponseInterface
         */
        public function index()
        {
            /**
             * @var UserToken $UserToken
             * @var EntityRepository $PostRepository
             */
            $DbManager              = $this->Db->getManager();
            $PostRepository         = $DbManager->getRepository(PostEntity::class);
            $PostEntitys            = $PostRepository->findBy([], ['post_update_time' => 'DESC']);
            return $this->view([ 'PostEntitys' => $PostEntitys]);
        }
    }


修改view
-------------------

./view/home/index.html.tpl

::

    {% extends '_layout/default.html.tpl' %}

    {% block content %}
    <div class="container">
        <hr/>
        {% for PostEntity in PostEntitys %}
            <div>
                <h1>{{ PostEntity.getPostTitle() }}</h1>
                <p>发布人:{{ PostEntity.getUser().getUserId() }} | 发布时间:{{ PostEntity.getPostUpdateTime()|date('Y-m-d H:i:s') }}</p>
                <p>{{ PostEntity.getPostContent() }}</p>
            </div>
            <hr/>
        {% endfor %}
    </div>
    {% endblock %}