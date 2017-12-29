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

import javax.servlet.jsp.JspWriter;

@WebServlet("/AddAccount")
public class AddAccount extends HttpServlet {
    private JspWriter  out;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) {

        String loginAajouter = request.getParameter("nouveauLoginAjouter");
        String mdpAajouter = request.getParameter("nouveauMdPAjouter");
        String mdpAajouterConfirmation = request.getParameter("ConfirmationNouveauMdPAjouter");
        String typeAajouter = request.getParameter("nouveauTypeAjouter");
        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = null;
            conn = connexionDBB.connexion();

            if (conn != null && conn.isClosed()) {
                response.sendError(500, "Exception sur l'accès à la BDD ");
            } else {
                Statement stmt = conn.createStatement();
                String requete = "SELECT loginutilisateur \n" +
                        "FROM captainbdd.utilisateur \n" +
                        "WHERE loginutilisateur = " + loginAajouter + ";";
                ResultSet requestResult = stmt.executeQuery(requete);
                Boolean compteExiste = false;
                while (requestResult.next()) {
                    if (requestResult.getString(1).equals(loginAajouter)) {
                        compteExiste = true;
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert(\"Le compte\" + loginAajouter, mdpAajouter, typeAajouter + \" a déjà été créé!!!\");");
                        out.println("</script>");

                    }
                }
                if (!compteExiste) {
                    if (!mdpAajouter.equals(mdpAajouterConfirmation)) {
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert(\"Veuillez entrer le même mot de passe de confirmation\");");
                        out.println("</script>");

                    } else {
                        String requeteInsertion = "INSERT INTO `captainbdd`.`utilisateur` (`loginutilisateur`, password, type VALUES ('" + loginAajouter + "'" + mdpAajouter + "'" + typeAajouter + "');";

                        int requestResultInsertion = stmt.executeUpdate(requeteInsertion);
                        if (requestResultInsertion < 0) {
                            response.sendError(requestResultInsertion, "Ajout dans la base impossible!!");
                        } else {
                            compteExiste = true;
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert(\"Le compte\" + loginAajouter, mdpAajouter, typeAajouter + \" a été créé\");");
                            out.println("</script>");

                        }
                    }


                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
