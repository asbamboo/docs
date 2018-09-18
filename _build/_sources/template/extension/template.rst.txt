.. _template_extension_template:

template extension 示例
============================

::

    <?php
    use asbamboo\template\ExtensionGlobalsInterface;
    use asbamboo\template\Extension;
    use asbamboo\template\Functions;

    class TemplateExtension extends Extension implements ExtensionGlobalsInterface
    {
        public function getGlobals()
        {
            return ['app'=>[
                'user'      => $this->user(),
                'request'   => $this->request(),
                'is_debug'  => $this->isDebug(),
                ...
            ]];
        }

        public function getFunctions()
        {
            return [
                new Functions('path', [$this, 'path']),
                new Functions('is_current', [$this, 'isCurrent']),
                ...
            ];
        }

        ...
    }