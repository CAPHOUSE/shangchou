<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <script type="text/javascript" src="jquery/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="layer/layer.js"></script>
    <script type="text/javascript">
      $(function () {
          $("#btn1").click(function () {
              $.ajax({
                  url: "send/array.html",
                  type: "post",
                  data: {
                    "array":[1,3,5]
                  },
                  dataType: "text",
                  success: function (data) {

                  },
                  error: function (response) {

                  }
              })
          });

          $("#btn2").click(function () {
          $.ajax({
            url: "send/array/two.html",
            type: "post",
            data: {
              "array[0]": 1,
              "array[1]": 4,
              "array[2]": 3
            },
            dataType: "text",
            success: function (data) {

            },
            error: function (response) {

            }
          })
        });

          var array = [1,3,6];
        //  将json数组转换成json字符串
        var requestBody = JSON.stringify(array);

        $("#btn3").click(function () {
          $.ajax({
            url: "send/array/three.html",
            type: "post",
            contentType: "application/json;charset=UTF-8",
            data: requestBody,
            dataType: "text",
            success: function (response) {
              alert(response)
            },
            error: function (response) {

            }
          })
        });

        //准备数据
        var student = {
          "stuId": 5,
          "stuName": "tom",
          "address": {
            "province": "湖南",
            "city": "衡阳",
            "street": "耒阳"
          },
          "subjectList": [
            {
              "subjectName": "Java SE",
              "subjectScore": 100
            },
            {
              "subjectName": "SSM",
              "subjectScore": 98
            }
          ],
          "map": {
              "k1":"v1",
              "k2":"v2",
              "k3":"v3"
          }
        };

        var requestBody = JSON.stringify(student);

        $("#btn4").click(function () {
              $.ajax({
                url: "send/compose/object.json",
                type: "post",
                contentType: "application/json;charset=UTF-8",
                data: requestBody,
                dataType: "json",
                success: function (response) {
                  console.log(response)
                },
                error: function (response) {
                  alert("出错了!")
                }
              })
        })
      })
    </script>
  </head>
  <body>
  <a href="test/ssm.html">参数环境</a>

  <br/>

  <button id="btn1">Send [1,3,6] One</button>

  <br/>

  <button id="btn2">Send [1,2,3] Two</button>

  <br/>

  <button id="btn3">Send [1,3,6] Three</button>

  <br>

  <button id="btn4">Send Object </button>


  <br>

  <a href="/admin/to/login/page.html">登录</a>
  </body>
</html>
