package servlets;

import connexion.ManagerDBB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;


import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet(name = "Login", urlPatterns = "/servlets/Login")
public class Login extends HttpServlet {
    private Statement ds;
    private DriverManager out;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nameTapeParUtilisateur = request.getParameter("login");
        String passwordTapeParUtilisateur = request.getParameter("password");


        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = connexionDBB.connexion();

            assert conn != null;
            Statement stmt = conn.createStatement();
            String requete = String.format("SELECT type FROM captainbdd.utilisateur WHERE loginutilisateur='%s' AND password='%s';", nameTapeParUtilisateur, passwordTapeParUtilisateur);
            System.out.println(requete);
            ResultSet requestResult = stmt.executeQuery(requete);
            if (requestResult != null) {
                while (requestResult.next()) {
                    String type = requestResult.getString(1);
                    System.out.println("Login servlet : "+type);
                    switch (type){
                        case "admin":
                            response.sendRedirect("../../../pages/admin/admin-dashboard.jsp");
                            break;
                        case "user":
                            response.sendRedirect("../../../pages/user-dashboard.html");
                            break;
                        case "repair":
                            response.sendRedirect("../../../pages/technicien/repair-dashboard.html");
                            break;
                    }

                }
                stmt.close();
            }else{
                response.sendError(10, "L'utilisateur n'existe pas ");
            }

            connexionDBB.closeDBB();
        } catch (Exception e1) {
            e1.printStackTrace();
        }



    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
