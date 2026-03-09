package controller;

import dao.OrderDAO;
import dao.OrderDetailDAO;
import model.Order;
import model.OrderDetail;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) userIdObj;

        // Lấy danh sách đơn hàng
        List<Order> orders = orderDAO.getOrdersByUser(userId);

        // Lấy chi tiết sản phẩm cho mỗi đơn hàng (orderId -> List<OrderDetail>)
        Map<Integer, List<OrderDetail>> detailsMap = new LinkedHashMap<>();
        for (Order o : orders) {
            detailsMap.put(o.getId(), orderDetailDAO.getByOrderId(o.getId()));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("detailsMap", detailsMap);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
