.. framework_guide_user

创建用户管理的http处理程序
================================

现在我们先添加一个用户管理的增删该查程序。该程序通过操作asbamboo\\frameworkStandard\\model\\user管理用户数据


创建Controller文件
--------------------------------------

::

    <?php
    namespace asbamboo\frameworkStandard\controller;
    
    use asbamboo\framework\controller\ControllerAbstract;
    use asbamboo\http\ResponseInterface;
    use asbamboo\http\ServerRequest;
    use asbamboo\framework\Constant;
    use asbamboo\database\Factory;
    use asbamboo\frameworkStandard\model\user\UserEntity;
    use \asbamboo\frameworkStandard\model\user\Constant AS UserConstant;
    use asbamboo\database\FactoryInterface;
    use asbamboo\http\ServerRequestInterface;
    
    class User extends ControllerAbstract
    {
        /**
         *
         * @var FactoryInterface $DbManager
         * @var ServerRequestInterface $Request
         */
        private $DbManager, $Request;
    
        /**
         *
         * @param FactoryInterface $Db
         * @param ServerRequestInterface $Request
         */
        public function __construct(FactoryInterface $Db, ServerRequestInterface $Request)
        {
            $this->DbManager   = $Db->getManager();
            $this->Request      = $Request;
        }
    
        /**
         *
         * @return ResponseInterface
         */
        public function index() : ResponseInterface
        {
            $UserEntitys            = $this->DbManager->getRepository(UserEntity::class)->findBy(['user_type' => UserConstant::TYPE_USER]);
    
            return $this->view([ 'UserEntitys' => $UserEntitys]);
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
                $user_id                = $this->Request->getPostParam('user_id');
                $user_password          = $this->Request->getPostParam('user_password');
                $user_confirm_password  = $this->Request->getPostParam('user_confirm_password');
                $UserEntity             = new UserEntity();
    
                if($this->Request->getMethod() == 'POST'){
                    if(empty($user_id)){
                        throw new \InvalidArgumentException('请输入用户id。');
                    }
    
                    if(empty($user_password)){
                        throw new \InvalidArgumentException('请输入用户密码。');
                    }
    
                    if($user_confirm_password != $user_password){
                        throw new \InvalidArgumentException('两次密码输入不一致。');
                    }
    
                    $UserEntity->setUserId($user_id);
                    $UserEntity->setUserPassword($user_password);
                    $UserEntity->setUserType(UserConstant::TYPE_USER);
    
                    $this->DbManager->persist($UserEntity);
                    $this->DbManager->flush();
                    return $this->redirect('user');
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
        public function update($user_id) : ResponseInterface
        {
            $error_message  = '';
            try
            {
                $user_password          = $this->Request->getPostParam('user_password');
                $user_confirm_password  = $this->Request->getPostParam('user_confirm_password');
                $UserRepository         = $this->DbManager->getRepository(UserEntity::class);
                $UserEntity             = $UserRepository->findOneBy(['user_id' => $user_id]);
    
                if($this->Request->getMethod() == 'POST'){
                    if(empty($user_password)){
                        throw new \InvalidArgumentException('请输入用户密码。');
                    }
    
                    if($user_confirm_password != $user_password){
                        throw new \InvalidArgumentException('两次密码输入不一致。');
                    }
    
                    $UserEntity->setUserPassword($user_password);
                    $UserEntity->setUserType(UserConstant::TYPE_USER);
    
                    $this->DbManager->persist($UserEntity);
                    $this->DbManager->flush();
                    return $this->redirect('user');
                }
            }catch(\Exception $e){
                $error_message  = $e->getMessage();
            }
    
            return $this->view(['UserEntity' => $UserEntity, 'error_message' => $error_message]);
        }
    
        /**
         *
         * @return ResponseInterface
         */
        public function delete() : ResponseInterface
        {
            $user_id                = $this->Request->getPostParam('user_id');
            $UserRepository         = $this->DbManager->getRepository(UserEntity::class);
            $UserEntity             = $UserRepository->findOneBy(['user_id' => $user_id]);
    
            if($this->Request->getMethod() == 'POST'){
                $this->DbManager->remove($UserEntity);
                $this->DbManager->flush();
                return $this->redirect('user');
            }
        }
    }

创建视图文件
------------------------------

默认情况下在模板目录中查找与controller class:method对应的视图文件。

./view/user/create.html.tpl

::

    {% extends '_layout/default.html.tpl' %}

    {% block content %}
        <div class="container">
            {% if error_message %}
                <div class="alert alert-danger" role="alert">{{ error_message }}</div>
            {% endif %}
            <form method="post">
              <h1 class="h3 mb-3 font-weight-normal">编辑用户</h1>
              <div class="form-group">
                <label for="user_id">ID</label>
                <input type="text" class="form-control-plaintext" name="user_id" id="user_id" value="{{UserEntity.getUserId()}}" readonly>
              </div>
              <div class="form-group">
                <label for="user_password">密码</label>
                <input type="password" class="form-control" name="user_password" id="user_password" value="{{UserEntity.getUserPassword()}}" placeholder="请输入用户密码">
              </div>
              <div class="form-group">
                <label for="user_confirm_password">确认密码</label>
                <input type="password" class="form-control" name="user_confirm_password" id="user_confirm_password" value="{{UserEntity.getUserPassword()}}" placeholder="请确认用户密码">
              </div>
              <button type="submit" class="btn btn-primary">提交表单</button>
            </form>
        </div>
    {% endblock %}

./view/user/index.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    
    {% block content %}
    <div class="container">
    	<div>
    	    <a href="{{ path('user_create') }}" class="btn btn-link">添加用户</a>
    	</div>
    	<div>
    	    <table class="table">
    	      <thead>
    	        <tr>
    	          <th scope="col">#</th>
    	          <th scope="col">账号</th>
    	          <th scope="col">操作</th>
    	        </tr>
    	      </thead>
    	      <tbody>
    	        {% for UserEntity in UserEntitys %}
    	            <tr>
    	              <th>{{ loop.index }}</th>
    	              <td>{{ UserEntity.getUserId() }}</td>
    	              <td>          
    	                  <a href="{{ path('user_update', {user_id: UserEntity.getUserId()}) }}" class="btn btn-link">编辑</a>
    	                  <form action="{{ path('user_delete') }}" method="post">
    	                    <input type="hidden" name="user_id" value="{{UserEntity.getUserId()}}" />
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

./view/user/update.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    
    {% block content %}
        <div class="container">
            {% if error_message %}
                <div class="alert alert-danger" role="alert">{{ error_message }}</div>
            {% endif %}
            <form method="post">
              <h1 class="h3 mb-3 font-weight-normal">编辑用户</h1>
              <div class="form-group">
                <label for="user_id">ID</label>
                <input type="text" class="form-control-plaintext" name="user_id" id="user_id" value="{{UserEntity.getUserId()}}" readonly>
              </div>
              <div class="form-group">
                <label for="user_password">密码</label>
                <input type="password" class="form-control" name="user_password" id="user_password" value="{{UserEntity.getUserPassword()}}" placeholder="请输入用户密码">
              </div>
              <div class="form-group">
                <label for="user_confirm_password">确认密码</label>
                <input type="password" class="form-control" name="user_confirm_password" id="user_confirm_password" value="{{UserEntity.getUserPassword()}}" placeholder="请确认用户密码">
              </div>
              <button type="submit" class="btn btn-primary">提交表单</button>
            </form>
        </div>
    {% endblock %}

将新添加的用户管理程序注册到路由服务
-------------------------------------------

./config/router.php

::

    <?php
    return  [
        ...
        
        
        ['id' => 'user', 'path' => '/user' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\User:index'],
        ['id' => 'user_create', 'path' => '/user-create' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\User:create'],
        ['id' => 'user_update', 'path' => '/{user_id}/user-update' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\User:update'],
        ['id' => 'user_delete', 'path' => '/user-delete' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\User:delete'],
        
        ...
    ];

将用户管理的入口url添加到公共模板文件中
-------------------------------------------

./view/_include/top.html.tpl

::

    <nav class="navbar navbar-expand-lg navbar-light bg-light rounded">
        ...
        
        <div class="collapse navbar-collapse justify-content-md-center" id="navbarsExample10">
          <ul class="navbar-nav">

            ...
            
            <li class="nav-item {% if is_current('user') %}active{% endif %}">
                <a class="nav-link" href="{{ path('user') }}">人员管理{% if is_current('user') %}<span class="sr-only">(current)</span>{% endif %}</a>
            </li>
          </ul>
        </div>
    </nav>

好了，再访问下试试吧