<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.CartItem"%>
<%
    List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
    if (cart == null) {
        cart = (List<CartItem>) session.getAttribute("cart");
    }

    Double total = (Double) request.getAttribute("cartTotal");
    if (total == null) total = 0.0;

    String context = request.getContextPath();
    int cartCount = 0;
    if (cart != null) {
        for (CartItem item : cart) {
            cartCount += item.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Giỏ hàng – HomeElectro</title>
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{
            background:#f0f0f0;
            font-family:'Segoe UI',system-ui,sans-serif;
            color:#222;
            font-size:14px
        }
        a{text-decoration:none;color:inherit}
        img{display:block;max-width:100%}
        :root{
            --red:#d0021b;
            --red2:#a80115;
            --red-bg:#fff0f0;
            --border:#e8e8e8;
            --text:#222;
            --text2:#555;
            --text3:#999;
            --radius:10px;
        }
        .cnt{max-width:1200px;margin:0 auto;padding:0 16px}

        /* ── Header ─────────────────────────────────────────────────────── */
        #site-header{
            background:var(--red);
            position:sticky;top:0;z-index:999;
            box-shadow:0 2px 10px rgba(0,0,0,.25)
        }
        .hd-topbar{
            background:var(--red2);padding:4px 0;
            font-size:12px;color:rgba(255,255,255,.85)
        }
        .hd-topbar-inner{
            display:flex;justify-content:space-between;align-items:center
        }
        .hd-main{padding:10px 0}
        .hd-main-inner{display:flex;align-items:center;gap:14px}
        .hd-logo{
            background:#fff;border-radius:8px;padding:6px 14px;
            font-weight:900;font-size:19px;color:var(--red);
            letter-spacing:-.5px;flex-shrink:0
        }
        .hd-logo span{
            background:rgba(208,2,27,.12);border-radius:4px;padding:0 3px
        }
        .hd-search{flex:1;position:relative;min-width:0}
        .hd-search input{
            width:100%;padding:10px 48px 10px 16px;
            border-radius:8px;border:none;font-size:14px;
            font-family:inherit;outline:none
        }
        .hd-search button{
            position:absolute;right:0;top:0;bottom:0;width:44px;
            background:#111;border:none;border-radius:0 8px 8px 0;
            cursor:pointer;color:#fff;font-size:16px
        }
        .hd-icons{display:flex;gap:6px;flex-shrink:0}
        .hd-icon-btn{
            display:flex;flex-direction:column;align-items:center;gap:2px;
            color:#fff;padding:4px 10px;border-radius:6px;
            cursor:pointer;position:relative;white-space:nowrap
        }
        .hd-icon-btn:hover{background:rgba(255,255,255,.15)}
        .hd-icon-ico{font-size:20px;line-height:1}
        .hd-icon-btn>span{font-size:11px;color:rgba(255,255,255,.9)}
        .hd-badge{
            position:absolute;top:-5px;right:-7px;
            background:#fff;color:var(--red);
            font-size:10px;font-weight:800;border-radius:50%;
            width:16px;height:16px;
            display:flex;align-items:center;justify-content:center
        }
        .hd-catnav{
            background:rgba(0,0,0,.18);
            border-top:1px solid rgba(255,255,255,.1);
            overflow-x:auto;scrollbar-width:none
        }
        .hd-catnav::-webkit-scrollbar{display:none}
        .hd-catnav-inner{display:flex}
        .hd-catitem{
            padding:9px 15px;color:rgba(255,255,255,.9);
            font-size:13px;font-weight:500;white-space:nowrap;
            border-bottom:2px solid transparent;transition:all .15s
        }
        .hd-catitem:hover,.hd-catitem.on{
            color:#fff;border-bottom-color:#fff;background:rgba(255,255,255,.12)
        }

        /* ── Page layout ─────────────────────────────────────────────────── */
        .page-main{padding:16px 0 40px}
        .section{
            background:#fff;border-radius:var(--radius);
            padding:18px 20px;margin-bottom:14px;
            border:1px solid var(--border)
        }
        .sec-hd{
            display:flex;align-items:center;
            justify-content:space-between;margin-bottom:16px
        }
        .sec-title{
            font-size:18px;font-weight:800;color:var(--text);
            display:flex;align-items:center;gap:8px
        }
        .sec-title .sub{font-size:13px;color:var(--text3);font-weight:400}
        .sec-more{
            padding:6px 16px;border:1.5px solid var(--red);
            border-radius:6px;color:var(--red);font-size:13px;
            font-weight:600;transition:all .15s;white-space:nowrap
        }
        .sec-more:hover{background:var(--red);color:#fff}

        /* ── Breadcrumb ──────────────────────────────────────────────────── */
        .breadcrumb{
            display:flex;align-items:center;gap:6px;
            font-size:13px;color:var(--text3);
            margin-bottom:14px;padding:10px 0
        }
        .breadcrumb a{color:var(--text2)}
        .breadcrumb a:hover{color:var(--red)}
        .breadcrumb .sep{color:var(--text3)}
        .breadcrumb .current{color:var(--text);font-weight:600}

        /* ── Cart layout ─────────────────────────────────────────────────── */
        .cart-layout{
            display:grid;
            grid-template-columns:1fr 320px;
            gap:14px;align-items:start
        }
        @media(max-width:900px){.cart-layout{grid-template-columns:1fr}}

        /* ── Cart table ──────────────────────────────────────────────────── */
        .cart-table{width:100%;border-collapse:collapse}
        .cart-table thead tr{border-bottom:2px solid var(--border)}
        .cart-table th{
            padding:10px 12px;font-size:12px;font-weight:700;
            color:var(--text3);text-transform:uppercase;
            letter-spacing:.05em;text-align:left;white-space:nowrap
        }
        .cart-table th.c{text-align:center}
        .cart-table th.r{text-align:right}
        .cart-table td{
            padding:14px 12px;vertical-align:middle;
            border-bottom:1px solid var(--border)
        }
        .cart-table td.c{text-align:center}
        .cart-table td.r{text-align:right}
        .cart-table tbody tr:last-child td{border-bottom:none}
        .cart-table tbody tr:hover{background:#fafafa}

        /* product cell */
        .prod-cell{display:flex;align-items:center;gap:12px}
        .prod-img{
            width:72px;height:72px;object-fit:contain;flex-shrink:0;
            border-radius:8px;border:1px solid var(--border);background:#f8f8f8
        }
        .prod-img-ph{
            width:72px;height:72px;flex-shrink:0;
            border-radius:8px;border:1px solid var(--border);
            background:#f8f8f8;display:flex;align-items:center;
            justify-content:center;font-size:28px
        }
        .prod-name{
            font-size:13.5px;font-weight:600;color:var(--text);
            line-height:1.4;display:-webkit-box;
            -webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden
        }
        .prod-id{font-size:12px;color:var(--text3);margin-top:3px}

        /* price */
        .price{font-size:15px;font-weight:700;color:var(--red)}
        .subtotal{font-size:15px;font-weight:800;color:var(--red)}

        /* stock badge */
        .stock-badge{
            display:inline-block;background:#e0f7e9;color:#16a34a;
            font-size:11px;font-weight:700;padding:3px 9px;border-radius:20px
        }

        /* qty controls */
        .qty-wrap{display:inline-flex;align-items:center}
        .qty-btn{
            width:28px;height:32px;
            border:1px solid var(--border);background:#f5f5f5;
            color:var(--text);font-size:15px;font-weight:700;
            cursor:pointer;transition:background .15s;flex-shrink:0
        }
        .qty-btn:first-child{border-radius:6px 0 0 6px}
        .qty-btn:last-child {border-radius:0 6px 6px 0}
        .qty-btn:hover{background:var(--border)}
        .qty-num{
            width:44px;height:32px;
            border:1px solid var(--border);border-left:none;border-right:none;
            text-align:center;font-size:13px;font-weight:700;
            font-family:inherit;color:var(--text);background:#fff;
            -moz-appearance:textfield
        }
        .qty-num::-webkit-inner-spin-button,
        .qty-num::-webkit-outer-spin-button{-webkit-appearance:none}

        /* remove btn */
        .btn-remove{
            display:inline-flex;align-items:center;justify-content:center;
            width:32px;height:32px;border-radius:6px;
            border:1px solid #ffd6d6;background:#fff5f5;
            color:var(--red);cursor:pointer;
            transition:all .15s;font-size:16px
        }
        .btn-remove:hover{background:var(--red);color:#fff;border-color:var(--red)}

        /* ── Summary card ────────────────────────────────────────────────── */
        .summary-card{position:sticky;top:80px}
        .summary-row{
            display:flex;justify-content:space-between;align-items:center;
            padding:8px 0;font-size:13.5px;border-bottom:1px solid var(--border)
        }
        .summary-row:last-of-type{border-bottom:none}
        .summary-row .lbl{color:var(--text2)}
        .summary-row .val{font-weight:600}
        .summary-total{
            display:flex;justify-content:space-between;align-items:center;
            padding:14px 0 0;margin-top:4px
        }
        .summary-total .lbl{font-size:16px;font-weight:800}
        .summary-total .val{font-size:22px;font-weight:900;color:var(--red)}

        .btn-checkout{
            display:block;width:100%;
            background:var(--red);color:#fff;border:none;
            border-radius:8px;padding:13px;margin-top:16px;
            font-family:inherit;font-size:15px;font-weight:700;
            cursor:pointer;text-align:center;
            transition:background .15s,transform .1s;
            box-shadow:0 4px 14px rgba(208,2,27,.25)
        }
        .btn-checkout:hover{background:var(--red2);transform:translateY(-1px)}

        .btn-outline-red{
            display:block;width:100%;
            border:1.5px solid var(--red);color:var(--red);
            border-radius:8px;padding:10px;margin-top:8px;
            font-family:inherit;font-size:13px;font-weight:600;
            cursor:pointer;text-align:center;background:#fff;
            transition:all .15s
        }
        .btn-outline-red:hover{background:var(--red-bg)}

        .tip-box{
            background:#fffbe6;border:1px solid #ffe58f;
            border-radius:8px;padding:10px 12px;
            font-size:12px;color:#92670a;margin-top:14px;
            line-height:1.6
        }

        /* ── Empty state ─────────────────────────────────────────────────── */
        .empty-state{text-align:center;padding:60px 24px}
        .empty-state .ico{font-size:52px;margin-bottom:16px;opacity:.3}
        .empty-state h3{font-size:20px;font-weight:800;margin-bottom:8px}
        .empty-state p{font-size:14px;color:var(--text3);margin-bottom:24px;line-height:1.6}
        .btn-shop-now{
            display:inline-block;background:var(--red);color:#fff;
            padding:12px 32px;border-radius:8px;font-weight:700;font-size:14px;
            transition:background .15s
        }
        .btn-shop-now:hover{background:var(--red2)}
        .btn-back-home{
            display:inline-block;border:1.5px solid var(--border);color:var(--text2);
            padding:11px 28px;border-radius:8px;font-weight:600;font-size:14px;
            margin-left:10px;transition:all .15s
        }
        .btn-back-home:hover{border-color:var(--red);color:var(--red)}

        /* ── Footer ──────────────────────────────────────────────────────── */
        #site-footer{
            background:#111;color:#fff;padding:40px 0 0;margin-top:20px
        }
        .footer-grid{
            display:grid;grid-template-columns:2fr 1fr 1fr 1fr;
            gap:36px;padding-bottom:32px
        }
        .footer-logo{
            background:var(--red);border-radius:8px;padding:5px 14px;
            display:inline-block;font-weight:900;font-size:19px;
            color:#fff;margin-bottom:14px
        }
        .footer-about p{font-size:13px;color:#aaa;line-height:1.7;margin-bottom:14px}
        .footer-contact{display:flex;flex-direction:column;gap:6px;font-size:13px;color:#aaa}
        .footer-col-title{font-size:14px;font-weight:700;color:#fff;margin-bottom:14px}
        .footer-grid>div a{display:block;font-size:13px;color:#aaa;margin-bottom:8px}
        .footer-grid>div a:hover{color:#fff}
        .footer-bottom{
            border-top:1px solid #2a2a2a;padding:16px 0;
            display:flex;justify-content:space-between;
            font-size:12px;color:#666;flex-wrap:wrap;gap:8px
        }

        /* ── Toast ───────────────────────────────────────────────────────── */
        .toast{
            position:fixed;bottom:24px;right:24px;
            background:#111;color:#fff;padding:12px 18px;
            border-radius:8px;font-size:13px;font-weight:500;
            box-shadow:0 6px 24px rgba(0,0,0,.25);
            transform:translateY(60px);opacity:0;
            transition:all .3s cubic-bezier(.34,1.56,.64,1);
            z-index:9999;pointer-events:none
        }
        .toast.show{transform:translateY(0);opacity:1}
    </style>
</head>
<body>

<!-- ══ HEADER ════════════════════════════════════════════════════════════ -->
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
                    <span class="hd-icon-ico">
                        🛒
                        <span class="hd-badge"><%=cartCount%></span>
                    </span>
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
            <a href="<%=context%>/products?categoryId=1" class="hd-catitem"> Tivi</a>
            <a href="<%=context%>/products?categoryId=2" class="hd-catitem"> Tủ lạnh</a>
            <a href="<%=context%>/products?categoryId=3" class="hd-catitem"> Máy giặt</a>
            <a href="<%=context%>/products?categoryId=4" class="hd-catitem">️ Máy lạnh</a>
            <a href="<%=context%>/products?categoryId=5" class="hd-catitem"> Nhà bếp</a>
            <a href="<%=context%>/products?categoryId=6" class="hd-catitem"> Gia dụng</a>
            <a href="<%=context%>/products?categoryId=7" class="hd-catitem"> Phụ kiện</a>
        </div>
    </nav>
</header>

<!-- ══ MAIN ════════════════════════════════════════════════════════════ -->
<main class="page-main">
    <div class="cnt">

        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="<%=context%>/home">Trang chủ</a>
            <span class="sep">›</span>
            <span class="current">Giỏ hàng</span>
        </div>

        <%
            if (cart == null || cart.isEmpty()) {
        %>
        <!-- ── EMPTY STATE ── -->
        <div class="section">
            <div class="empty-state">
                <div class="ico">🛒</div>
                <h3>Giỏ hàng đang trống</h3>
                <p>Bạn chưa thêm sản phẩm nào vào giỏ hàng.<br>Hãy khám phá hàng ngàn sản phẩm điện máy chính hãng!</p>
                <a href="<%=context%>/products" class="btn-shop-now">🛍️ Mua sắm ngay</a>
                <a href="<%=context%>/home" class="btn-back-home">🏠 Về trang chủ</a>
            </div>
        </div>

        <%
            } else {
        %>
        <!-- ── CART CONTENT ── -->
        <div class="cart-layout">

            <!-- LEFT: Product list -->
            <div>
                <div class="section">
                    <div class="sec-hd">
                        <div class="sec-title">
                            🛒 Giỏ hàng của bạn
                            <span class="sub"><%=cartCount%> sản phẩm</span>
                        </div>
                        <a href="<%=context%>/products" class="sec-more">← Tiếp tục mua hàng</a>
                    </div>

                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th style="width:42%">Sản phẩm</th>
                                <th class="c">Tồn kho</th>
                                <th class="c">Đơn giá</th>
                                <th class="c">Số lượng</th>
                                <th class="r">Thành tiền</th>
                                <th class="c">Xóa</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            for (CartItem item : cart) {
                                String imgSrc = (item.getImage() != null && !item.getImage().isEmpty())
                                    ? context + "/images/products/" + item.getImage() : null;
                        %>
                        <tr>
                            <!-- Product -->
                            <td>
                                <div class="prod-cell">
                                    <% if (imgSrc != null) { %>
                                        <img src="<%=imgSrc%>" alt="<%=item.getProductName()%>"
                                             class="prod-img"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"/>
                                        <div class="prod-img-ph" style="display:none">📦</div>
                                    <% } else { %>
                                        <div class="prod-img-ph">📦</div>
                                    <% } %>
                                    <div>
                                        <div class="prod-name"><%=item.getProductName()%></div>
                                        <div class="prod-id">Mã SP: <%=item.getProductId()%></div>
                                    </div>
                                </div>
                            </td>

                            <!-- Stock -->
                            <td class="c">
                                <span class="stock-badge"><%=item.getStock()%></span>
                            </td>

                            <!-- Unit price -->
                            <td class="c">
                                <span class="price"><%=String.format("%,.0f", item.getPrice())%>đ</span>
                            </td>

                            <!-- Quantity -->
                            <td class="c">
                                <form action="<%=context%>/cart" method="post"
                                      style="display:inline-flex;justify-content:center">
                                    <input type="hidden" name="action"    value="updateQuantity"/>
                                    <input type="hidden" name="productId" value="<%=item.getProductId()%>"/>
                                    <input type="hidden" name="quantity"
                                           id="hq_<%=item.getProductId()%>"
                                           value="<%=item.getQuantity()%>"/>
                                    <div class="qty-wrap">
                                        <button type="button" class="qty-btn"
                                            onclick="changeQty(<%=item.getProductId()%>,-1,<%=item.getStock()%>,this.closest('form'))">−</button>
                                        <input type="number" class="qty-num"
                                               id="dq_<%=item.getProductId()%>"
                                               value="<%=item.getQuantity()%>"
                                               min="1" max="<%=item.getStock()%>"
                                               onchange="syncQty(<%=item.getProductId()%>,this.value,<%=item.getStock()%>,this.closest('form'))"/>
                                        <button type="button" class="qty-btn"
                                            onclick="changeQty(<%=item.getProductId()%>,+1,<%=item.getStock()%>,this.closest('form'))">+</button>
                                    </div>
                                </form>
                            </td>

                            <!-- Subtotal -->
                            <td class="r">
                                <span class="subtotal" id="sub_<%=item.getProductId()%>">
                                    <%=String.format("%,.0f", item.getSubtotal())%>đ
                                </span>
                            </td>

                            <!-- Remove -->
                            <td class="c">
                                <form action="<%=context%>/cart" method="post">
                                    <input type="hidden" name="action"    value="removeItem"/>
                                    <input type="hidden" name="productId" value="<%=item.getProductId()%>"/>
                                    <button type="submit" class="btn-remove" title="Xóa">🗑</button>
                                </form>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- RIGHT: Summary -->
            <div class="summary-card">
                <div class="section">
                    <div class="sec-title" style="margin-bottom:16px">📋 Tóm tắt đơn hàng</div>

                    <div class="summary-row">
                        <span class="lbl">Số sản phẩm</span>
                        <span class="val"><%=cartCount%></span>
                    </div>
                    <div class="summary-row">
                        <span class="lbl">Tạm tính</span>
                        <span class="val"><%=String.format("%,.0f", total)%>đ</span>
                    </div>
                    <div class="summary-row">
                        <span class="lbl">Phí vận chuyển</span>
                        <span class="val" style="color:#16a34a;font-weight:700">Miễn phí</span>
                    </div>
                    <div class="summary-row">
                        <span class="lbl">Giảm giá</span>
                        <span class="val">0đ</span>
                    </div>

                    <div class="summary-total">
                        <span class="lbl">Tổng cộng</span>
                        <span class="val"><%=String.format("%,.0f", total)%>đ</span>
                    </div>

                    <a href="<%=context%>/checkout" class="btn-checkout">
                        💳 Thanh toán ngay
                    </a>
                    <a href="<%=context%>/orders" class="btn-outline-red">
                        📋 Lịch sử đơn hàng
                    </a>

                    <div class="tip-box">
                        💡 Mẹo: Kiểm tra số lượng trước khi thanh toán. Nhấn <strong>+/-</strong> để cập nhật tức thì.
                    </div>
                </div>

                <!-- Promo mini -->
                <div class="section" style="padding:14px 16px">
                    <div style="display:flex;flex-direction:column;gap:8px">
                        <div style="display:flex;align-items:center;gap:10px;font-size:13px">
                            <span style="font-size:18px">🎁</span>
                            <span style="color:var(--text2)">Nhập mã giảm giá tại trang thanh toán</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;font-size:13px">
                            <span style="font-size:18px">🛡️</span>
                            <span style="color:var(--text2)">Bảo hành chính hãng – Đổi trả 30 ngày</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;font-size:13px">
                            <span style="font-size:18px">🚚</span>
                            <span style="color:var(--text2)">Giao hàng 2 giờ nội thành TP.HCM & HN</span>
                        </div>
                    </div>
                </div>
            </div>

        </div><!-- end cart-layout -->
        <%
            }
        %>

    </div><!-- end cnt -->
</main>

<!-- ══ FOOTER ════════════════════════════════════════════════════════════ -->
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

<!-- ══ TOAST ══════════════════════════════════════════════════════════════ -->
<div class="toast" id="toast"></div>

<script>
    function changeQty(productId, delta, stock, form) {
        var dq  = document.getElementById('dq_'  + productId);
        var hq  = document.getElementById('hq_'  + productId);
        var val = parseInt(dq.value) + delta;
        if (val < 1)     val = 1;
        if (val > stock) { showToast('Không đủ số lượng tồn kho!'); val = stock; }
        dq.value = val;
        hq.value = val;
        form.submit();
    }

    function syncQty(productId, rawVal, stock, form) {
        var dq  = document.getElementById('dq_'  + productId);
        var hq  = document.getElementById('hq_'  + productId);
        var val = parseInt(rawVal);
        if (isNaN(val) || val < 1) val = 1;
        if (val > stock) { showToast('Không đủ số lượng tồn kho!'); val = stock; }
        dq.value = val;
        hq.value = val;
        form.submit();
    }

    function showToast(msg) {
        var t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(function(){ t.classList.remove('show'); }, 2500);
    }
</script>

</body>
</html>
