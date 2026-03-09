package dao;

import model.OrderDetail;
import dao.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO {

    public boolean insertOrderDetail(OrderDetail detail) {
        String sql = "INSERT INTO OrderDetails (orderId, productId, quantity, price, discount) "
                + "VALUES (?, ?, ?, ?, ?)";

       try (Connection conn = new DBContext().getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detail.getOrderId());
            ps.setInt(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setDouble(4, detail.getPrice());
            ps.setDouble(5, detail.getDiscount());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy chi tiết đơn hàng kèm tên và ảnh sản phẩm từ bảng Products
     */
    public List<OrderDetail> getByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.name AS productName, p.image AS productImage "
                   + "FROM OrderDetails od "
                   + "LEFT JOIN Products p ON od.productId = p.id "
                   + "WHERE od.orderId = ? ORDER BY od.id ASC";

        try (Connection conn = new DBContext().getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getInt("id"));
                    d.setOrderId(rs.getInt("orderId"));
                    d.setProductId(rs.getInt("productId"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setPrice(rs.getDouble("price"));
                    d.setDiscount(rs.getDouble("discount"));
                    d.setProductName(rs.getString("productName"));
                    d.setProductImage(rs.getString("productImage"));
                    list.add(d);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
