package dao;

import java.sql.*;
import java.util.*;
import model.Order;

public class OrderDAO extends DBContext {

    /** Thêm đơn hàng mới, trả về orderId */
    public int insertOrder(Order order) {
        String sql = "INSERT INTO Orders(userId,couponId,discountAmount,totalAmount,"
                + "shippingAddress,phoneReceiver,receiverName,note,paymentMethod,paymentStatus,status) "
                + "VALUES(?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getUserId());
            ps.setObject(2, order.getCouponId());
            ps.setDouble(3, order.getDiscountAmount());
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getShippingAddress());
            ps.setString(6, order.getPhoneReceiver());
            ps.setString(7, order.getReceiverName());
            ps.setString(8, order.getNote());
            ps.setString(9, order.getPaymentMethod());
            ps.setString(10, order.getPaymentStatus() != null ? order.getPaymentStatus() : "Unpaid");
            ps.setString(11, order.getStatus() != null ? order.getStatus() : "Pending");
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    /** Lấy danh sách đơn hàng của 1 user */
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE userId=? ORDER BY orderDate DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractOrder(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy tất cả đơn hàng (Admin) */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY orderDate DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(extractOrder(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy đơn hàng theo ID */
    public Order getById(int id) {
        String sql = "SELECT * FROM Orders WHERE id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractOrder(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Cập nhật trạng thái đơn hàng */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status=?, updatedDate=GETDATE() WHERE id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /** Đếm tổng số đơn hàng */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private Order extractOrder(ResultSet rs) throws Exception {
        return new Order(
                rs.getInt("id"),
                rs.getInt("userId"),
                (Integer) rs.getObject("couponId"),
                rs.getDouble("discountAmount"),
                rs.getTimestamp("orderDate"),
                rs.getDouble("totalAmount"),
                rs.getString("shippingAddress"),
                rs.getString("phoneReceiver"),
                rs.getString("receiverName"),
                rs.getString("note"),
                rs.getString("paymentMethod"),
                rs.getString("paymentStatus"),
                rs.getString("status"),
                rs.getTimestamp("updatedDate")
        );
    }
}
