<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.CartItem"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
    int cartCount = 0;
    if (cart != null) {
        for (CartItem item : cart) {
            total += item.getSubtotal();
            cartCount += item.getQuantity();
        }
    }
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Thanh toán – HomeElectro</title>
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
    .sec-title{font-size:18px;font-weight:800;color:var(--text);display:flex;align-items:center;gap:8px;margin-bottom:18px}

    /* ── Breadcrumb ── */
    .breadcrumb{display:flex;align-items:center;gap:6px;font-size:13px;color:var(--text3);margin-bottom:14px}
    .breadcrumb a{color:var(--text2)}
    .breadcrumb a:hover{color:var(--red)}
    .breadcrumb .sep{color:var(--text3)}
    .breadcrumb .current{color:var(--text);font-weight:600}

    /* ── Steps ── */
    .steps{display:flex;align-items:center;gap:0;margin-bottom:20px}
    .step{display:flex;align-items:center;gap:8px;font-size:13px;font-weight:600;color:var(--text3)}
    .step.done .step-num{background:#16a34a;color:#fff;border-color:#16a34a}
    .step.done .step-lbl{color:#16a34a}
    .step.on .step-num{background:var(--red);color:#fff;border-color:var(--red)}
    .step.on .step-lbl{color:var(--red)}
    .step-num{width:28px;height:28px;border-radius:50%;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;flex-shrink:0}
    .step-line{flex:1;height:2px;background:var(--border);margin:0 10px}
    .step-line.done{background:#16a34a}

    /* ── Layout ── */
    .checkout-layout{display:grid;grid-template-columns:1fr 360px;gap:14px;align-items:start}
    @media(max-width:900px){.checkout-layout{grid-template-columns:1fr}}

    /* ── Form elements ── */
    .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
    .form-grid .full{grid-column:1/-1}
    .field{display:flex;flex-direction:column;gap:6px}
    .field label{font-size:13px;font-weight:600;color:var(--text2)}
    .field label .req{color:var(--red)}
    .field input,
    .field textarea,
    .field select{
        width:100%;padding:10px 14px;
        border:1.5px solid var(--border);border-radius:8px;
        font-size:14px;font-family:inherit;color:var(--text);
        background:#fff;outline:none;transition:border-color .15s;
    }
    .field input:focus,
    .field textarea:focus,
    .field select:focus{border-color:var(--red)}
    .field textarea{resize:vertical;min-height:80px}
    .field select{cursor:pointer;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath fill='%23999' d='M6 8L0 0h12z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 14px center}

    /* ── Payment method cards ── */
    .pay-methods{display:grid;grid-template-columns:1fr 1fr;gap:10px}
    .pay-card{
        border:1.5px solid var(--border);border-radius:8px;
        padding:14px 16px;cursor:pointer;transition:all .15s;
        display:flex;align-items:center;gap:10px;position:relative;
    }
    .pay-card:hover{border-color:var(--red)}
    .pay-card.selected{border-color:var(--red);background:var(--red-bg)}
    .pay-card input[type=radio]{position:absolute;opacity:0;width:0;height:0}
    .pay-radio{width:18px;height:18px;border-radius:50%;border:2px solid var(--border);flex-shrink:0;display:flex;align-items:center;justify-content:center;transition:all .15s}
    .pay-card.selected .pay-radio{border-color:var(--red);background:var(--red)}
    .pay-card.selected .pay-radio::after{content:'';width:6px;height:6px;border-radius:50%;background:#fff;display:block}
    .pay-ico{font-size:22px;flex-shrink:0}
    .pay-label{font-weight:600;font-size:13.5px}
    .pay-sub{font-size:11px;color:var(--text3);margin-top:2px}

    /* ── Coupon row ── */
    .coupon-row{display:flex;gap:8px}
    .coupon-row input{flex:1;padding:10px 14px;border:1.5px solid var(--border);border-radius:8px;font-size:14px;font-family:inherit;outline:none;transition:border-color .15s}
    .coupon-row input:focus{border-color:var(--red)}
    .btn-coupon{padding:10px 20px;background:#111;color:#fff;border:none;border-radius:8px;font-family:inherit;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;transition:background .15s}
    .btn-coupon:hover{background:#333}

    /* ── Order summary (right) ── */
    .summary-sticky{position:sticky;top:80px}
    .order-items{display:flex;flex-direction:column;gap:12px;margin-bottom:16px}
    .order-item{display:flex;align-items:center;gap:10px}
    .oi-img{width:52px;height:52px;object-fit:contain;border-radius:6px;border:1px solid var(--border);background:#f8f8f8;flex-shrink:0}
    .oi-img-ph{width:52px;height:52px;border-radius:6px;border:1px solid var(--border);background:#f8f8f8;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
    .oi-name{flex:1;font-size:13px;font-weight:600;line-height:1.35;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
    .oi-qty{font-size:12px;color:var(--text3);margin-top:2px}
    .oi-price{font-size:13px;font-weight:700;color:var(--red);white-space:nowrap;flex-shrink:0}

    .sum-divider{border:none;border-top:1px solid var(--border);margin:14px 0}
    .sum-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;font-size:13.5px}
    .sum-row .lbl{color:var(--text2)}
    .sum-row .val{font-weight:600}
    .sum-total{display:flex;justify-content:space-between;align-items:center;padding-top:12px}
    .sum-total .lbl{font-size:16px;font-weight:800}
    .sum-total .val{font-size:22px;font-weight:900;color:var(--red)}

    /* ── Buttons ── */
    .btn-submit{
        display:block;width:100%;background:var(--red);color:#fff;border:none;
        border-radius:8px;padding:14px;margin-top:16px;
        font-family:inherit;font-size:15px;font-weight:700;cursor:pointer;
        text-align:center;transition:background .15s,transform .1s;
        box-shadow:0 4px 14px rgba(208,2,27,.25);
    }
    .btn-submit:hover{background:var(--red2);transform:translateY(-1px)}
    .btn-back{
        display:block;width:100%;border:1.5px solid var(--border);
        color:var(--text2);border-radius:8px;padding:10px;margin-top:8px;
        font-family:inherit;font-size:13px;font-weight:600;cursor:pointer;
        text-align:center;background:#fff;transition:all .15s;
    }
    .btn-back:hover{border-color:var(--red);color:var(--red)}

    /* ── Trust badges ── */
    .trust-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:14px}
    .trust-item{display:flex;align-items:center;gap:8px;font-size:12px;color:var(--text2)}
    .trust-ico{font-size:16px;flex-shrink:0}

    /* ── Error alert ── */
    .alert-error{
        background:#fff5f5;border:1.5px solid #ffc0c0;border-radius:8px;
        padding:12px 16px;margin-bottom:14px;
        font-size:13.5px;color:#c0021a;font-weight:500;
        display:flex;align-items:center;gap:8px;
    }

    /* ── Empty cart state ── */
    .empty-state{text-align:center;padding:60px 24px}
    .empty-state .ico{font-size:52px;opacity:.25;margin-bottom:16px}
    .empty-state h3{font-size:20px;font-weight:800;margin-bottom:8px}
    .empty-state p{color:var(--text3);margin-bottom:24px}
    .btn-shop{display:inline-block;background:var(--red);color:#fff;padding:12px 32px;border-radius:8px;font-weight:700;font-size:14px}
    .btn-shop:hover{background:var(--red2)}

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
        <a href="<%=context%>/cart">Giỏ hàng</a>
        <span class="sep">›</span>
        <span class="current">Thanh toán</span>
    </div>

    <!-- Steps -->
    <div class="section" style="padding:16px 20px">
        <div class="steps">
            <div class="step done">
                <div class="step-num">✓</div>
                <span class="step-lbl">Giỏ hàng</span>
            </div>
            <div class="step-line done"></div>
            <div class="step on">
                <div class="step-num">2</div>
                <span class="step-lbl">Thanh toán</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <div class="step-num">3</div>
                <span class="step-lbl">Xác nhận</span>
            </div>
        </div>
    </div>

    <!-- Error alert -->
    <c:if test="${not empty error}">
        <div class="alert-error">⚠️ ${error}</div>
    </c:if>

    <%
        if (cart == null || cart.isEmpty()) {
    %>
    <!-- Empty cart -->
    <div class="section">
        <div class="empty-state">
            <div class="ico">🛒</div>
            <h3>Giỏ hàng đang trống</h3>
            <p>Bạn cần thêm sản phẩm vào giỏ trước khi thanh toán.</p>
            <a href="<%=context%>/products" class="btn-shop">🛍️ Mua sắm ngay</a>
        </div>
    </div>
    <%
        } else {
    %>

    <div class="checkout-layout">

        <!-- LEFT: Form -->
        <div>
            <!-- Thông tin giao hàng -->
            <div class="section">
                <div class="sec-title">📦 Thông tin giao hàng</div>
                <form action="<%=context%>/checkout" method="post" id="checkoutForm">
                    <div class="form-grid">
                        <div class="field">
                            <label>Họ tên người nhận <span class="req">*</span></label>
                            <input type="text" name="receiverName" required
                                   placeholder="Nguyễn Văn A"
                                   value="${sessionScope.user.fullname}"/>
                        </div>
                        <div class="field">
                            <label>Số điện thoại <span class="req">*</span></label>
                            <input type="text" name="phoneReceiver" required
                                   placeholder="0900 000 000"
                                   value="${sessionScope.user.phone}"/>
                        </div>
                        <div class="field full">
                            <label>Địa chỉ giao hàng <span class="req">*</span></label>
                            <textarea name="shippingAddress" required
                                      placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
                        </div>
                        <div class="field full">
                            <label>Ghi chú đơn hàng</label>
                            <textarea name="note" placeholder="Ghi chú cho người giao hàng (tùy chọn)" style="min-height:64px"></textarea>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Phương thức thanh toán -->
            <div class="section">
                <div class="sec-title">💳 Phương thức thanh toán</div>
                <div class="pay-methods">
                    <label class="pay-card selected" id="payCOD">
                        <input type="radio" name="paymentMethod" value="COD"
                               form="checkoutForm" checked onchange="selectPay(this)"/>
                        <div class="pay-radio"></div>
                        <span class="pay-ico">🚚</span>
                        <div>
                            <div class="pay-label">Thanh toán khi nhận hàng</div>
                            <div class="pay-sub">COD – Trả tiền mặt khi nhận</div>
                        </div>
                    </label>
                    <label class="pay-card" id="payBanking">
                        <input type="radio" name="paymentMethod" value="Banking"
                               form="checkoutForm" onchange="selectPay(this)"/>
                        <div class="pay-radio"></div>
                        <span class="pay-ico">🏦</span>
                        <div>
                            <div class="pay-label">Chuyển khoản ngân hàng</div>
                            <div class="pay-sub">Banking – Thanh toán online</div>
                        </div>
                    </label>
                </div>
            </div>

            <!-- Mã giảm giá -->
            <div class="section">
                <div class="sec-title">🎁 Mã giảm giá</div>
                <div class="coupon-row">
                    <input type="text" name="couponCode" form="checkoutForm"
                           id="couponInput" placeholder="Nhập mã coupon (VD: SALE10, SALE20)"/>
                    <button type="button" class="btn-coupon" onclick="applyCoupon()">Áp dụng</button>
                </div>
                <div id="couponMsg" style="margin-top:8px;font-size:13px;display:none"></div>
            </div>
        </div>

        <!-- RIGHT: Order summary -->
        <div class="summary-sticky">
            <div class="section">
                <div class="sec-title">🧾 Đơn hàng của bạn</div>

                <!-- Item list -->
                <div class="order-items">
                    <%
                        for (CartItem item : cart) {
                            String imgSrc = (item.getImage() != null && !item.getImage().isEmpty())
                                ? context + "/images/products/" + item.getImage() : null;
                    %>
                    <div class="order-item">
                        <% if (imgSrc != null) { %>
                            <img src="<%=imgSrc%>" alt="<%=item.getProductName()%>" class="oi-img"
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"/>
                            <div class="oi-img-ph" style="display:none">📦</div>
                        <% } else { %>
                            <div class="oi-img-ph">📦</div>
                        <% } %>
                        <div style="flex:1;min-width:0">
                            <div class="oi-name"><%=item.getProductName()%></div>
                            <div class="oi-qty">x<%=item.getQuantity()%></div>
                        </div>
                        <div class="oi-price"><%=String.format("%,.0f", item.getSubtotal())%>đ</div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <hr class="sum-divider"/>

                <div class="sum-row">
                    <span class="lbl">Tạm tính (<%=cartCount%> sp)</span>
                    <span class="val"><%=String.format("%,.0f", total)%>đ</span>
                </div>
                <div class="sum-row">
                    <span class="lbl">Phí vận chuyển</span>
                    <span class="val" style="color:#16a34a;font-weight:700">Miễn phí</span>
                </div>
                <div class="sum-row" id="discountRow" style="display:none">
                    <span class="lbl">Giảm giá</span>
                    <span class="val" style="color:var(--red)" id="discountVal">-0đ</span>
                </div>

                <hr class="sum-divider"/>

                <div class="sum-total">
                    <span class="lbl">Tổng cộng</span>
                    <span class="val" id="grandTotal"><%=String.format("%,.0f", total)%>đ</span>
                </div>

                <button type="submit" form="checkoutForm" class="btn-submit">
                    ✅ Xác nhận đặt hàng
                </button>
                <a href="<%=context%>/cart" class="btn-back">← Quay lại giỏ hàng</a>

                <!-- Trust badges -->
                <div class="trust-grid">
                    <div class="trust-item"><span class="trust-ico">🔒</span>Thanh toán bảo mật</div>
                    <div class="trust-item"><span class="trust-ico">🛡️</span>Bảo hành chính hãng</div>
                    <div class="trust-item"><span class="trust-ico">🔄</span>Đổi trả 30 ngày</div>
                    <div class="trust-item"><span class="trust-ico">🚚</span>Giao hàng 2 giờ</div>
                </div>
            </div>
        </div>

    </div>
    <%
        }
    %>

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
    // Payment method card selection
    function selectPay(radio) {
        document.querySelectorAll('.pay-card').forEach(function(c){ c.classList.remove('selected'); });
        radio.closest('.pay-card').classList.add('selected');
    }

    // Coupon apply (UI only – server validates on submit)
    var baseTotal = <%=total%>;
    function applyCoupon() {
        var code  = document.getElementById('couponInput').value.trim().toUpperCase();
        var msg   = document.getElementById('couponMsg');
        var drow  = document.getElementById('discountRow');
        var dval  = document.getElementById('discountVal');
        var grand = document.getElementById('grandTotal');

        var coupons = { 'SALE10': {type:'percent',val:10}, 'SALE20': {type:'percent',val:20}, 'SALE200K': {type:'fixed',val:200000} };

        if (!code) {
            showMsg(msg, '⚠️ Vui lòng nhập mã giảm giá.', '#c0021a');
            return;
        }
        if (coupons[code]) {
            var c = coupons[code];
            var discount = c.type === 'percent' ? baseTotal * c.val / 100 : c.val;
            var newTotal = Math.max(0, baseTotal - discount);
            dval.textContent  = '-' + formatVND(discount) + 'đ';
            grand.textContent = formatVND(newTotal) + 'đ';
            drow.style.display = 'flex';
            showMsg(msg, '✅ Áp dụng mã <strong>' + code + '</strong> thành công!', '#16a34a');
        } else {
            drow.style.display = 'none';
            grand.textContent = formatVND(baseTotal) + 'đ';
            showMsg(msg, '❌ Mã giảm giá không hợp lệ hoặc đã hết hạn.', '#c0021a');
        }
    }

    function showMsg(el, html, color) {
        el.innerHTML = html;
        el.style.color = color;
        el.style.display = 'block';
    }

    function formatVND(n) {
        return Math.round(n).toLocaleString('vi-VN');
    }

    // Enter key on coupon input
    document.getElementById('couponInput') && document.getElementById('couponInput').addEventListener('keydown', function(e){
        if (e.key === 'Enter') { e.preventDefault(); applyCoupon(); }
    });
</script>

</body>
</html>
