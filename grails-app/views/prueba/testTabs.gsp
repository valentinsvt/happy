<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/4/13
  Time: 11:48 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Tabs</title>

        <style type="text/css">
        .tabs-cool li a {
            border : solid 1px #dfdfdf;
        }

        .tabs-cool li.active, .tabs-cool li.active a {
            background : #dfdfdf;
        }

        .tabs-cool-content {
            /*margin-top : 15px;*/
            padding : 20px 10px 10px 10px;
            border  : solid 1px #dfdfdf;
            /*border-top : none;*/
        }

        .tabs.cool > li.active > a,
        .tabs.cool > li.active > a:hover,
        .tabs.cool > li.active > a:focus {
            color               : #666666;
            cursor              : default;
            background-color    : #dfdfdf;
            border              : 1px solid #dddddd;
            border-bottom-color : transparent;
        }

        .pointer-container {
            /*background : orange;*/
            border-right : solid 1px #dfdfdf;
            border-left  : solid 1px #dfdfdf;
            width        : 100%;
            height       : 20px;
        }

        .pointer {
            width        : 0px;
            height       : 0px;
            border-style : solid;
            border-width : 20px 10px 0 10px;
            border-color : #dfdfdf transparent transparent transparent;
            position     : absolute;
        }

        </style>
    </head>

    <body>

        <ul class="nav nav-tabs tabs-cool">
            <li class="active">
                <a href="#tab1" data-toggle="tab">Tab 1</a>
            </li>
            <li>
                <a href="#tab2" data-toggle="tab">Tab 2</a>
            </li>
            <li>
                <a href="#tab3" data-toggle="tab">Tab 3</a>
            </li>
        </ul>

        <div class="pointer-container">
            <div class="pointer"></div>
        </div>

        <div class="tab-content tabs-cool-content">
            <div class="tab-pane active" id="tab1">Contenido tab 1</div>

            <div class="tab-pane" id="tab2">Contenido tab 2</div>

            <div class="tab-pane" id="tab3">Contenido tab 3</div>
        </div>

        <script type="text/javascript">

            function move($item) {
                var $pointer = $(".pointer");
                var left = $item.parent().offset().left;
                var width = $item.parent().width();
                var pleft = left + (width / 2) - 10;
                $pointer.animate({left : pleft}, 200);
            }

            function initTab() {
                var $a = $('.tabs-cool').find(".active").children("a");
                move($a);
            }

            $(function () {
                initTab();
                $('.tabs-cool a').click(function (e) {
                    if (!$(this).parent().hasClass("active")) {
                        move($(this));
                    }
                })

            });
        </script>

    </body>
</html>