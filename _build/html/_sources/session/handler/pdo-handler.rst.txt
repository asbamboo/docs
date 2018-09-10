Session PdoHandler
=====================

类名：asbamboo\session\handler\PdoHandler

该类具有两个参数:

    第一个参数$Pdo，传入php里面的Pdo对象，目前PdoHandler仅支持mysql数据库。
    
    第二个参数$options，传入一些配置选项。
    
        默认情况下，这个handler会在数据库中创建一个数据表，表名是session，有三个字段，分别是sid:存session_id，data:存序列化后的session值，time:存的是session写入的事件(会被用在是否过期的判断)。
        
        通过$options值可以改变数据表相关的默认值
            #. $options['table'] session数据表的名称
            #. $options['col_id'] 存放session_id的列名
            #. $options['col_data'] 存放session值的列名
            #. $options['col_time'] 存放session写入时间的列名