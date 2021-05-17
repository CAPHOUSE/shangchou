<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="css/pagination.css">
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="crowd/my-role.js"></script>
<script type="text/javascript">

	$(function () {

	//	为分页操作准备初始化数据
		window.pageNum = 1;
		window.pageSize = 5;
		window.keyword = "";

	//	调用执行分页的函数
		generatePage();

	//	给查询按钮绑定函数
		$("#searchBtn").click(function () {
		//	获取关键词
			window.keyword = $("#keywordInput").val();
		//	调用函数刷新页面
			generatePage();
		})

	//	点击新增按钮显示模态框
		$("#showAddModelBtn").click(function () {
			$("#addModal").modal("show")
		});


	//	给新增绑定函数
		$("#saveRoleBtn").click(function () {

		//	获取用户输入是角色名称
			var roleName = $.trim($("#addModal [name=roleName]").val());

		//	发送ajax请求
			$.ajax({
				url: "role/save.json",
				type: "post",
				data: {
					"name": roleName
				},
				dataType: "json",
				success: function (response) {
					var result = response.result;

					if (result == "SUCCESS"){
						layer.msg("操作成功!");
						//重新加载分页数据
						window.pageNum = 9999999;
						generatePage();
					}
					if (result == "FAILED"){
						layer.msg("操作失败!" + response.message);
					}
				},
				error: function (response) {
					layer.msg(response.status+ ' ' +response.statusText)
				}
			});

			//关闭模态框
			$("#addModal").modal("hide");

			//清理模态框
			$("#addModal [name=roleName]").val("");
		});

		//绑定修改事件
		$("#rolePageBody").on("click",".pencilBtn",function () {

			$("#editModal").modal("show");
		//	获取当前行的角色名称
			var roleName = $(this).parent().prev().text();

		//	获取当前角色的id
			window.roleId = this.id;
		//	回显数据
			$("#editModal [name=roleName]").val(roleName)
		});

	//	绑定函数，执行更新事件
		$("#updateRoleBtn").click(function () {
			//获取文本框的角色名称
			var roleName = $("#editModal [name=roleName]").val();

			$.ajax({
				url: "role/update.json",
				type: "post",
				data: {
					"id":window.roleId,
					"name":roleName
				},
				dataType: "json",
				success: function (response) {

					var result = response.result;

					if (result == "SUCCESS"){
						layer.msg("操作成功!");
						//	重新加载分页
						generatePage();
					}
					if (result == "FAILED"){
						layer.msg("操作失败!"+response.message)
					}

				},
				error: function (response) {
					layer.msg(response.status+ " " + response.statusText);
				}
			});

		//	关闭模态框
			$("#editModal").modal("hide");
		});

	//	点击删除按钮
		$("#removeRoleBtn").click(function(){
			// 从全局变量范围获取roleIdArray，转换为JSON字符串
			var requestBody = JSON.stringify(window.roleIdArray);
			$.ajax({
				url: "role/remove/by/role/id/array.json",
				type: "post",
				data: requestBody,
				contentType: "application/json;charset=UTF-8",
				dataType:" json",
				success: function(response){
					var result = response.result;

					if(result == "SUCCESS") {
						layer.msg("操作成功！");

						// 重新加载分页数据
						generatePage();
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
			$("#confirmModal").modal("hide");

		});

		// 9.给单条删除按钮绑定单击响应函数
		$("#rolePageBody").on("click",".removeBtn",function(){

			// 从当前按钮出发获取角色名称
			var roleName = $(this).parent().prev().text();

			// 创建role对象存入数组
			var roleArray = [{
				roleId:this.id,
				roleName:roleName
			}];

			// 调用专门的函数打开模态框
			showConfirmModel(roleArray);
		});

	//	给总的checkbox绑定点击响应函数
		$("#summaryBox").click(function () {

		//	获取当前多选框的状态
			var currentStatus = this.checked;

		//	用当前多选框的状态设置其他多选框
			$(".itemBox").prop("checked",currentStatus);
		});

	//	全选和全不选的状态设置
		$("#rolePageBody").on("click",".itemBox",function(){

		//	获取已经选择的数量
			var CheckBoxCount = $(".itemBox:checked").length;
		//	获取全部itemBox的数量
			var totalBoxCount = $(".itemBox").length;
		// 比较
			$("#summaryBox").prop("checked",CheckBoxCount == totalBoxCount)
		});

	//给批量删除绑定函数
		$("#batchRemoveBtn").click(function () {

			var roleArray = [];
		//	遍历选中的
			$(".itemBox:checked").each(function () {
			//	使用this引用当前遍历到的多选框
				var roleId = this.id;
			//	获取角色名称
				var roleName = $(this).parent().next().text();

				roleArray.push({
					"roleId": roleId,
					"roleName": roleName
				});
			});
		//	检查roleArray的长度是否为0
			if (roleArray.length == 0){
				layer.msg("请至少选择一个执行删除!");
				return;
			}
		//	调用专门的函数打开模态框
			showConfirmModel(roleArray);

		//	清除上一个全选
			var checkBoxStatus = !$("#summaryBox:checkbox");
			$("#summaryBox").prop("checked",checkBoxStatus)
		});

		//给分配权限按钮绑定函数
		$("#rolePageBody").on("click",".checkBtn",function () {

			window.roleId = this.id;
			//打开模态框
			$("#assignModal").modal("show");

			//在模态框中装载Auth树形结构数据
			fillAuthTree();
		});

	//	给分配权限模态框设置点击事件
		$("#assignBtn").click(function () {

		//	声明一个数组存放id
			var authIdArray = [];
		//	获取zTreeObj的对象
			var zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
		//	获取全部被勾选的节点
			var checkNodes = zTreeObj.getCheckedNodes();
		//	遍历
			for (var i = 0; i < checkNodes.length; i++) {
				var checkNode = checkNodes[i];

				var authId = checkNode.id;

				authIdArray.push(authId);
			}
		//	发送请求执行分配
			var requestBody = {
				"authIdArray": authIdArray,
				//统一设置成数组
				"roleId": [window.roleId]
			};

			requestBody = JSON.stringify(requestBody);

			$.ajax({
				url: "assign/do/role/assign/auth.json",
				type: "post",
				data: requestBody,
				contentType: "application/json;charset=utf-8",
				dataType:"json",
				success: function (response) {
					var result = response.result;

					if (result == "SUCCESS"){
						layer.msg("操作成功!")
					}
					if (result == "FAILED"){
						layer.msg("操作失败!"+ response.message);
					}
				},
				error: function (response) {
					layer.msg(response.status + " " +response.statusText);
				}
			});

			$("#assignModal").modal("hide");
		})

	})
</script>

<body>

	<%@ include file="/WEB-INF/include-nav.jsp" %>
	<div class="container-fluid">
		<div class="row">
			<%@ include file="/WEB-INF/include-sidebar.jsp" %>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
					</div>
					<div class="panel-body">
						<form class="form-inline" role="form" style="float:left;">
							<div class="form-group has-feedback">
								<div class="input-group">
									<div class="input-group-addon">查询条件</div>
									<input id="keywordInput" class="form-control has-success" type="text" placeholder="请输入查询条件">
								</div>
							</div>
							<button type="button" class="btn btn-warning" id="searchBtn">
								<i class="glyphicon glyphicon-search"></i>
								查询</button>
						</form>
						<button id="batchRemoveBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;">
							<i class=" glyphicon glyphicon-remove">
							</i> 删除</button>
						<button type="button" class="btn btn-primary" style="float:right;" id="showAddModelBtn"><i class="glyphicon glyphicon-plus"></i> 新增</button>
						<br>
						<hr style="clear:both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
								<tr>
									<th width="30">#</th>
									<th width="30"><input id="summaryBox" type="checkbox"></th>
									<th>名称</th>
									<th width="100">操作</th>
								</tr>
								</thead>
								<tbody id="rolePageBody">

								</tbody>
								<tfoot>
								<tr>
									<td colspan="6" align="center">
										<div class="pagination" id="Pagination"><!--显示分页--></div>
									</td>
								</tr>

								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@include file="/WEB-INF/modal-role-add.jsp" %>
	<%@include file="/WEB-INF/modal-role-edit.jsp" %>
	<%@include file="/WEB-INF/modal-role-confirm.jsp" %>
	<%@include file="/WEB-INF/modal-role-assign-auth.jsp" %>

</body>
</html>