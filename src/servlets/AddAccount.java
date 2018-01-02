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
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;


@WebServlet(name = "AddAccount", urlPatterns = "/servlets/Addcount")
public class AddAccount extends HttpServlet {
    private static final String ATT_ERREURS = "erreurs";
    private static final String ATT_RESULTAT = "resultat";
    private static final String CHEMIN = "/pages/admin/gestion_comptes_utilisateurs.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resultat;

        Map<String, String> erreurs = new HashMap<>();

        String loginAajouter = request.getParameter("nouveauLoginAjouter");
        String mdpAajouter = request.getParameter("nouveauMdPAjouter");
        String mdpAajouterConfirmation = request.getParameter("ConfirmationNouveauMdPAjouter");
        String typeAajouter = request.getParameter("nouveauTypeAjouter");


        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = connexionDBB.connexion();
            System.out.println("AddAccount : " + conn);
            if (conn != null && conn.isClosed()) {
                String message = "Exception sur l'accès à la BDD ";
                erreurs.put("nouveauLoginAjouter", message);
            } else {
                assert conn != null;
                Statement stmt = conn.createStatement();
                String requete = String.format("SELECT loginutilisateur FROM captainbdd.utilisateur  WHERE loginutilisateur = '%s';", loginAajouter);
                ResultSet requestResult = stmt.executeQuery(requete);
                Boolean compteExiste = false;
                while (requestResult.next()) {
                    if (requestResult.getString(1).equals(loginAajouter)) {
                        compteExiste = true;
                        String message = String.format("Le compte %s existe déjà!!!", loginAajouter);
                        erreurs.put("nouveauLoginAjouter", message);
                    }
                }
                if (!compteExiste) {
                    if (!mdpAajouter.equals(mdpAajouterConfirmation)) {
                        String message = "Veuillez entrer le même mot de passe de confirmation";
                        erreurs.put("nouveauLoginAjouter", message);
                    } else {
                        String requeteInsertion = String.format("INSERT INTO captainbdd.utilisateur (loginutilisateur, password, type) VALUES ('%s','%s', '%s');", loginAajouter, mdpAajouter, typeAajouter);
                        System.out.println(requeteInsertion);
                        int requestResultInsertion = stmt.executeUpdate(requeteInsertion);
                        System.out.println("requestResultInsertion" + requestResultInsertion);
                        if (requestResultInsertion < 0) {
                            String message = "Ajout dans la base impossible!!";
                            erreurs.put("nouveauLoginAjouter", message);
                        }
                    }


                }
            }
        } catch (Exception e) {
            try {
                response.sendError(-1, e.getMessage());
            } catch (IOException e1) {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        /* Initialisation du résultat global de la validation. */

        if (erreurs.isEmpty()) {

            resultat = String.format("Ajout du comte %s, %s, %s", loginAajouter,mdpAajouter,typeAajouter);

        } else {

            resultat = "Ajout erreur : "+erreurs.get("nouveauLoginAjouter");

        }


        /* Stockage du résultat et des messages d'erreur dans l'objet request */

        request.setAttribute(ATT_ERREURS, erreurs);
        request.setAttribute(ATT_RESULTAT, resultat);


        /* Transmission de la paire d'objets request/response à notre JSP */

        this.getServletContext().getRequestDispatcher(CHEMIN).forward(request, response);
        response.sendRedirect(CHEMIN);    }

        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.getServletContext().getRequestDispatcher( CHEMIN ).forward( request, response );

    }


}
