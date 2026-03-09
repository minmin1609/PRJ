package model;

public class OrderDetail {
    private int id;
    private int orderId;
    private int productId;
    private int quantity;
    private double price;
    private double discount;

    // Thêm để hiển thị trên trang orders
    private String productName;
    private String productImage;

    public OrderDetail() {}

    public OrderDetail(int id, int orderId, int productId, int quantity, double price) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
    }

    public double getSubtotal() { return quantity * price; }

    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public int getOrderId()                 { return orderId; }
    public void setOrderId(int orderId)     { this.orderId = orderId; }

    public int getProductId()               { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity()                { return quantity; }
    public void setQuantity(int quantity)   { this.quantity = quantity; }

    public double getPrice()                { return price; }
    public void setPrice(double price)      { this.price = price; }

    public double getDiscount()             { return discount; }
    public void setDiscount(double discount){ this.discount = discount; }

    public String getProductName()                  { return productName; }
    public void setProductName(String productName)  { this.productName = productName; }

    public String getProductImage()                 { return productImage; }
    public void setProductImage(String productImage){ this.productImage = productImage; }
}
