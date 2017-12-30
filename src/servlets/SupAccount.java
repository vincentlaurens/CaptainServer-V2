package servlets;

import connexion.ManagerDBB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "SupAccount", urlPatterns = "/servlets/SupAccount")
public class SupAccount extends HttpServlet {
    private static final String ATT_ERREURS = "erreurs";
    private static final String ATT_RESULTAT = "resultat";
    private static final String CHEMIN = "/pages/admin/gestion_comptes_utilisateurs.jsp";


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resultat;

        Map<String, String> erreurs = new HashMap<>();

        String loginAsupprimer = request.getParameter("loginAsupprimer");
        String mdpAsupprimer = request.getParameter("mdpAsupprimer");
        String typeAsupprimer = request.getParameter("typeAsupprimer");


        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = connexionDBB.connexion();

            if (conn != null && conn.isClosed()) {
                String message = "Exception sur l'accès à la BDD ";
                erreurs.put("loginAsupprimer", message);
            } else {
                assert conn != null;
                Statement stmt = conn.createStatement();
                String requete = String.format("DELETE FROM captainbdd.utilisateur WHERE loginutilisateur = '%s';", loginAsupprimer);
                int requestResult = stmt.executeUpdate(requete);
                if(requestResult<0){
                    String message = String.format("Requête de suppression du compte %s à échouée", loginAsupprimer);
                    erreurs.put("loginAsupprimer", message);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        /* Initialisation du résultat global de la validation. */

        if (erreurs.isEmpty()) {

            resultat = String.format("Suppression du comte %s, %s, %s", loginAsupprimer,mdpAsupprimer,typeAsupprimer);

        } else {

            resultat = "Suppression erreur : "+erreurs.get("loginAsupprimer");

        }


        /* Stockage du résultat et des messages d'erreur dans l'objet request */

        request.setAttribute(ATT_ERREURS, erreurs);
        request.setAttribute(ATT_RESULTAT, resultat);


        /* Transmission de la paire d'objets request/response à notre JSP */

        this.getServletContext().getRequestDispatcher(CHEMIN).forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.getServletContext().getRequestDispatcher( CHEMIN ).forward( request, response );

    }
}
