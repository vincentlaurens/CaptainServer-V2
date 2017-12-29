import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/Login")
public class Login extends HttpServlet {
    private Statement ds;
    private DriverManager out;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nameTapeParUtilisateur = request.getParameter("login");
        String passwordTapeParUtilisateur = request.getParameter("password");


        try {
            ManagerDBB connexionDBB = new ManagerDBB();
            Connection conn = connexionDBB.connexion();

            if(conn == null) {
                response.sendError(500, "Exception sur l'accès à la BDD ");
            }else{
                Statement stmt = conn.createStatement();
                String requete = "SELECT type \n" +
                        "\tFROM captainbdd.utilisateur\n" +
                        "    WHERE loginutilisateur='" + nameTapeParUtilisateur + "' AND password='" + passwordTapeParUtilisateur + "';";
                ResultSet requestResult = stmt.executeQuery(requete);
                if (requestResult != null) {
                    while (requestResult.next()) {
                        String type = requestResult.getString(1);
                        System.out.println(type);
                        switch (type){
                            case "admin":
                                response.sendRedirect("../../../pages/admin/admin-dashboard.html");
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

            }
            connexionDBB.closeDBB();
        } catch (Exception e1) {
            e1.printStackTrace();
        }



    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
