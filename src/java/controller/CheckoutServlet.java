/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import com.sun.jdi.connect.spi.Connection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.CartItem;
import model.Order;
import model.OrderDetail;
import dao.DBContext;
/**
 *
 * @author Personal
 */
@WebServlet(name="CheckoutServlet", urlPatterns={"/checkout"})
public class CheckoutServlet extends HttpServlet {
 private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CheckoutServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckoutServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
      }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) userIdObj;

        String receiverName = request.getParameter("receiverName");
        String phoneReceiver = request.getParameter("phoneReceiver");
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");

        double totalAmount = 0;
        for (CartItem item : cart) {
            totalAmount += item.getSubtotal();
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setCouponId(null);
        order.setDiscountAmount(0);
        order.setTotalAmount(totalAmount);
        order.setShippingAddress(shippingAddress);
        order.setPhoneReceiver(phoneReceiver);
        order.setReceiverName(receiverName);
        order.setNote(note != null ? note : "");
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("Unpaid");
        order.setStatus("Pending");

        int orderId = orderDAO.insertOrder(order);

        if (orderId <= 0) {
            request.setAttribute("error", "Không thể tạo đơn hàng.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        boolean allInserted = true;

        for (CartItem item : cart) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(orderId);
            detail.setProductId(item.getProductId());
            detail.setQuantity(item.getQuantity());
            detail.setPrice(item.getPrice());
            detail.setDiscount(0);

            boolean inserted = orderDetailDAO.insertOrderDetail(detail);
            if (!inserted) {
                allInserted = false;
                break;
            }

            boolean updated = updateProductStock(item.getProductId(), item.getQuantity());
            if (!updated) {
                allInserted = false;
                break;
            }
        }

        if (allInserted) {
            session.removeAttribute("cart");
            session.setAttribute("success", "Đặt hàng thành công! Cảm ơn bạn đã mua hàng.");
            response.sendRedirect(request.getContextPath() + "/orders");
        } else {
            request.setAttribute("error", "Checkout thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }

    private boolean updateProductStock(int productId, int quantity) {
        String sql = "UPDATE Products "
                + "SET stock = stock - ?, sold = sold + ? "
                + "WHERE id = ? AND stock >= ?";

       try (java.sql.Connection conn = new DBContext().getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, productId);
            ps.setInt(4, quantity);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
