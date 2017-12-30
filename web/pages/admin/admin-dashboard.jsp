<%@ page import="java.sql.Connection" %>
<%@ page import="connexion.ManagerDBB" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%--
  Created by IntelliJ IDEA.
  User: vince
  Date: 29/12/2017
  Time: 14:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    private ManagerDBB connexionDBB;
    private Connection conn;
%><%
    try {
        connexionDBB  = new ManagerDBB();
        conn = connexionDBB.connexion();
    }catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Administrateur | Tableau de bord</title>

    <!-- Bootstrap Core CSS -->
    <link href="../../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="../../vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="../../dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="../../vendor/morrisjs/morris.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="../../vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">


    <!--<link href="../../vendor/bootstrap/css/bootstrap.css" rel="stylesheet">-->
    <link rel="stylesheet" href="../../dist/css/jquery.treegrid.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

<div id="wrapper">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header navbar-left">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="user-dashboard.jsp">Captain</a>

        </div>
        <div class ="navbar-right">
            <a class="logout" href="../../index.jsp"><i class="fa fa-sign-out fa-fw"></i>Déconnexion</a>
            <img src="../../ressource/logo_edison_ways.png" style="margin-right: 20px" height="50">
        </div>
        <!-- /.navbar-header -->

        <ul class="nav navbar-top-links navbar-left">
            <li class="navbar-link active ">
                <a class="link " href="admin-dashboard.jsp"><i class="fa fa-dashboard"></i> Tableau de bord</a>
            </li>
            <li class="navbar-link">
                <a class="link"  href="gestion_comptes_utilisateurs.jsp"><i class="fa fa-gear"></i> Paramètres de Compte</a>
            </li>
            <li class="navbar-link">
                <a class="link"  href="gestion_categories.jsp"><i class="fa fa-folder-open"></i> Gestion des Catégories</a>
            </li>
            <li class="navbar-link">
                <a class="link"  href="etat_reseau.jsp"><i class="fa fa-bolt"></i> Gestion du Réseau</a>
            </li>

        </ul>
    </nav>
</div>





<div id="page" style="margin-left: 1%; margin-right: 1%;" >

    <div class="row" style="margin-top: 15px"> </div>
    <div class="row">
        <div class="col-lg-4">
            <div class="panel panel-info">
                <div class="panel-heading">Paramétrage du Compte</div>
                <div class="panel-body">
                    <div class="row">
                        <div class="table-responsive">
                            <table class="table table-responsive table-striped table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th style="text-align:center" >Compte</th>
                                    <th style="text-align:center" >Mot de passe</th>
                                    <th style="text-align:center">Type</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    try{
                                        System.out.println("admin-dashboard : conn = "+conn.isClosed());
                                        if(conn !=null && conn.isClosed()){
                                            response.sendError(500, "Exception sur l'accès à la BDD ");
                                        }else {
                                            Statement stmt = conn.createStatement();
                                            String requete = "SELECT loginutilisateur,password,type FROM captainbdd.utilisateur WHERE loginutilisateur IS NOT NULL AND password IS NOT NULL AND type IS NOT NULL ORDER BY type ASC;";
                                            System.out.println(requete);
                                            ResultSet requestResult = stmt.executeQuery(requete);
                                            if (requestResult != null) {

                                                while(requestResult.next()) {
                                                    String login = requestResult.getString(1);
                                                    String password = requestResult.getString(2);
                                                    String type = requestResult.getString(3);
                                %>
                                <tr>
                                    <td style="text-align:center"><%out.print(login);%></td>
                                    <td style="text-align:center"><%out.print(password);%></td>
                                    <td style="text-align:center"><%out.print(type);%></td>
                                </tr>
                                <%
                                                }

                                            }
                                        }
                                    }catch(Exception e1){
                                        e1.printStackTrace();
                                        }
                                %>
                                </tbody>
                            </table>
                        </div>
                        <!-- /.table-responsive -->
                    </div>
                    <div class="row">
                        <a href="gestion_comptes_utilisateurs.jsp" role="button" class="btn btn-outline btn-primary btn-lg btn-block" >Modifier</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.col-lg-4 -->

        <div class="col-lg-4">
            <div class="panel panel-info">
                <div class="panel-heading">Gestion des Catégories</div>
                <div class="panel-body">
                    <div class="row">
                        <table class="tree">
                            <tr class="treegrid-1">
                                <td>Maison</td>
                            </tr>
                            <tr class="treegrid-2 treegrid-parent-1">
                                <td>Chambre</td><td>
                            </tr>
                            <tr class="treegrid-3 treegrid-parent-1">
                                <td>Cuisine</td>
                            </tr>
                            <tr class="treegrid-4 treegrid-parent-3">
                                <td>Lumières</td>
                            </tr>
                        </table>
                    </div>
                    <div class="row">
                        <a href="gestion_categories.jsp" role="button" class="btn btn-outline btn-primary btn-lg btn-block" >Modifier</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.col-lg-4 -->

        <div class="col-lg-4">
            <div class="panel panel-info">
                <div class="panel-heading">Gestion du Réseau</div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <p>Consommation Totale :</p>
                        </div>
                        <div class="col-lg-6"> - - </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <p>Nombre de charges :</p>
                        </div>
                        <div class="col-lg-6"> - - </div>
                    </div>
                    <div class="row">
                        <div class="table-responsive">
                            <table class="table table-responsive table-striped table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th style="text-align:center">Etat boitier(s) Secondaire(s)</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td style="text-align:center">boitier1</td>
                                </tr>
                                <tr>
                                    <td style="text-align:center">boitier2</td>
                                </tr>
                                <tr>
                                    <td style="text-align:center">boitier3</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- /.table-responsive -->
                    </div>
                    <div class="row">
                        <a href="etat_reseau.jsp" role="button" class="btn btn-outline btn-primary btn-lg btn-block" >Modifier</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.col-lg-4 -->
    </div>
</div>
</div>
<%
    try {
        connexionDBB.closeDBB();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<script src="../../vendor/jquery/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="../../vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="../../vendor/metisMenu/metisMenu.min.js"></script>

<!-- Morris Charts JavaScript -->
<script src="../../vendor/raphael/raphael.min.js"></script>
<script src="../../vendor/morrisjs/morris.min.js"></script>
<script src="../../data/morris-data.js"></script>

<!-- Custom Theme JavaScript -->
<script src="../../dist/js/sb-admin-2.js"></script>


<script src="../../vendor/flot/jquery.flot.js"></script>
<script src="../../data/flot-data.js"></script>


<!-- JTree -->
<script type="text/javascript" src="../../js/jquery.treegrid.js"></script>
<script type="text/javascript" src="../../js/jquery.treegrid.bootstrap3.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('.tree').treegrid({
            expanderExpandedClass: 'glyphicon glyphicon-minus',
            expanderCollapsedClass: 'glyphicon glyphicon-plus'
        });
    });
</script>

</body>

</html>
