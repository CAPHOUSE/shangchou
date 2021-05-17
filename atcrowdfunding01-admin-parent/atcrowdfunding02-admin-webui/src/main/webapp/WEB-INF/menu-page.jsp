<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp"%>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="crowd/my-menu.js"></script>
<script type="text/javascript" src="crowd/my-role.js"></script>
<script type="text/javascript">
	$(function () {
		//调用函数初始化数据结构
		generateTree();

		// 给添加子节点按钮绑定单击响应函数
		$("#treeDemo").on("click",".addBtn",function () {

			$("#menuAddModal").modal("show");

			//将当前节点的id作为新节点的pid
			window.pid = this.id;

			return false;
		});

	//	给添加子节点的模态框绑定单击响应函数
		$("#menuSaveBtn").click(function () {

		//	收集表单的数据
			var name = $.trim($("#menuAddModal [name=name]").val());
			var url = $.trim($("#menuAddModal [name=url]").val());
			var icon = $("#menuAddModal [name=icon]:checked").val();

		//	发送ajax请求
			$.ajax({
				url: "menu/save.json",
				type: "post",
				data: {
					"pid": window.pid,
					"name": name,
					"url": url,
					"icon":icon
				},
				dataType: "json",
				success: function (response) {
					var result = response.result;

					if (result == "SUCCESS"){
						layer.msg("操作成功!");
						//刷新树形结构
						generateTree();
					}
					if (result == "FAILED"){
						layer.msg("操作失败!"+ response.message);
					}
				},
				error: function (response) {
					layer.msg(response.status + " " + response.statusText)
				}
			});

			//关闭模态框
			$("#menuAddModal").modal("hide");
			//清空表单
			$("#menuResetBtn").click();
		});

		// 给更新子节点按钮绑定单击响应函数
		$("#treeDemo").on("click",".editBtn",function () {

			//将当前节点的id保存到全局作用域
			window.id = this.id;

			$("#menuEditModal").modal("show");

			//获取zTree对象
			var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");

			//根据id属性查询数据
			var key = "id";
			var value = window.id;
			var currentNode = zTreeObj.getNodeByParam(key,value);

			//回显表单数据
			$("#menuEditModal [name=name]").val(currentNode.name);
			$("#menuEditModal [name=url]").val(currentNode.url);
			$("#menuEditModal [name=icon]").val([currentNode.icon]);

			//回显表单数据
			return false;
		});

		// 给更新模态框中的更新按钮绑定单击响应函数
		$("#menuEditBtn").click(function(){

			// 收集表单数据
			var name = $("#menuEditModal [name=name]").val();
			var url = $("#menuEditModal [name=url]").val();
			var icon = $("#menuEditModal [name=icon]:checked").val();

			// 发送Ajax请求
			$.ajax({
				"url":"menu/update.json",
				"type":"post",
				"data":{
					"id": window.id,
					"name":name,
					"url":url,
					"icon":icon
				},
				"dataType":"json",
				"success":function(response){
					var result = response.result;

					if(result == "SUCCESS") {
						layer.msg("操作成功！");

						// 重新加载树形结构，注意：要在确认服务器端完成保存操作后再刷新
						// 否则有可能刷新不到最新的数据，因为这里是异步的
						generateTree();
					}

					if(result == "FAILED") {
						layer.msg("操作失败！"+response.message);
					}
				},
				"error":function(response){
					layer.msg(response.status+" "+response.statusText);
				}
			});

			// 关闭模态框
			$("#menuEditModal").modal("hide");

		});

	//	给x按钮绑定函数
		$("#treeDemo").on("click",".removeBtn",function () {
			//将当前节点的id保存到全局作用域
			window.id = this.id;

			$("#menuConfirmModal").modal("show");

			//获取zTree对象
			var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");

			//根据id属性查询数据
			var key = "id";
			var value = window.id;
			var currentNode = zTreeObj.getNodeByParam(key,value);

			$("#removeNodeSpan").html("【<i class='"+currentNode.icon+"'></i>" + currentNode.name + "】");

			return false;
		});

	//	删除模态框函数
		$("#confirmBtn").click(function () {
			$.ajax({
				url: "menu/remove.json",
				type: "post",
				data: {
					"id": window.id
				},
				dataType: "json",
				success: function (response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						// 重新加载树形结构，注意：要在确认服务器端完成保存操作后再刷新
						// 否则有可能刷新不到最新的数据，因为这里是异步的
						generateTree();
					}

					if(result == "FAILED") {
						layer.msg("操作失败！"+response.message);
					}
				},
				error: function (repsonse) {
					layer.msg(response.status+" "+response.statusText);
				}
			});
		//	关闭模态框
			$("#menuConfirmModal").modal("hide");
		})
	})


</script>
<body>

	<%@ include file="/WEB-INF/include-nav.jsp"%>
	<div class="container-fluid">
		<div class="row">
			<%@ include file="/WEB-INF/include-sidebar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
						<div style="float: right; cursor: pointer;" data-toggle="modal"
							data-target="#myModal">
							<i class="glyphicon glyphicon-question-sign"></i>
						</div>
					</div>
					<div class="panel-body">
						<!-- 这个ul标签是zTree动态生成的节点所依附的静态节点 -->
						<ul id="treeDemo" class="ztree">

						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%@include file="/WEB-INF/modal-menu-add.jsp" %>
	<%@include file="/WEB-INF/modal-menu-confirm.jsp" %>
	<%@include file="/WEB-INF/modal-menu-edit.jsp" %>
</body>
</html>