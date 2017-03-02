<%-- 
    Document   : asessment
    Created on : Dec 29, 2016, 10:37:45 AM
    Author     : Conseptify
    Check 
        if Already Logged in then
            if user has not taken assessment then Continue on page
            else redirect to assessment already taken page
        if not logged in then redirect to login required page
    
--%>

<%@page import="com.connection.mysql.MySqlConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<%
    if( session == null )                                   // If there is no session for that user
    {
        response.sendRedirect("error/login_required.html");
        return;
    }
    // If there is any session for that user then validate the session
    String requestIP = request.getRemoteAddr();
    String sessionEmail_id = (String)session.getAttribute("email_id");
    String sessionRole = (String)session.getAttribute("role");
    String sessionIP = (String)session.getAttribute("client_ip");

    if( sessionEmail_id == null || !sessionRole.equals("student") ||  !sessionIP.equals(requestIP) )
    {
        response.sendRedirect("error/login_required.html");
        return;
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Assessment</title>
    </head>
    
    <%@include file="assessment_HTML.html" %>
        
        
    <body>
        <div style=" text-align:left;font-size:15px;position:absolute;left:250px;top:370px;width:850px;height:900px;z-index:20;">
            <form action="assessment_submission.do" method="post">
            <%
                MySqlConnection.init();
                Connection con = MySqlConnection.createConnection(2);
                Statement st = con.createStatement();

                int i = 1;
                while( i <= 6 )
                {
                    int randomQuestionId = (int )(Math.random() * 5 + 1);                   //Min-1 Max-5
                    ResultSet rs;
                    if( i <= 2 )
                    {
                        rs = st.executeQuery("SELECT * FROM `aptitude_question_set` WHERE question_id =  "+ randomQuestionId);
                        if( i==1 )
                            out.print("<h3>Aptitude Questions</h3><br>");
                    }
                    else if( i <= 4 )
                    {
                        rs = st.executeQuery("SELECT * FROM `generalknowledge_question_set` WHERE question_id =  "+ randomQuestionId);
                        if( i==3 )
                            out.print("<h3>General Knowledge Questions</h3><br>");
                    }
                    else
                    {
                        rs = st.executeQuery("SELECT * FROM `verbal_question_set` WHERE question_id =  "+ randomQuestionId);
                        if( i == 5 )
                            out.print("<h3>Verbal Questions</h3><br>");
                    }  

                    rs.next();
                    {
                        out.println(i+">");
                        out.println( rs.getString(2) + "<br>");
                        out.print("(A) ");
                        out.println( rs.getString(3) + "<br>");
                        out.print("(B) ");
                        out.println( rs.getString(4) + "<br>");
                        out.print("(C)  ");
                        out.println( rs.getString(5) + "<br>");
                        out.print("(D) ");
                        out.println( rs.getString(6) + "<br>");
                        out.print(" a <input type='radio' name='q"+i+"' value='1'> ");
                        out.print(" b <input type='radio' name='q"+i+"' value='2'> ");
                        out.print(" c <input type='radio' name='q"+i+"' value='3'> ");
                        out.print(" d <input type='radio' name='q"+i+"' value='4'> <br><br>");
                        out.print("<input type='hidden' name='ans"+i+"' value='"+rs.getString(7)+"'<br>");
                        i++;
                    }
                }

                out.print("<input type='submit' value='submit'>");


                MySqlConnection.closeConnection(con);
            %>

            </form>
        </div>
    </body>
</html>