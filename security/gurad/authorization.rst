.. _security_gurad_authorization:

权限设置
=====================

asbamboo\\security\\gurad\\authorization\\Authenticator用来控制访问权限。

没有权限时抛出异常asbamboo\\security\\exception\\AccessDeniedException。

权限规则设置
---------------------------

#. 访问规则
    
    一个访问规则是一个asbamboo\\security\\gurad\\authorization\\Rule实例。
    
    ::
       
        <?php
            use asbamboo\security\gurad\authorization\Rule;
            
            /*
             * 表达式$expression时字符串，表示一段是php可执行的脚本。
             * 表达式$expression可以使用变量$user和$request
             *  - $user 是发起当前请求的用户[asbamboo\security\user\token\UserToken::getUser()]
             *  - $request 是当前请求[asbamboo\http\ServerRequest]
             *  - ex:限制只能是管理员才能访问[$expression = 'in_array('admin', $user->getRoles())';]
             */ 
            $expression = "1==2"; 
            new Rule($expression);

#. 访问规则集合 asbamboo\\security\\gurad\\authorization\\RuleCollection。

    RuleCollection是asbamboo\\security\\gurad\\authorization\\Rule的集合，通过RuleCollection::add方法添加访问规则

    ::
        
        <?php

            use asbamboo\security\gurad\authorization\Rule;
            use asbamboo\security\gurad\authorization\RuleCollection;
            
            $RuleCollection = new RuleCollection();
            $RuleCollection->add(new Rule('1==1'));
            $RuleCollection->add(new Rule('1==2'));

权限使用
------------------------

asbamboo\\security\\gurad\\authorization\\Authenticator::validate方法会循环方法规则集合[RuleCollection],将所有访问规则[Rule]的表达式都执行一遍
    
::

    <?php
    
    use asbamboo\security\gurad\authorization\RuleCollection;
    use asbamboo\security\gurad\authorization\Authenticator;
    
    $RuleCollection = new RuleCollection();
    
    .....
    
    $Authenticator  = new Authenticator($RuleCollection);
    $authenticator->validate($User, $Request);