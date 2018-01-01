package servlets;

import connexion.ManagerDBB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ModifyAccount", urlPatterns = "/servlets/ModifyAccount")
public class ModifyAccount extends HttpServlet {
    private static final String ATT_ERREURS = "erreurs";
    private static final String ATT_RESULTAT = "resultat";
    private static final String CHEMIN = "/pages/admin/gestion_comptes_utilisateurs.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resultat;
        Map<String, String> resultats = new HashMap<>();

        Map<String, String> erreurs = new HashMap<>();

        String choixModif = request.getParameter("optionsRadioInline");

        String loginAmodifier = request.getParameter("ancienLogin");
        String loginValeurModif = request.getParameter("nouveauLogin");
        String loginValeurModifConfirmation = request.getParameter("ConfirmationNouveauLogin");
        String mdpAmodifier = request.getParameter("ancienMdP");
        String mdpValeurModif = request.getParameter("nouveauMdP");
        String mdpValeurModifConfirmation = request.getParameter("confirmationNouveauMdP");
        String typeAmodifier = request.getParameter("ancienType");
        String typeValeurModif = request.getParameter("nouveauTypeModif");


        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = connexionDBB.connexion();
            System.out.println("ModifyAccount : "+mdpAmodifier + mdpValeurModif);

            if (conn != null && conn.isClosed()) {
                String message = "Exception sur l'accès à la BDD ";
                erreurs.put("modifAccount", message);
            } else {
                switch (choixModif){
                    case "login":
                        if(!loginValeurModif.equals(loginValeurModifConfirmation)){
                            String message ="Veuillez entrer le même nom de compte!!!! ";
                            erreurs.put("modifAccount", message);
                        }else{
                            assert conn != null;
                            Statement stmt = conn.createStatement();
                            String requeteModifLogin = String.format("UPDATE captainbdd.utilisateur\n" +
                                    "SET loginutilisateur = REPLACE(loginutilisateur, '%s', '%s')\n" +
                                    "WHERE loginutilisateur = '%s';", loginAmodifier, loginValeurModif, loginAmodifier);
                            System.out.println(requeteModifLogin);
                            int requeteModifLoginResult = stmt.executeUpdate(requeteModifLogin);
                            if(requeteModifLoginResult<0){
                                String message = String.format("Requête de modification du nom de compte %s à échouée", loginAmodifier);
                                erreurs.put("modifAccount", message);
                            }else{
                                String message = String.format("Nom de compte modifié de %s vers %s", loginAmodifier, loginValeurModif);
                                resultats.put("modifAccount", message);
                            }

                        }
                        break;
                    case "mdp":
                        if(!mdpValeurModif.equals(mdpValeurModifConfirmation)){
                            String message ="Veuillez entrer le même mot de passe!!!! ";
                            erreurs.put("modifAccount", message);
                        }else{
                            assert conn != null;
                            Statement stmt1 = conn.createStatement();
                            String requeteModifMdp = String.format("UPDATE captainbdd.utilisateur\n" +
                                    "SET password = REPLACE(password, '%s', '%s')\n" +
                                    "WHERE password = '%s';", mdpAmodifier, mdpValeurModif, mdpAmodifier);
                            System.out.println(requeteModifMdp);
                            int requeteModifMdpResult = stmt1.executeUpdate(requeteModifMdp);
                            if(requeteModifMdpResult<0){
                                String message = String.format("Requête de modification du mot de passe du compte %s à échouée", mdpAmodifier);
                                erreurs.put("modifAccount", message);
                            }else{
                                String message = String.format("Mot de passe modifié de %s vers %s", mdpAmodifier, mdpValeurModif);
                                resultats.put("modifAccount", message);
                            }
                        }
                        break;
                    case "type":
                        assert conn != null;
                        Statement stmt2 = conn.createStatement();
                        String requeteModifType = String.format("UPDATE captainbdd.utilisateur\n" +
                                "SET type = REPLACE(type, '%s', '%s')\n" +
                                "WHERE type = '%s';", typeAmodifier, typeValeurModif, typeAmodifier);
                        System.out.println(requeteModifType);
                        int requeteModifTypeResult = stmt2.executeUpdate(requeteModifType);
                        if(requeteModifTypeResult<0){
                            String message = String.format("Requête de modification du type du compte %s à échouée", typeAmodifier);
                            erreurs.put("modifAccount", message);
                        }else {
                            String message = String.format("Type du compte modifié de %s vers %s", typeAmodifier, typeValeurModif);
                            resultats.put("modifAccount", message);
                            }
                        break;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        /* Initialisation du résultat global de la validation. */

        if (erreurs.isEmpty()) {

            resultat = "Modification du compte: "+resultats.get("modifAccount");

        } else {

            resultat = "Modification erreur : "+erreurs.get("modifAccount");

        }


        /* Stockage du résultat et des messages d'erreur dans l'objet request */

        request.setAttribute(ATT_ERREURS, erreurs);
        request.setAttribute(ATT_RESULTAT, resultat);


        /* Transmission de la paire d'objets request/response à notre JSP */

        this.getServletContext().getRequestDispatcher(CHEMIN).forward(request, response);
        response.sendRedirect(CHEMIN);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.getServletContext().getRequestDispatcher( CHEMIN ).forward( request, response );

    }
}
