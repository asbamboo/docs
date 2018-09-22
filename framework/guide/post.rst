.. framework_guide_post

创建文章管理的http处理程序
================================

现在我们先添加一个文章管理的增删该查程序。该程序通过操作asbamboo\\frameworkStandard\\model\\post管理文章数据

创建Controller文件
--------------------------------------

::

    <?php
    namespace asbamboo\frameworkStandard\controller;
    
    use asbamboo\framework\controller\ControllerAbstract;
    use asbamboo\http\ResponseInterface;
    use asbamboo\frameworkStandard\model\user\UserEntity;
    use asbamboo\frameworkStandard\model\post\PostEntity;
    use asbamboo\frameworkStandard\model\user\UserRepository;
    use asbamboo\database\FactoryInterface;
    use asbamboo\security\user\token\UserTokenInterface;
    use asbamboo\database\ManagerInterface;
    use asbamboo\http\ServerRequestInterface;
    
    /**
     *
     * @author 李春寅 <licy2013@aliyun.com>
     * @since 2018年9月3日
     */
    class Post extends ControllerAbstract
    {
        /**
         *
         * @var ManagerInterface
         * @var UserTokenInterface
         * @var ServerRequestInterface
         */
        private $DbManager, $UserToken, $Request;
    
        /**
         *
         * @param FactoryInterface $Db
         * @param UserTokenInterface $UserToken
         * @param ServerRequestInterface $Request
         */
        public function __construct(FactoryInterface $Db, UserTokenInterface $UserToken, ServerRequestInterface $Request)
        {
            $this->DbManager    = $Db->getManager();
            $this->UserToken    = $UserToken;
            $this->Request      = $Request;
        }
    
        /**
         *
         * @return ResponseInterface
         */
        public function index() : ResponseInterface
        {
            $PostEntitys    = $this->DbManager->getRepository(PostEntity::class)->findBy([
                'User' => $this->UserToken->getUser()->getUserSeq()],
                ['post_update_time' => 'DESC']
            );
            return $this->view([ 'PostEntitys' => $PostEntitys]);
        }
    
        /**
         *
         * @return ResponseInterface
         */
        public function create() : ResponseInterface
        {
            $error_message  = '';
            try
            {
                /**
                 * @var UserRepository $UserRepository;
                 */
                $post_title             = $this->Request->getPostParam('post_title');
                $post_content           = $this->Request->getPostParam('post_content');
                $UserRepository         = $this->DbManager->getRepository(UserEntity::class);
                $UserEntity             = $UserRepository->find($this->UserToken->getUser()->getUserSeq());
                $PostEntity             = new PostEntity();
    
                if($this->Request->getMethod() == 'POST'){
                    if(empty($post_title)){
                        throw new \InvalidArgumentException('请输入文章标题。');
                    }
    
                    if(empty($post_content)){
                        throw new \InvalidArgumentException('请输入文章内容。');
                    }
    
                    $PostEntity->setPostTitle($post_title);
                    $PostEntity->setPostContent($post_content);
                    $PostEntity->setUser($UserEntity);
    
                    $this->DbManager->persist($PostEntity);
                    $this->DbManager->flush();
                    return $this->redirect('post');
                }
            }catch(\Exception $e){
                $error_message  = $e->getMessage();
            }
    
            return $this->view(['error_message' => $error_message]);
        }
    
        /**
         *
         * @return ResponseInterface
         */
        public function update($post_seq) : ResponseInterface
        {
            $error_message  = '';
            try
            {
                /**
                 * @var PostEntity $PostEntity
                 * @var UserRepository $UserRepository;
                 */
                $post_title             = $this->Request->getPostParam('post_title');
                $post_content           = $this->Request->getPostParam('post_content');
                $UserRepository         = $this->DbManager->getRepository(UserEntity::class);
                $UserEntity             = $UserRepository->find($this->UserToken->getUser()->getUserSeq());
                $PostRepository         = $this->DbManager->getRepository(PostEntity::class);
                $PostEntity             = $PostRepository->find($post_seq);
    
                if($this->Request->getMethod() == 'POST'){
                    if(empty($post_title)){
                        throw new \InvalidArgumentException('请输入文章标题。');
                    }
    
                    if(empty($post_content)){
                        throw new \InvalidArgumentException('请输入文章内容。');
                    }
    
                    if($PostEntity->getUser()->getLoginName() != $this->UserToken->getUser()->getLoginName()){
                        throw new \InvalidArgumentException('只能编辑自己发布的文章内容。');
                    }
    
                    $PostEntity->setPostTitle($post_title);
                    $PostEntity->setPostContent($post_content);
                    $PostEntity->setPostUpdateTime(time());
    
                    $this->DbManager->persist($PostEntity);
                    $this->DbManager->flush();
                    return $this->redirect('post');
                }
            }catch(\Exception $e){
                $error_message  = $e->getMessage();
            }
    
            return $this->view(['PostEntity' => $PostEntity, 'error_message' => $error_message]);
        }
    
        /**
         *
         * @return ResponseInterface
         */
        public function delete() : ResponseInterface
        {
            $post_seq               = $this->Request->getPostParam('post_seq');
            $PostRepository         = $this->DbManager->getRepository(PostEntity::class);
            $PostEntity             = $PostRepository->find($post_seq);
    
            if($this->Request->getMethod() == 'POST'){
                if($PostEntity->getUser()->getLoginName() != $this->UserToken->getUser()->getLoginName()){
                    throw new \InvalidArgumentException('只能删除自己发布的文章内容。');
                }
                $this->DbManager->remove($PostEntity);
                $this->DbManager->flush();
                return $this->redirect('post');
            }
        }
    }

创建视图文件
------------------------------

默认情况下在模板目录中查找与controller class:method对应的视图文件。

./view/post/create.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    
    {% block content %}
        <div class="container">
            {% if error_message %}
                <div class="alert alert-danger" role="alert">{{ error_message }}</div>
            {% endif %}
            <form method="post">
              <h1 class="h3 mb-3 font-weight-normal">创建新文章</h1>
              <div class="form-group">
                <label for="post_title">标题</label>
                <input type="text" class="form-control" name="post_title" id="post_title" placeholder="请输入文章标题">
              </div>
              <div class="form-group">
                <label for="post_content">内容</label>
                <textarea class="form-control" name="post_content" id="post_content" rows="20" placeholder="请输入文章内容"></textarea>
              </div>
              <button type="submit" class="btn btn-primary">提交表单</button>
            </form>
        </div>
    {% endblock %}


./view/post/index.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    
    {% block content %}
    <div class="container">
    	<div>
    	    <a href="{{ path('post_create') }}" class="btn btn-link">添加文章</a>
    	</div>
    	<div>
    	    <table class="table">
    	      <thead>
    	        <tr>
    	          <th scope="col">#</th>
    	          <th scope="col">标题</th>
    	          <th scope="col">时间</th>
    	          <th scope="col">操作</th>
    	        </tr>
    	      </thead>
    	      <tbody>
    	        {% for PostEntity in PostEntitys %}
    	            <tr>
    	              <th>{{ loop.index }}</th>
    	              <td>{{ PostEntity.getPostTitle() }}</td>
    	              <td>{{ PostEntity.getPostUpdateTime()|date('Y-m-d H:i:s') }}</td>
    	              <td>          
    	                  <a href="{{ path('post_update', {post_seq: PostEntity.getPostSeq()}) }}" class="btn btn-link">编辑</a>
    	                  <form action="{{ path('post_delete') }}" method="post">
    	                    <input type="hidden" name="post_seq" value="{{PostEntity.getPostSeq()}}" />
    	                    <button type="submit" class="btn btn-link">删除</button>      
    	                  </form>
    	              </td>
    	            </tr>            
    	        {% endfor %}
    	      </tbody>
    	    </table>
    	</div>
    </div>
    {% endblock %}

./view/post/update.html.tpl

::

    {% extends '_layout/default.html.tpl' %}

    {% block content %}
        <div class="container">
            {% if error_message %}
                <div class="alert alert-danger" role="alert">{{ error_message }}</div>
            {% endif %}
            <form method="post">
              <h1 class="h3 mb-3 font-weight-normal">编辑文章</h1>
              <div class="form-group">
                <label for="post_title">标题</label>
                <input type="text" class="form-control" name="post_title" id="post_title" value="{{PostEntity.getPostTitle()}}" placeholder="请输入文章标题">
              </div>
              <div class="form-group">
                <label for="post_content">内容</label>
                <textarea class="form-control" name="post_content" id="post_content" rows="15" placeholder="请输入文章内容">{{PostEntity.getPostContent()}}</textarea>
              </div>
              <div class="form-group">
                <label for="post_create_time">创建时间</label>
                <input type="text" class="form-control-plaintext" value="{{PostEntity.getPostCreateTime()|date('Y-m-d')}}" readonly>
              </div>
              <div class="form-group">
                <label for="post_update_time">最后修改</label>
                <input type="text" class="form-control-plaintext" value="{{PostEntity.getPostUpdateTime()|date('Y-m-d')}}" readonly>
              </div>
              <button type="submit" class="btn btn-primary">提交表单</button>
            </form>
        </div>
    {% endblock %}

将新添加的文章管理程序注册到路由服务
-------------------------------------------

./config/router.php

::

    <?php
    return  [
    
        ...
        
        ['id' => 'post', 'path' => '/post' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Post:index'],
        ['id' => 'post_create', 'path' => '/post-create' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Post:create'],
        ['id' => 'post_update', 'path' => '/{post_seq}/post-update' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Post:update'],
        ['id' => 'post_delete', 'path' => '/post-delete' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Post:delete'],

        ...
    ];


将文章管理的入口url添加到公共模板文件中
-------------------------------------------

./view/_include/top.html.tpl

::

        <nav class="navbar navbar-expand-lg navbar-light bg-light rounded">
        ...
        
        <div class="collapse navbar-collapse justify-content-md-center" id="navbarsExample10">
          <ul class="navbar-nav">

            ...
            
            <li class="nav-item {% if is_current('post') %}active{% endif %}">
                <a class="nav-link" href="{{ path('post') }}">文章管理{% if is_current('post') %}<span class="sr-only">(current)</span>{% endif %}</a>
            </li>
          </ul>
        </div>
    </nav>

好了，再访问一下看看吧，发现页面报错了:

::

    服务端无法处理您的请求
    Call to undefined method asbamboo\security\user\AnonymousUser::getUserSeq()
    返回
    Error: Call to undefined method asbamboo\security\user\AnonymousUser::getUserSeq() in /www/asbamboo-study/controller/Post.php:49
    Stack trace:
    #0 [internal function]: asbamboo\frameworkStandard\controller\Post->index()
    #1 /www/asbamboo-study/vendor/asbamboo/router/MatchRequest.php(106): call_user_func_array(Array, Array)
    #2 /www/asbamboo-study/vendor/asbamboo/router/Router.php(97): asbamboo\router\MatchRequest->execute()
    #3 /www/asbamboo-study/vendor/asbamboo/framework/kernel/Http.php(40): asbamboo\router\Router->matchRequest(Object(asbamboo\http\ServerRequest))
    #4 /www/asbamboo-study/public/index.php(11): asbamboo\framework\kernel\Http->run(Object(asbamboo\frameworkStandard\AppKernel))
    #5 {main}

这时因为用户还没有登录，获取不了当前用户的user seq，暂时先这样等后来登录功能完成以后我们再试试。