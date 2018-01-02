package servlets;

import connexion.ManagerDBB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;


import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet(name = "Login", urlPatterns = "/servlets/Login")
public class Login extends HttpServlet {
    private static final String CHEMIN = "/index.jsp";
    private Statement ds;
    private DriverManager out;
    private String erreur;
    private String resultat;
    private HttpSession session;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nameTapeParUtilisateur = request.getParameter("login");
        String passwordTapeParUtilisateur = request.getParameter("password");


        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = connexionDBB.connexion();

            assert conn != null;
            Statement stmt = conn.createStatement();
            String requete = String.format("SELECT type, password FROM captainbdd.utilisateur WHERE loginutilisateur='%s' ;", nameTapeParUtilisateur);
            System.out.println(requete);
            ResultSet requestResult = stmt.executeQuery(requete);
            if (requestResult != null) {
                while (requestResult.next()) {
                    String type = requestResult.getString(1);
                    String passwordBdd = requestResult.getString(2);
                    if(!passwordTapeParUtilisateur.equals(passwordBdd)){
                        erreur = "Mot de passe incorrect!!!";
                    }else{
                        System.out.println("Login servlet : "+type);
                        session = request.getSession(true);
                        session.setAttribute("nomUtilisateur", nameTapeParUtilisateur);
                        session.setAttribute("typeUtilisateur", type);
                        switch (type) {
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

                }
                stmt.close();
            }else{
                erreur = "L'utilisateur n'existe pas ";
            }

            connexionDBB.closeDBB();
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        if(erreur != null){
            resultat = String.format("Erreur lors de la connexion : %s", erreur);
            this.getServletContext().getRequestDispatcher(CHEMIN).forward(request, response);
            response.sendRedirect(CHEMIN);
        }



    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
