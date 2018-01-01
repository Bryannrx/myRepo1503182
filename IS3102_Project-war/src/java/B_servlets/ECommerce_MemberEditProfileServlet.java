/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package B_servlets;

import CorporateManagement.FacilityManagement.FacilityManagementBeanLocal;
import EntityManager.CountryEntity;
import HelperClasses.Member;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Form;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 *
 * @author safwa_000
 */
@WebServlet(name = "ECommerce_MemberEditProfileServlet", urlPatterns = {"/ECommerce_MemberEditProfileServlet"})
public class ECommerce_MemberEditProfileServlet extends HttpServlet {

    @EJB
    private FacilityManagementBeanLocal facilityManagementBean;
    
    private String result;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try  {
     String name = request.getParameter("name");
     String email = request.getParameter("email");
     String phone = request.getParameter("phone");
     String country = request.getParameter("country"); //just in case. Actual website does not call in the country data
     String address = request.getParameter("address");
     String securityQuestion = request.getParameter("securityQuestion");
     String securityAnswer = request.getParameter("securityAnswer");
     String age = request.getParameter("age");
     String income = request.getParameter("income");
     
     String passwordSalt = "";
    String passwordHash = "";
    if(!request.getParameter("password").isEmpty()){
        passwordSalt = generatePasswordSalt();
        passwordHash = generatePasswordHash(passwordSalt, request.getParameter("password"));
    }
     
     boolean success = updateMember(name, email, phone,country, address, securityQuestion,securityAnswer, age, income, passwordSalt, passwordHash);
     
     HttpSession session = request.getSession();
     List<CountryEntity> countries = facilityManagementBean.getListOfCountries();
            session.setAttribute("countries", countries);
            Member mem = getMember(email);
            session.setAttribute("member", mem);
            session.setAttribute("memberEmail", mem.getEmail());
            session.setAttribute("memberName", mem.getName());
            
            if(success){
                result = "Successfully Updated!";
                response.sendRedirect("/IS3102_Project-war/B/SG/memberProfile.jsp?goodMsg=" + result);
            }else{
                result = "Unable to Update.";
                response.sendRedirect("/IS3102_Project-war/B/SG/memberProfile.jsp?errMsg=" + result);
            }
        } catch (Exception ex) {
            out.println(ex);
            
        }
    }
    
    public Member getMember(String email) {
        Client client = ClientBuilder.newClient();
        WebTarget target = client
                .target("http://localhost:8080/IS3102_WebService-Student/webresources/entity.memberentity").path("getMember")
                .queryParam("email", email);
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response response = invocationBuilder.get();
        System.out.println("get member status: " + response.getStatus());

        if (response.getStatus() != 200) {
            return null;
        }
        Member member = response.readEntity(new GenericType<Member>() {
        });
        return member;
    }
    
    public boolean updateMember (String name,String email, String phone, String country, String address, String securityQuestion, String securityAnswer,
            String age,String income, String passwordSalt, String passwordHash)
    {
        Client client = ClientBuilder.newClient();

        WebTarget target = client
                .target("http://localhost:8080/IS3102_WebService-Student/webresources/entity.memberentity").path("updateMember");
        Form forms = new Form();
        forms.param("name", name);
        forms.param("email", email);
        forms.param("phone", phone);
        forms.param("country", country);
        forms.param("address", address);
        forms.param("securityQuestion", securityQuestion);
        forms.param("securityAnswer", securityAnswer);
        forms.param("age", age);
        forms.param("income", income);
        forms.param("passwordSalt", passwordSalt);
        forms.param("passwordHash", passwordHash);
     
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response response = invocationBuilder.post(Entity.entity(forms, MediaType.APPLICATION_FORM_URLENCODED));
        System.out.println("status: " + response.getStatus());

     
           if (response.getStatus() != 200) {
            return false;
        }
        return true;
    }
    
    public String generatePasswordSalt() {
        byte[] salt = new byte[16];
        try {
            SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
            sr.nextBytes(salt);
        } catch (NoSuchAlgorithmException ex) {
            System.out.println("\nServer failed to generate password salt.\n" + ex);
        }
        return Arrays.toString(salt);
    }
    
    public String generatePasswordHash(String salt, String password) {
        String passwordHash = null;
        try {
            password = salt + password;
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] bytes = md.digest();
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < bytes.length; i++) {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            passwordHash = sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            System.out.println("\nServer failed to hash password.\n" + ex);
        }
        return passwordHash;
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>


}
