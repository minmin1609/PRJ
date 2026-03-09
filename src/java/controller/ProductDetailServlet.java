package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.Product;

import java.io.IOException;
import java.util.List;

public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            int        productId  = Integer.parseInt(idParam);
            ProductDAO productDAO = new ProductDAO();
            Product    product    = productDAO.getById(productId);

            if (product == null) {
                res.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            List<Product> relatedProducts = productDAO.getRelatedProducts(
                    product.getCategoryId(), productId, 6);

            req.setAttribute("product",         product);
            req.setAttribute("relatedProducts", relatedProducts);
            req.getRequestDispatcher("/productdetail.jsp").forward(req, res);

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
