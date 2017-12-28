import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/Login")
public class Login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("login");
        String password =request.getParameter("password");
        String result;

        if(name.equals("technicien") && password.equals("pass")) {
            result="../../../pages/technicien/repair-dashboard.html";
        }else {
            if (name.equals("admin") && password.equals("passadmin")) {
                result = "../../../pages/admin-dashboard.html";
            } else {
                if (name.equals("user") && password.equals("passuser")) {
                    result = "../../../pages/user-dashboard.html";
                } else {
                    result = "../index.jsp";
                }
            }
        }
        response.sendRedirect(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
