<%@page import="EntityManager.SaleForecastEntity"%>
<%@page import="MRP.SalesAndOperationPlanning.SOP_Helper"%>
<%@page import="EntityManager.StoreEntity"%>
<%@page import="EntityManager.SaleAndOperationPlanEntity"%>
<%@page import="EntityManager.ProductGroupEntity"%>
<%@page import="EntityManager.MonthScheduleEntity"%>
<%@page import="EntityManager.WarehouseEntity"%>
<%@page import="java.util.List"%>
<html lang="en">
    <jsp:include page="../header2.html" />
    <body>

        <script>
            function checkAll(source) {
                checkboxes = document.getElementsByName('delete');
                for (var i = 0, n = checkboxes.length; i < n; i++) {
                    checkboxes[i].checked = source.checked;
                }
            }
        </script>

        <div id="wrapper">
            <jsp:include page="../menu1.jsp" />

            <div id="page-wrapper">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">
                                Sales Forecast
                            </h1>
                            <ol class="breadcrumb">
                                <li>
                                    <i class="icon icon-dashboard"></i>  <a href="../SaleForecast_Servlet/SaleForecast_index_GET">Sales Forecast</a>
                                </li>   
                                <li>
                                    <i class="icon icon-calendar"></i>  <a href="../SaleForecast_Servlet/SaleForecast_schedule_GET">Schedule</a>
                                </li>
                                <li>
                                    <i class="icon icon-list"></i> Dashboard</a>
                                </li>
                            </ol>
                        </div>
                    </div>

                    <div class="row">                             
                        <div class="col-lg-4">
                            <%  StoreEntity store = (StoreEntity) request.getAttribute("store");%>
                            <h4><b> Store:  </b><%= store.getName()%></h4>
                        </div>                                                
                        <div class="col-lg-4">
                            <% MonthScheduleEntity schedule = (MonthScheduleEntity) request.getAttribute("schedule");%>
                            <h4><b> Period: </b><%= schedule.getYear()%> - <%= schedule.getMonth()%> </h4>
                        </div>                                      
                    </div>
                    <br>
                    <!-- /.row -->
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4><b>Product Groups</b></h4>
                                </div>
                                <!-- /.panel-heading -->

                                <div class="panel-body">
                                    <div class="table-responsive">
                                        <div id="dataTables-example_wrapper" class="dataTables_wrapper form-inline" role="grid">                                            
                                            <table class="table table-striped table-bordered table-hover" id="dataTable1">
                                                <thead>
                                                    <tr>
                                                        <th>Product Group Name</th>
                                                        <th>Sales Forecast</th>                                                              
                                                        <th>Forecast Method <i class="icon icon-question-circle" <a href="#myModal" data-toggle="modal"></a></i></th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        List<SaleForecastEntity> saleForecastList = (List<SaleForecastEntity>) request.getAttribute("saleForecastList");
                                                        int index = 0;
                                                        for (SaleForecastEntity s : saleForecastList) {
                                                        index ++;
                                                    %>
                                                    <tr id="<%=index%>">                                                            
                                                        <td style="width: 15%" ><%= s.getProductGroup().getProductGroupName()%></td>                                                        
                                                        <td style="width: 12%"><p id="<%= s.getProductGroup().getId() %>"><%= s.getQuantity()%></p></td>                                                            
                                                        <td style="width: 48%">
                                                            <div class="btn-group btn-toggle"> 
                                                                <span id="<%= s.getProductGroup().getId() %>" onclick="getMultipleRegressionSaleForecast(this)" class="btn btn-default <% if(s.getMethod().equals("M")){ out.print("active"); } %> ">Multiple Linear Regression</span>
                                                                <span id="<%= s.getProductGroup().getId() %>" onclick="getRegressionSaleForecast(this)" class="btn btn-default <% if(s.getMethod().equals("R")){ out.print("active"); } %>">Simple Linear Regression</span>
                                                                <span id="<%= s.getProductGroup().getId() %>" onclick="getSaleForecast(this)" class="btn btn-default <% if(s.getMethod().equals("A")){ out.print("active"); } %> ">Average Method</span>                                                                    
                                                                <a href="#myModal<%= s.getId()%>" data-toggle="modal"><span id="<%= s.getProductGroup().getId()%>" class="btn btn-default <% if (s.getMethod().equals("E")) {out.print("active");}%>">Manual</span></a>
                                                                <div role="dialog" class="modal fade" id="myModal<%= s.getId()%>">
                                                                    <div class="modal-dialog">
                                                                        <form action="../SaleForecast_Servlet/editSaleForecast">
                                                                            <input type="hidden" name="saleForecastId" value="<%= s.getId()%>" >
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h4>Manual Create Sales Forecast</h4>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <div class="form-group">
                                                                                        <label>Sales Forecast Quantity: </label>
                                                                                        <input type="number" min="0" class="form-control" name="quantity" required>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="modal-footer">                                                                                                                                
                                                                                    <button class="btn btn-primary" name="submit-btn" value="Delete Warehouse">Confirm</button>
                                                                                    <a class="btn btn-default" data-dismiss ="modal">Close</a>                        
                                                                                </div>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>                                                                                                                                                                                                                                                 
                                                        </td>                                                            
                                                        <td style="width: 25%">
                                                            <form action="../SaleForecast_Servlet/SaleForecast_main_POST">
                                                                <button class="btn btn-primary" name="productGroupId" value="<%= s.getProductGroup().getId()%>">View historical data</button>
                                                            </form>   
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                            </table>                                                                                                                                           
                                        </div>
                                    </div>
                                    <!-- /.table-responsive -->
                                </div>
                                <!-- /.panel-body -->

                            </div>
                            <!-- /.panel -->
                        </div>
                        <!-- /.col-lg-12 -->
                    </div>

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->

        <%
            if (request.getAttribute("alertMessage") != null) {
        %>
        <script>
            alert("<%= request.getAttribute("alertMessage")%>");
        </script>
        <%
            }
        %>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->        
        <script>
            $(document).ready(function () {
                $('#dataTable1').dataTable();
                $('#dataTable2').dataTable();                
            }
            );
        </script>                
        
        <script>
            function getSaleForecast(a) {                
                var productGroupId = $(a).attr('id');                                              
                $.get('../SalesForecast_ajax_servlet/average', {productGroupId: productGroupId}, function (responseText) {                         
                    var val = responseText.trim().split(';');                    
                    $(a).closest('tr').find('td:eq(1)').html(val[1]);
                    $(a).addClass('active');
                    $(a).closest('td').find('span:eq(0)').removeClass('active');
                    $(a).closest('td').find('span:eq(1)').removeClass('active');
                    $(a).closest('td').find('span:eq(3)').removeClass('active');
                });
            }
        </script>
        
        <script>
            function getRegressionSaleForecast(a) {                
                var productGroupId = $(a).attr('id');                                              
                $.get('../SalesForecast_ajax_servlet/regression', {productGroupId: productGroupId}, function (responseText) {                         
                    var val = responseText.trim().split(';');                    
                    $(a).closest('tr').find('td:eq(1)').html(val[1]);
                    $(a).addClass('active');
                    $(a).closest('td').find('span:eq(0)').removeClass('active');
                    $(a).closest('td').find('span:eq(2)').removeClass('active');
                    $(a).closest('td').find('span:eq(3)').removeClass('active');
                });
            }
        </script>
        
        <script>
            function getMultipleRegressionSaleForecast(a) {                
                var productGroupId = $(a).attr('id');                                              
                $.get('../SalesForecast_ajax_servlet/multiple', {productGroupId: productGroupId}, function (responseText) {                         
                    var val = responseText.trim().split(';');                    
                    $(a).closest('tr').find('td:eq(1)').html(val[1]);
                    $(a).addClass('active');
                    $(a).closest('td').find('span:eq(1)').removeClass('active');
                    $(a).closest('td').find('span:eq(2)').removeClass('active');
                    $(a).closest('td').find('span:eq(3)').removeClass('active');
                });
            }
        </script>
        <div role="dialog" class="modal fade" id="myModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4>Alert</h4>
                    </div>
                    <div class="modal-body">
                        <p id="messageBox" style="color: #000"><b>Explanation on the sales forecast method:<br>1.Linear Regression Method use all historical data without incorporate sales shock. <br> 2.Multiple Linear Regression Method use all data and can take seasonal effect into consideration. <br> 3.Average Method should be used when short term historical data are more trustful.</b></p>
                    </div>
                    <div class="modal-footer">                        
                        <a class="btn btn-default" data-dismiss ="modal">Close</a>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>
