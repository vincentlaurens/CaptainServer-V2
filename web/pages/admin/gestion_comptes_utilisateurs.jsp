<%--@elvariable id="resultat" type="java"--%>
<%--@elvariable id="erreurs" type="java"--%>
<%@ page import="java.sql.Connection" %>
<%@ page import="connexion.ManagerDBB" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%--
  Created by IntelliJ IDEA.
  User: vince
  Date: 29/12/2017
  Time: 15:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    private ManagerDBB connexionDBB;
    private Connection conn;
    private HttpSession session;
%><%
    String username= (String) session.getAttribute("nomUtilisateur");
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

    <title>Administrateur | Gestion comptes utilisateurs</title>

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
            <a class="navbar-brand" href="user-dashboard.jsp">Captain |</a>
            <a class="navbar-brand" href="user-dashboard.jsp"><%out.print(username);%></a>

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
    <div class="row" style="margin-left:2%; margin-right:2%;">
        <div class="col-lg-4">
            <div class="panel panel-info">
                <div class="panel-heading">Liste des Comptes existants</div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table class="table table-responsive table-striped table-bordered table-hover" id="data">
                            <thead>
                            <p style="color:${empty erreurs ? 'green' : 'red'}">${resultat}</p>
                            <tr id ="0">
                                <th style="text-align:center" >Compte</th>
                                <th style="text-align:center">Mot de Passe</th>
                                <th style="text-align:center">Type</th>
                                <th style="text-align:center"><button type="button" class="btn btn-xs btn-circle btn-success" onclick="openOptionAjouter(event)"><i class="fa fa-plus"></i></button></th>                                    </tr>
                            </thead>
                            <tbody>
                            <tbody>
                            <%
                                try{
                                    System.out.println(" gestion_comptes : conn = "+conn.isClosed());
                                    if(conn !=null && conn.isClosed()){
                                        response.sendError(500, "Exception sur l'accès à la BDD ");
                                    }else {
                                        Statement stmt = conn.createStatement();
                                        String requete = "SELECT loginutilisateur,password,type FROM captainbdd.utilisateur WHERE loginutilisateur IS NOT NULL AND password IS NOT NULL AND type IS NOT NULL ORDER BY type ASC;";
                                        ResultSet requestResult = stmt.executeQuery(requete);
                                        if (requestResult != null) {
                                            int numligne = 0;
                                            while(requestResult.next()) {
                                                numligne++;
                                                String login = requestResult.getString(1);
                                                String password = requestResult.getString(2);
                                                String type = requestResult.getString(3);
                            %>
                            <tr id="<%out.print(numligne);%>">
                                <td style="text-align:center" ><%out.print(login);%></td>
                                <td style="text-align:center" ><%out.print(password);%></td>
                                <td style="text-align:center" ><%out.print(type);%></td>
                                <td style="text-align:center">
                                    <button type="button" class="btn btn-xs btn-info btn-circle" onclick="openOptionModifierOuSupprimmer(event, 'Modifier', <%out.print(numligne);%>)"><i class="fa fa fa-list"></i></button>
                                    <button type="button" class="btn btn-xs btn-danger btn-circle" onclick="openOptionModifierOuSupprimmer(event, 'Moins', <%out.print(numligne);%>)"><i class="fa fa-minus"></i></button>
                                </td>
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
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-lg-offset-1" id="container">
            <div class="row" id="Modifier" style="display: none;">
                <div class="panel panel-info">
                    <div class="panel-heading" >Modifier un Compte Utilisateur
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" onclick="closeOption(event, 'Modifier')">×</a>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <form role="form" method="post" action="${pageContext.request.contextPath}/servlets/ModifyAccount">
                                <fieldset id="choixmodif">

                                    <label>choix modification paramètres compte</label>
                                    <label class="radio-inline">
                                        <input name="optionsRadioInline" id="optionsRadioInline1" value="login" onchange="openChoix()" type="radio">login
                                    </label>
                                    <label class="radio-inline">
                                        <input name="optionsRadioInline" id="optionsRadioInline2" value="mdp" onchange="openChoix()" type="radio">mot de passe
                                    </label>
                                    <label class="radio-inline">
                                        <input name="optionsRadioInline" id="optionsRadioInline3" value="type" onchange="openChoix()" type="radio">type
                                    </label>

                                </fieldset>
                                <fieldset id="modifierLogin">
                                    <div class="form-group">
                                        <h1>Modifier le login</h1>
                                    </div>
                                    <div class="form-group">
                                        <label>Ancien login</label>
                                        <input class="form-control" id="ancienLogin" name="ancienLogin" type="text" placeholder="Ancien login" readonly>
                                    </div>
                                    <div class="form-group has-success">
                                        <label class="control-label">Nouveau login</label>
                                        <input type="text" class="form-control" id="nouveauLogin" name="nouveauLogin">
                                    </div>
                                    <div class="form-group has-success">
                                        <label class="control-label" >Confirmation du nouveau login</label>
                                        <input type="text" class="form-control" id="ConfirmationNouveauLogin" name="ConfirmationNouveauLogin">
                                    </div>
                                </fieldset>
                                <fieldset id="modifierMdp">
                                    <div class="form-group">
                                        <h1>Modifier le mot de passe</h1>
                                    </div>
                                    <div class="form-group">
                                        <label>Ancien mot de passe</label>
                                        <input class="form-control" id="ancienMdP" name="ancienMdP" type="text" placeholder="Ancien mot de passe" readonly >
                                    </div>
                                    <div class="form-group has-success">
                                        <label class="control-label" >Nouveau mot de passe</label>
                                        <input type="text" class="form-control" id="nouveauMdP" name="nouveauMdP">
                                    </div>
                                    <div class="form-group has-success">
                                        <label class="control-label">Confirmation du nouveau mot de passe</label>
                                        <input type="text" class="form-control" id="confirmationNouveauMdP" name="confirmationNouveauMdP">
                                    </div>
                                </fieldset>
                                <fieldset id="modifierType">
                                    <div class="form-group">
                                        <h1>Modifier le type du compte</h1>
                                    </div>
                                    <div class="form-group">
                                        <div class="form-group">
                                            <label>Ancien type</label>
                                            <input class="form-control" id="ancienType" name="ancienType" type="text" placeholder="Ancien type" readonly >
                                        </div>
                                        <label>nouveau type de compte</label>
                                        <select  class="form-control" id="nouveauTypeModif" name="nouveauTypeModif" required>
                                            <option value="user">Utilisateur</option>
                                            <option value="admin">Administrateur</option>
                                            <option value="repair">Technicien</option>
                                        </select>

                                    </div>
                                </fieldset>
                                <button type="submit" class="btn btn-default" onclick="return confirm('Confirmez-vous la modification du compte ?');">Modifier</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" id="Plus" style="display: none;">
                <div class="panel panel-info">
                    <div class="panel-heading ">Ajouter un Compte Utilisateur
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" onclick="closeOption(event, 'Plus')">×</a>
                    </div>
                    <div class="panel-body">
                        <form role="form" action="${pageContext.request.contextPath}/servlets/Addcount" method="post">
                            <fieldset>
                                <div class="form-group">
                                    <h1>Nouvel Utilisateur</h1>
                                </div>
                                <div class="form-group ">
                                    <label class="control-label">Nouveau login</label>
                                    <input  type="text" class="form-control" id="nouveauLoginAjouter" name="nouveauLoginAjouter" required>
                                </div>
                                <div class="form-group ">
                                    <label class="control-label" >Nouveau mot de passe</label>
                                    <input type="text" class="form-control" id="nouveauMdPAjouter" name = "nouveauMdPAjouter" required>
                                </div>
                                <div class="form-group">
                                    <label class="control-label" >Confirmation nouveau mot de passe</label>
                                    <input type="text" class="form-control" id="ConfirmationNouveauMdPAjouter" name="ConfirmationNouveauMdPAjouter" required>
                                </div>
                                <div class="form-group">

                                    <label>Type de compte</label>
                                    <select class="form-control" id="nouveauTypeAjouter" name="nouveauTypeAjouter" required>
                                        <option value="user">Utilisateur</option>
                                        <option value="admin">Administrateur</option>
                                        <option value="repair">Technicien</option>
                                    </select>

                                </div>
                            </fieldset>

                            <input type="submit" class="btn btn-default" value="Ajouter"/>
                            <input type="reset" class="btn btn-default" value="Vider les champ"/>
                        </form>
                    </div>
                </div>
            </div>
            <div class="row" id="Moins" style="display: none;">
                <div class="panel panel-info">
                    <div class="panel-heading">Supprimer un Compte
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" onclick="closeOption(event, 'Moins')">×</a>
                    </div>
                    <div class="panel-body">
                        <form role="form"  method="post" action="${pageContext.request.contextPath}/servlets/SupAccount" id="formSupAccount">
                            <fieldset>
                                <div class="form-group">
                                    <h1>Supprimer le compte suivant</h1>
                                </div>
                                <div class="form-group">
                                    <label for="loginAsupprimer">Login à Supprimer</label>
                                    <input class="form-control" id="loginAsupprimer" name="loginAsupprimer" type="text" placeholder="Login a supprimer" readonly>
                                </div>

                                <div class="form-group">
                                    <label for="mdpAsupprimer">Mot de passe à Supprimer</label>
                                    <input class="form-control" id="mdpAsupprimer" name="mdpAsupprimer" type="text" placeholder="Mot de Passe a supprimer" readonly>
                                </div>

                                <div class="form-group">
                                    <label for="typeAsupprimer">Type de compte à Supprimer</label>
                                    <input class="form-control" id="typeAsupprimer" name="typeAsupprimer" type="text" placeholder="Type a supprimer" readonly>
                                </div>
                            </fieldset>
                            <input type="submit" class="btn btn-default" value="Supprimer" onclick="return confirm('Confirmez-vous la suppression du compte ?');"/>
                        </form>
                    </div>
                </div>
            </div>
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



<script type="text/javascript">
    var loginmodif, mdpmodif, typemodif;

    function openOptionAjouter(evt) {
        document.getElementById('Plus').style.display = "block";
        evt.currentTarget.className += " active";
    }

    function openChoix(){

        if(document.getElementById('optionsRadioInline1').checked === true){
            document.getElementById('modifierLogin').style.display = "block";

            document.getElementById('ancienLogin').value = loginmodif;
        }else{
            document.getElementById('modifierLogin').style.display = "none";
        }

        if(document.getElementById('optionsRadioInline2').checked === true){
            document.getElementById('modifierMdp').style.display = "block";
            document.getElementById('ancienMdP').value = mdpmodif;
        }else{
            document.getElementById('modifierMdp').style.display = "none";
        }

        if(document.getElementById('optionsRadioInline3').checked === true){
            document.getElementById('modifierType').style.display = "block";
            document.getElementById('ancienType').value = typemodif;
        }else{
            document.getElementById('modifierType').style.display = "none";
        }
    }

    function openOptionModifierOuSupprimmer(evt, optionName, numLigne){
        if(optionName === 'Modifier'){
            document.getElementById(optionName).style.display = "block";
            document.getElementById('modifierLogin').style.display = "none";
            document.getElementById('modifierMdp').style.display = "none";
            document.getElementById('modifierType').style.display = "none";

            evt.currentTarget.className += " active";

            loginmodif = document.getElementById('data').getElementsByTagName('tr')[numLigne].cells[0].innerHTML;
            mdpmodif = document.getElementById('data').getElementsByTagName('tr')[numLigne].cells[1].innerHTML;
            typemodif = document.getElementById('data').getElementsByTagName('tr')[numLigne].cells[2].innerHTML;

        }
        if(optionName === 'Moins'){
            document.getElementById(optionName).style.display = "block";
            evt.currentTarget.className += " active";

            var login = document.getElementById('data').getElementsByTagName('tr')[numLigne].cells[0].innerHTML;
            var mdp = document.getElementById('data').getElementsByTagName('tr')[numLigne].cells[1].innerHTML;
            var type = document.getElementById('data').getElementsByTagName('tr')[numLigne].cells[2].innerHTML;

            document.getElementById('loginAsupprimer').value = login;
            document.getElementById('mdpAsupprimer').value = mdp;
            document.getElementById('typeAsupprimer').value = type;
        }

    }


    function closeOption(evt, optionName) {
        document.getElementById(optionName).style.display = "none";
        evt.currentTarget.className.replace(" active", "");
    }
</script>
</body>

</html>
