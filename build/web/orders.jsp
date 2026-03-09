<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="java.util.List, java.util.Map"%>
<%@page import="model.Order"%>
<%@page import="model.OrderDetail"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    int cartCount = 0;
    List cartSession = (List) session.getAttribute("cart");
    if (cartSession != null) {
        for (Object ci : cartSession) {
            try {
                cartCount += (int) ci.getClass().getMethod("getQuantity").invoke(ci);
            } catch (Exception ignored) {}
        }
    }
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Đơn hàng của tôi – HomeElectro</title>
<style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{background:#f0f0f0;font-family:'Segoe UI',system-ui,sans-serif;color:#222;font-size:14px}
    a{text-decoration:none;color:inherit}
    img{display:block;max-width:100%}
    :root{
        --red:#d0021b;--red2:#a80115;--red-bg:#fff0f0;
        --border:#e8e8e8;--text:#222;--text2:#555;--text3:#999;
        --radius:10px;
    }
    .cnt{max-width:1200px;margin:0 auto;padding:0 16px}

    /* ── Header ── */
    #site-header{background:var(--red);position:sticky;top:0;z-index:999;box-shadow:0 2px 10px rgba(0,0,0,.25)}
    .hd-topbar{background:var(--red2);padding:4px 0;font-size:12px;color:rgba(255,255,255,.85)}
    .hd-topbar-inner{display:flex;justify-content:space-between;align-items:center}
    .hd-main{padding:10px 0}
    .hd-main-inner{display:flex;align-items:center;gap:14px}
    .hd-logo{background:#fff;border-radius:8px;padding:6px 14px;font-weight:900;font-size:19px;color:var(--red);letter-spacing:-.5px;flex-shrink:0}
    .hd-logo span{background:rgba(208,2,27,.12);border-radius:4px;padding:0 3px}
    .hd-search{flex:1;position:relative;min-width:0}
    .hd-search input{width:100%;padding:10px 48px 10px 16px;border-radius:8px;border:none;font-size:14px;font-family:inherit;outline:none}
    .hd-search button{position:absolute;right:0;top:0;bottom:0;width:44px;background:#111;border:none;border-radius:0 8px 8px 0;cursor:pointer;color:#fff;font-size:16px}
    .hd-icons{display:flex;gap:6px;flex-shrink:0}
    .hd-icon-btn{display:flex;flex-direction:column;align-items:center;gap:2px;color:#fff;padding:4px 10px;border-radius:6px;cursor:pointer;position:relative;white-space:nowrap}
    .hd-icon-btn:hover{background:rgba(255,255,255,.15)}
    .hd-icon-ico{font-size:20px;position:relative;line-height:1}
    .hd-icon-btn>span{font-size:11px;color:rgba(255,255,255,.9)}
    .hd-badge{position:absolute;top:-5px;right:-7px;background:#fff;color:var(--red);font-size:10px;font-weight:800;border-radius:50%;width:16px;height:16px;display:flex;align-items:center;justify-content:center}
    .hd-catnav{background:rgba(0,0,0,.18);border-top:1px solid rgba(255,255,255,.1);overflow-x:auto;scrollbar-width:none}
    .hd-catnav::-webkit-scrollbar{display:none}
    .hd-catnav-inner{display:flex}
    .hd-catitem{padding:9px 15px;color:rgba(255,255,255,.9);font-size:13px;font-weight:500;white-space:nowrap;border-bottom:2px solid transparent;transition:all .15s}
    .hd-catitem:hover{color:#fff;border-bottom-color:#fff;background:rgba(255,255,255,.12)}

    /* ── Page ── */
    .page-main{padding:16px 0 48px}
    .section{background:#fff;border-radius:var(--radius);padding:18px 20px;margin-bottom:14px;border:1px solid var(--border)}
    .sec-hd{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
    .sec-title{font-size:18px;font-weight:800;color:var(--text);display:flex;align-items:center;gap:8px}
    .sec-title .sub{font-size:13px;color:var(--text3);font-weight:400}
    .sec-more{padding:6px 16px;border:1.5px solid var(--red);border-radius:6px;color:var(--red);font-size:13px;font-weight:600;transition:all .15s;white-space:nowrap}
    .sec-more:hover{background:var(--red);color:#fff}

    /* ── Breadcrumb ── */
    .breadcrumb{display:flex;align-items:center;gap:6px;font-size:13px;color:var(--text3);margin-bottom:14px}
    .breadcrumb a{color:var(--text2)}
    .breadcrumb a:hover{color:var(--red)}
    .breadcrumb .sep{color:var(--text3)}
    .breadcrumb .current{color:var(--text);font-weight:600}

    /* ── Success alert ── */
    .alert-success{
        background:#f0fdf4;border:1.5px solid #bbf7d0;border-radius:8px;
        padding:12px 16px;margin-bottom:14px;
        font-size:13.5px;color:#15803d;font-weight:500;
        display:flex;align-items:center;gap:8px;
    }

    /* ── Empty state ── */
    .empty-state{text-align:center;padding:60px 24px}
    .empty-state .ico{font-size:52px;opacity:.25;margin-bottom:16px}
    .empty-state h3{font-size:20px;font-weight:800;margin-bottom:8px}
    .empty-state p{color:var(--text3);margin-bottom:24px}
    .btn-shop{display:inline-block;background:var(--red);color:#fff;padding:12px 32px;border-radius:8px;font-weight:700;font-size:14px}
    .btn-shop:hover{background:var(--red2)}

    /* ── Order card ── */
    .order-card{
        background:#fff;border:1px solid var(--border);
        border-radius:var(--radius);margin-bottom:14px;
        overflow:hidden;transition:box-shadow .15s;
    }
    .order-card:hover{box-shadow:0 4px 18px rgba(0,0,0,.08)}

    /* Order header */
    .order-hd{
        display:flex;align-items:center;justify-content:space-between;
        padding:14px 20px;border-bottom:1px solid var(--border);
        background:#fafafa;flex-wrap:wrap;gap:10px;
    }
    .order-id{font-size:15px;font-weight:800;color:var(--text)}
    .order-id span{color:var(--red)}
    .order-meta{display:flex;align-items:center;gap:16px;flex-wrap:wrap}
    .order-date{font-size:12px;color:var(--text3)}
    .order-pay-method{
        font-size:12px;font-weight:600;padding:3px 10px;
        border-radius:20px;background:#f0f4ff;color:#2563eb;
        border:1px solid #c7d7ff;
    }

    /* Status badges */
    .status-badge{
        font-size:12px;font-weight:700;padding:4px 12px;
        border-radius:20px;white-space:nowrap;
    }
    .status-Pending   {background:#fff7ed;color:#c2410c;border:1px solid #fed7aa}
    .status-Processing{background:#eff6ff;color:#1d4ed8;border:1px solid #bfdbfe}
    .status-Shipping  {background:#f0f9ff;color:#0369a1;border:1px solid #bae6fd}
    .status-Completed {background:#f0fdf4;color:#15803d;border:1px solid #bbf7d0}
    .status-Cancelled {background:#fef2f2;color:#b91c1c;border:1px solid #fecaca}

    /* Payment status */
    .pay-status-Unpaid{color:#c2410c;font-weight:700;font-size:12px}
    .pay-status-Paid  {color:#15803d;font-weight:700;font-size:12px}

    /* Order body */
    .order-body{padding:16px 20px}

    /* Product list inside order */
    .order-products{display:flex;flex-direction:column;gap:10px;margin-bottom:14px}
    .order-product{
        display:flex;align-items:center;gap:12px;
        padding:10px 14px;border-radius:8px;
        border:1px solid var(--border);background:#fafafa;
        transition:all .15s;
    }
    .order-product:hover{border-color:var(--red);background:var(--red-bg);transform:translateX(3px)}
    .op-img{
        width:60px;height:60px;object-fit:contain;flex-shrink:0;
        border-radius:6px;border:1px solid var(--border);background:#fff;
    }
    .op-img-ph{
        width:60px;height:60px;flex-shrink:0;border-radius:6px;
        border:1px solid var(--border);background:#fff;
        display:flex;align-items:center;justify-content:center;font-size:24px;
    }
    .op-info{flex:1;min-width:0}
    .op-name{
        font-size:13.5px;font-weight:600;color:var(--text);line-height:1.35;
        display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;
        transition:color .15s;
    }
    .order-product:hover .op-name{color:var(--red)}
    .op-meta{display:flex;align-items:center;gap:10px;margin-top:4px;flex-wrap:wrap}
    .op-qty{font-size:12px;color:var(--text3)}
    .op-unit{font-size:12px;color:var(--text2)}
    .op-subtotal{font-size:14px;font-weight:700;color:var(--red);white-space:nowrap;flex-shrink:0}

    /* Order footer */
    .order-ft{
        display:flex;align-items:center;justify-content:space-between;
        padding:12px 20px;border-top:1px solid var(--border);
        background:#fafafa;flex-wrap:wrap;gap:10px;
    }
    .order-addr{font-size:12px;color:var(--text2);display:flex;align-items:flex-start;gap:6px;flex:1;min-width:0}
    .order-addr-text{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    .order-total-wrap{display:flex;align-items:center;gap:12px;flex-shrink:0}
    .order-total-lbl{font-size:13px;color:var(--text2)}
    .order-total-val{font-size:18px;font-weight:900;color:var(--red)}

    /* Collapse toggle */
    .toggle-btn{
        background:none;border:none;cursor:pointer;
        font-size:12px;color:var(--red);font-weight:600;
        font-family:inherit;padding:0;display:flex;align-items:center;gap:4px;
        transition:opacity .15s;
    }
    .toggle-btn:hover{opacity:.7}
    .toggle-icon{display:inline-block;transition:transform .2s}
    .toggle-icon.open{transform:rotate(180deg)}

    .products-wrap{overflow:hidden;transition:max-height .3s ease}
    .products-wrap.collapsed{max-height:0}
    .products-wrap.expanded{max-height:9999px}

    /* ── Footer ── */
    #site-footer{background:#111;color:#fff;padding:40px 0 0;margin-top:20px}
    .footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:36px;padding-bottom:32px}
    .footer-logo{background:var(--red);border-radius:8px;padding:5px 14px;display:inline-block;font-weight:900;font-size:19px;color:#fff;margin-bottom:14px}
    .footer-about p{font-size:13px;color:#aaa;line-height:1.7;margin-bottom:14px}
    .footer-contact{display:flex;flex-direction:column;gap:6px;font-size:13px;color:#aaa}
    .footer-col-title{font-size:14px;font-weight:700;color:#fff;margin-bottom:14px}
    .footer-grid>div a{display:block;font-size:13px;color:#aaa;margin-bottom:8px}
    .footer-grid>div a:hover{color:#fff}
    .footer-bottom{border-top:1px solid #2a2a2a;padding:16px 0;display:flex;justify-content:space-between;font-size:12px;color:#666;flex-wrap:wrap;gap:8px}
</style>
</head>
<body>

<!-- ══ HEADER ══ -->
<header id="site-header">
    <div class="hd-topbar">
        <div class="cnt hd-topbar-inner">
            <span>📞 Hotline: 1800 6868 &nbsp;|&nbsp; ✉️ support@homeelectro.vn</span>
            <span>🚚 Miễn phí vận chuyển đơn từ 500K &nbsp;|&nbsp; 🔄 Đổi trả 30 ngày</span>
        </div>
    </div>
    <div class="hd-main">
        <div class="cnt hd-main-inner">
            <a href="<%=context%>/home" class="hd-logo">Home<span>Electro</span></a>
            <div class="hd-search">
                <form action="<%=context%>/search" method="get">
                    <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm, thương hiệu..."/>
                    <button type="submit">🔍</button>
                </form>
            </div>
            <div class="hd-icons">
                <a href="<%=context%>/wishlist" class="hd-icon-btn">
                    <span class="hd-icon-ico">♡</span>
                    <span>Yêu thích</span>
                </a>
                <a href="<%=context%>/cart" class="hd-icon-btn">
                    <span class="hd-icon-ico">🛒<span class="hd-badge"><%=cartCount%></span></span>
                    <span>Giỏ hàng</span>
                </a>
                <a href="<%=context%>/profile" class="hd-icon-btn">
                    <span class="hd-icon-ico">👤</span>
                    <span>Tài khoản</span>
                </a>
            </div>
        </div>
    </div>
    <nav class="hd-catnav">
        <div class="cnt hd-catnav-inner">
            <a href="<%=context%>/products?categoryId=1" class="hd-catitem">📺 Tivi</a>
            <a href="<%=context%>/products?categoryId=2" class="hd-catitem">🧊 Tủ lạnh</a>
            <a href="<%=context%>/products?categoryId=3" class="hd-catitem">🫧 Máy giặt</a>
            <a href="<%=context%>/products?categoryId=4" class="hd-catitem">❄️ Máy lạnh</a>
            <a href="<%=context%>/products?categoryId=5" class="hd-catitem">🍳 Nhà bếp</a>
            <a href="<%=context%>/products?categoryId=6" class="hd-catitem">🏠 Gia dụng</a>
            <a href="<%=context%>/products?categoryId=7" class="hd-catitem">🔌 Phụ kiện</a>
        </div>
    </nav>
</header>

<!-- ══ MAIN ══ -->
<main class="page-main">
<div class="cnt">

    <!-- Breadcrumb -->
    <div class="breadcrumb">
        <a href="<%=context%>/home">Trang chủ</a>
        <span class="sep">›</span>
        <span class="current">Đơn hàng của tôi</span>
    </div>

    <!-- Success message from checkout -->
    <c:if test="${not empty sessionScope.success}">
        <div class="alert-success">
            ✅ ${sessionScope.success}
            <c:remove var="success" scope="session"/>
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert-success">
            ✅ ${sessionScope.successMsg}
            <c:remove var="successMsg" scope="session"/>
        </div>
    </c:if>

    <!-- Heading -->
    <div class="section" style="padding:16px 20px">
        <div class="sec-hd">
            <div class="sec-title">
                📋 Đơn hàng của tôi
                <span class="sub">${fn:length(orders)} đơn hàng</span>
            </div>
            <a href="<%=context%>/products" class="sec-more">🛍️ Mua thêm →</a>
        </div>
    </div>

    <!-- Order list -->
    <c:choose>
    <c:when test="${empty orders}">
        <div class="section">
            <div class="empty-state">
                <div class="ico">📦</div>
                <h3>Bạn chưa có đơn hàng nào</h3>
                <p>Hãy khám phá hàng ngàn sản phẩm điện máy chính hãng và đặt hàng ngay!</p>
                <a href="<%=context%>/products" class="btn-shop">🛍️ Mua sắm ngay</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <c:forEach var="o" items="${orders}" varStatus="loop">
        <%-- Lấy details của đơn này từ map --%>
        <c:set var="details" value="${detailsMap[o.id]}"/>

        <div class="order-card">

            <!-- Order header -->
            <div class="order-hd">
                <div>
                    <div class="order-id">Đơn hàng <span>#${o.id}</span></div>
                    <div class="order-date" style="margin-top:3px">
                        🕐 <fmt:formatDate value="${o.orderDate}" pattern="HH:mm dd/MM/yyyy"/>
                    </div>
                </div>
                <div class="order-meta">
                    <span class="order-pay-method">
                        <c:choose>
                            <c:when test="${o.paymentMethod == 'COD'}">🚚 COD</c:when>
                            <c:otherwise>🏦 Banking</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="pay-status-${o.paymentStatus}">
                        <c:choose>
                            <c:when test="${o.paymentStatus == 'Paid'}">✅ Đã thanh toán</c:when>
                            <c:otherwise>⏳ Chưa thanh toán</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="status-badge status-${o.status}">
                        <c:choose>
                            <c:when test="${o.status == 'Pending'}">⏳ Chờ xác nhận</c:when>
                            <c:when test="${o.status == 'Processing'}">🔧 Đang xử lý</c:when>
                            <c:when test="${o.status == 'Shipping'}">🚚 Đang giao hàng</c:when>
                            <c:when test="${o.status == 'Completed'}">✅ Hoàn thành</c:when>
                            <c:when test="${o.status == 'Cancelled'}">❌ Đã hủy</c:when>
                            <c:otherwise>${o.status}</c:otherwise>
                        </c:choose>
                    </span>
                    <button class="toggle-btn" onclick="toggleOrder(${o.id}, this)">
                        <span>Xem sản phẩm</span>
                        <span class="toggle-icon open" id="icon-${o.id}">▲</span>
                    </button>
                </div>
            </div>

            <!-- Product details (collapsible) -->
            <div class="order-body">
                <div class="products-wrap expanded" id="products-${o.id}">
                    <div class="order-products">
                        <c:choose>
                        <c:when test="${not empty details}">
                            <c:forEach var="d" items="${details}">
                            <a href="<%=context%>/productdetail?id=${d.productId}" class="order-product">
                                <c:choose>
                                    <c:when test="${not empty d.productImage}">
                                        <img src="<%=context%>/images/products/${d.productImage}"
                                             alt="${d.productName}" class="op-img"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"/>
                                        <div class="op-img-ph" style="display:none">📦</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="op-img-ph">📦</div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="op-info">
                                    <div class="op-name">
                                        <c:choose>
                                            <c:when test="${not empty d.productName}">${d.productName}</c:when>
                                            <c:otherwise>Sản phẩm #${d.productId}</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="op-meta">
                                        <span class="op-qty">Số lượng: ${d.quantity}</span>
                                        <span class="op-unit">
                                            Đơn giá: <fmt:formatNumber value="${d.price}" pattern="#,###"/>đ
                                        </span>
                                    </div>
                                </div>
                                <div class="op-subtotal">
                                    <fmt:formatNumber value="${d.quantity * d.price}" pattern="#,###"/>đ
                                </div>
                            </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="color:var(--text3);font-size:13px;padding:8px 0">
                                Không có chi tiết sản phẩm.
                            </div>
                        </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Order footer -->
            <div class="order-ft">
                <div class="order-addr">
                    <span>📍</span>
                    <span class="order-addr-text">
                        ${o.receiverName} · ${o.phoneReceiver} · ${o.shippingAddress}
                    </span>
                </div>
                <div class="order-total-wrap">
                    <span class="order-total-lbl">Tổng cộng:</span>
                    <span class="order-total-val">
                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>đ
                    </span>
                </div>
            </div>

        </div><%-- end order-card --%>
        </c:forEach>
    </c:otherwise>
    </c:choose>

</div>
</main>

<!-- ══ FOOTER ══ -->
<footer id="site-footer">
    <div class="cnt">
        <div class="footer-grid">
            <div class="footer-about">
                <div class="footer-logo">HomeElectro</div>
                <p>Hệ thống điện máy chính hãng hàng đầu Việt Nam với hơn 1.000 sản phẩm từ các thương hiệu uy tín.</p>
                <div class="footer-contact">
                    <span>📞 Hotline: 1800 6868</span>
                    <span>✉️ support@homeelectro.vn</span>
                    <span>📍 123 Nguyễn Trãi, Hà Nội</span>
                </div>
            </div>
            <div>
                <div class="footer-col-title">Danh mục</div>
                <a href="<%=context%>/products?categoryId=1">Tivi</a>
                <a href="<%=context%>/products?categoryId=2">Tủ lạnh</a>
                <a href="<%=context%>/products?categoryId=3">Máy giặt</a>
                <a href="<%=context%>/products?categoryId=4">Máy lạnh</a>
                <a href="<%=context%>/products?categoryId=5">Nhà bếp</a>
            </div>
            <div>
                <div class="footer-col-title">Hỗ trợ</div>
                <a href="#">Chính sách đổi trả</a>
                <a href="#">Bảo hành</a>
                <a href="#">Hướng dẫn mua hàng</a>
                <a href="#">Câu hỏi thường gặp</a>
            </div>
            <div>
                <div class="footer-col-title">Tài khoản</div>
                <a href="<%=context%>/profile">Hồ sơ cá nhân</a>
                <a href="<%=context%>/orders">Lịch sử đơn hàng</a>
                <a href="<%=context%>/wishlist">Yêu thích</a>
                <a href="<%=context%>/cart">Giỏ hàng</a>
            </div>
        </div>
        <div class="footer-bottom">
            <span>© 2025 HomeElectro – Điện máy chính hãng</span>
            <span>Thiết kế bởi HomeElectro Team</span>
        </div>
    </div>
</footer>

<script>
    function toggleOrder(orderId, btn) {
        var wrap = document.getElementById('products-' + orderId);
        var icon = document.getElementById('icon-' + orderId);
        var isOpen = wrap.classList.contains('expanded');
        if (isOpen) {
            wrap.classList.remove('expanded');
            wrap.classList.add('collapsed');
            icon.classList.remove('open');
            btn.querySelector('span').textContent = 'Xem sản phẩm';
        } else {
            wrap.classList.remove('collapsed');
            wrap.classList.add('expanded');
            icon.classList.add('open');
            btn.querySelector('span').textContent = 'Ẩn sản phẩm';
        }
    }
</script>

</body>
</html>
