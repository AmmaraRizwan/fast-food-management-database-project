
let currentRole = 'customer';
let currentUser = null;
let currentUserId = null;
let cart = [];
let orders = [];
let reservations = [];

const menu = {
    burgers: [
        { id: 1, name: 'Classic Burger', desc: 'Beef, lettuce, tomato, cheese', price: 2607, image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop' },
        { id: 2, name: 'Chicken Burger', desc: 'Crispy chicken, mayo, lettuce', price: 2317, image: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=400&h=300&fit=crop' },
        { id: 3, name: 'Double Cheese', desc: 'Two patties, double cheese', price: 3477, image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400&h=300&fit=crop' },
        { id: 4, name: 'Bacon Burger', desc: 'Beef, bacon, cheese, sauce', price: 3187, image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400&h=300&fit=crop' },
        { id: 5, name: 'Veggie Burger', desc: 'Plant-based, vegan sauce', price: 2897, image: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=400&h=300&fit=crop' }
    ],
    pizza: [
        { id: 6, name: 'Pepperoni Pizza', desc: 'Classic pepperoni, mozzarella', price: 3767, image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&h=300&fit=crop' },
        { id: 7, name: 'Margherita', desc: 'Tomato, mozzarella, basil', price: 3187, image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=300&fit=crop' },
        { id: 8, name: 'BBQ Chicken', desc: 'BBQ sauce, chicken, onions', price: 4057, image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=300&fit=crop' },
        { id: 9, name: 'Hawaiian', desc: 'Ham, pineapple, cheese', price: 3477, image: 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=300&fit=crop' },
        { id: 10, name: 'Veggie Supreme', desc: 'Mushrooms, peppers, olives', price: 3622, image: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400&h=300&fit=crop' },
        { id: 11, name: 'Meat Lovers', desc: 'Pepperoni, sausage, bacon', price: 4347, image: 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400&h=300&fit=crop' }
    ],
    sides: [
        { id: 12, name: 'French Fries', desc: 'Crispy golden fries', price: 1157, image: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&h=300&fit=crop' },
        { id: 13, name: 'Nuggets (8pc)', desc: 'Tender chicken nuggets', price: 1737, image: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&h=300&fit=crop' },
        { id: 14, name: 'Onion Rings', desc: 'Crispy onion rings', price: 1302, image: 'https://images.unsplash.com/photo-1639024471283-03518883512d?w=400&h=300&fit=crop' },
        { id: 15, name: 'Mozzarella Sticks', desc: 'With marinara sauce', price: 1592, image: 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=400&h=300&fit=crop' },
        { id: 16, name: 'Loaded Fries', desc: 'Cheese, bacon, sour cream', price: 2027, image: 'https://images.unsplash.com/photo-1639744091413-b0c2e20b5b07?w=400&h=300&fit=crop' },
        { id: 17, name: 'Buffalo Wings', desc: 'Spicy wings (10pc)', price: 2607, image: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=400&h=300&fit=crop' },
        { id: 18, name: 'Caesar Salad', desc: 'Romaine, parmesan, croutons', price: 1737, image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop' }
    ],
    drinks: [
        { id: 19, name: 'Coca Cola', desc: 'Classic cola 500ml', price: 722, image: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=300&fit=crop' },
        { id: 20, name: 'Sprite', desc: 'Lemon-lime soda', price: 722, image: 'https://images.unsplash.com/photo-1581006852262-e4307cf6283a?w=400&h=300&fit=crop' },
        { id: 21, name: 'Fanta Orange', desc: 'Orange soda', price: 722, image: 'https://images.unsplash.com/photo-1624517452488-04869289c4ca?w=400&h=300&fit=crop' },
        { id: 22, name: 'Orange Juice', desc: 'Fresh squeezed', price: 1012, image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=300&fit=crop' },
        { id: 23, name: 'Apple Juice', desc: 'Pure apple juice', price: 1012, image: 'https://images.unsplash.com/photo-1560781290-7dc94c0f8f4f?w=400&h=300&fit=crop' },
        { id: 24, name: 'Chocolate Shake', desc: 'Creamy chocolate', price: 1447, image: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&h=300&fit=crop' },
        { id: 25, name: 'Strawberry Shake', desc: 'Fresh strawberry', price: 1447, image: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400&h=300&fit=crop' },
        { id: 26, name: 'Vanilla Shake', desc: 'Classic vanilla', price: 1447, image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=300&fit=crop' },
        { id: 27, name: 'Iced Coffee', desc: 'Cold brew coffee', price: 1157, image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400&h=300&fit=crop' },
        { id: 28, name: 'Lemonade', desc: 'Fresh lemonade', price: 867, image: 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=400&h=300&fit=crop' }
    ],
    combos: [
        { id: 29, name: 'Burger Combo', desc: 'Burger + Fries + Drink', price: 3767, combo: true, image: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=400&h=300&fit=crop' },
        { id: 30, name: 'Chicken Meal', desc: 'Chicken + Nuggets + Drink', price: 4637, combo: true, image: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400&h=300&fit=crop' },
        { id: 31, name: 'Pizza Party', desc: '2 Pizzas + Wings + 4 Drinks', price: 11597, combo: true, image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop' },
        { id: 32, name: 'Family Feast', desc: '3 Burgers + Fries + 4 Drinks', price: 10147, combo: true, image: 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=400&h=300&fit=crop' },
        { id: 33, name: 'Kids Happy Meal', desc: 'Mini Burger + Fries + Juice', price: 2317, combo: true, image: 'https://images.unsplash.com/photo-1619221882420-09d6f1c08d6f?w=400&h=300&fit=crop' }
    ]
};

window.onload = function() {
    loadMenu();
    setMinDate();
};

function setMinDate() {
    const today = new Date().toISOString().split('T')[0];
    const dateInput = document.getElementById('resDate');
    if (dateInput) dateInput.min = today;
}

function selectRole(role) {
    currentRole = role;
    document.querySelectorAll('.role-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.closest('.role-btn').classList.add('active');
}

function showRegisterForm() {
    const loginSection = document.getElementById('loginFormSection');
    const registerSection = document.getElementById('registerFormSection');
    
    if (loginSection && registerSection) {
        loginSection.style.display = 'none';
        registerSection.style.display = 'block';
    }
}

function showLoginForm() {
    const loginSection = document.getElementById('loginFormSection');
    const registerSection = document.getElementById('registerFormSection');
    
    if (loginSection && registerSection) {
        loginSection.style.display = 'block';
        registerSection.style.display = 'none';
        
        document.getElementById('regUsername').value = '';
        document.getElementById('regPassword').value = '';
        document.getElementById('regConfirmPassword').value = '';
    }
}

function registerUser(e) {
    e.preventDefault();
    
    const username = document.getElementById('regUsername').value.trim();
    const password = document.getElementById('regPassword').value.trim();
    const confirmPassword = document.getElementById('regConfirmPassword').value.trim();
    
    if (password !== confirmPassword) {
        alert('❌ Passwords do not match!');
        return;
    }
    
    if (username.length < 3) {
        alert('❌ Username must be at least 3 characters!');
        return;
    }
    
    if (password.length < 6) {
        alert('❌ Password must be at least 6 characters!');
        return;
    }
    
    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
        alert('❌ Username can only contain letters, numbers, and underscores!');
        return;
    }
    
    fetch('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('✅ Account created successfully!\n\nYou can now login with your credentials.');
            showLoginForm();
            document.getElementById('username').value = username;
            document.getElementById('password').value = password;
        } else {
            alert('❌ Registration failed: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Registration error:', error);
        alert('❌ Registration failed. Please check if Flask server is running.');
    });
}

function loginUser(e) {
    e.preventDefault();
    
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();
    
    fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password, role: currentRole })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            currentUser = data.user.username;
            currentUserId = data.user.id;
            
            if (data.user.role === 'admin') {
                document.getElementById('loginPage').classList.remove('active');
                document.getElementById('adminSection').classList.add('active');
                loadAdminData();
            } else {
                document.getElementById('userName').textContent = data.user.username;
                document.getElementById('loginPage').classList.remove('active');
                document.getElementById('customerSection').classList.add('active');
                goToPage('homePage');
            }
        } else {
            alert('❌ ' + data.message);
        }
    })
    .catch(error => {
        console.error('Login error:', error);
        alert('❌ Login failed. Please check if Flask server is running on http://localhost:5000');
    });
}

function logout() {
    currentUser = null;
    currentUserId = null;
    cart = [];
    document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
    document.getElementById('loginPage').classList.add('active');
    document.getElementById('username').value = '';
    document.getElementById('password').value = '';
    updateCartCount();
}

function goToPage(pageId) {
    document.querySelectorAll('.content-page').forEach(page => {
        page.style.display = 'none';
    });
    document.getElementById(pageId).style.display = 'block';
    
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    if (event && event.target) {
        const clickedTab = event.target.closest('.tab');
        if (clickedTab) clickedTab.classList.add('active');
    }
    
    if (pageId === 'cartPage') displayCart();
}

function loadMenu() {
    loadCategory('burgers', 'burgersGrid');
    loadCategory('pizza', 'pizzaGrid');
    loadCategory('sides', 'sidesGrid');
    loadCategory('drinks', 'drinksGrid');
    loadCategory('combos', 'combosGrid');
}

function loadCategory(category, gridId) {
    const grid = document.getElementById(gridId);
    if (!grid) return;
    
    grid.innerHTML = '';
    
    menu[category].forEach(item => {
        const itemDiv = document.createElement('div');
        itemDiv.className = 'menu-item';
        itemDiv.innerHTML = `
            <img src="${item.image}" alt="${item.name}">
            <div class="menu-item-info">
                ${item.combo ? '<span class="combo-badge">🎉 COMBO</span>' : ''}
                <h4>${item.name}</h4>
                <p>${item.desc}</p>
                <div class="price">Rs.${item.price.toFixed(0)}</div>
                <button class="add-btn" onclick="addToCart(${item.id})">Add to Cart</button>
            </div>
        `;
        grid.appendChild(itemDiv);
    });
}

function addToCart(itemId) {
    const item = Object.values(menu).flat().find(i => i.id === itemId);
    const cartItem = cart.find(i => i.id === itemId);
    
    if (cartItem) {
        cartItem.quantity++;
    } else {
        cart.push({ ...item, quantity: 1 });
    }
    
    updateCartCount();
    showMessage(`${item.name} added to cart!`);
}

function updateCartCount() {
    const total = cart.reduce((sum, item) => sum + item.quantity, 0);
    document.getElementById('cartCount').textContent = total;
}

function displayCart() {
    const cartDiv = document.getElementById('cartItems');
    
    if (cart.length === 0) {
        cartDiv.innerHTML = '<div class="empty-cart"><h3>Your cart is empty</h3><p>Add items from menu!</p></div>';
        document.getElementById('subtotal').textContent = '0';
        document.getElementById('tax').textContent = '0';
        document.getElementById('totalAmount').textContent = '0';
        return;
    }
    
    let html = '';
    cart.forEach(item => {
        html += `
            <div class="cart-item">
                <div class="cart-item-info">
                    <h4>${item.name}</h4>
                    <p>Rs.${item.price.toFixed(0)} each</p>
                </div>
                <div class="cart-controls">
                    <button class="qty-btn" onclick="changeQuantity(${item.id}, -1)">-</button>
                    <span><strong>${item.quantity}</strong></span>
                    <button class="qty-btn" onclick="changeQuantity(${item.id}, 1)">+</button>
                    <button class="remove-btn" onclick="removeItem(${item.id})">Remove</button>
                </div>
            </div>
        `;
    });
    cartDiv.innerHTML = html;
    
    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const tax = subtotal * 0.08;
    const total = subtotal + tax;
    
    document.getElementById('subtotal').textContent = subtotal.toFixed(0);
    document.getElementById('tax').textContent = tax.toFixed(0);
    document.getElementById('totalAmount').textContent = total.toFixed(0);
}

function changeQuantity(itemId, change) {
    const item = cart.find(i => i.id === itemId);
    if (item) {
        item.quantity += change;
        if (item.quantity <= 0) {
            removeItem(itemId);
        } else {
            displayCart();
            updateCartCount();
        }
    }
}

function removeItem(itemId) {
    cart = cart.filter(i => i.id !== itemId);
    displayCart();
    updateCartCount();
}

function clearCart() {
    if (cart.length === 0) {
        alert('Cart is already empty!');
        return;
    }
    if (confirm('Clear all items from cart?')) {
        cart = [];
        updateCartCount();
        displayCart();
        showMessage('Cart cleared!');
    }
}

function placeOrder() {
    if (cart.length === 0) {
        alert('Your cart is empty!');
        return;
    }
    
    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const tax = subtotal * 0.08;
    const total = subtotal + tax;
    
    const orderData = {
        customer: currentUser,
        items: cart.map(i => `${i.name} x${i.quantity}`).join(', '),
        total: total.toFixed(0),
        user_id: currentUserId
    };
    
    fetch('/api/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(orderData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            cart = [];
            updateCartCount();
            displayCart();
            showMessage(` Order placed successfully! Order ID: #${data.order_id}`);
        } else {
            alert('❌ Failed to place order: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Order error:', error);
        alert('❌ Failed to place order. Please check if Flask server is running.');
    });
}

function makeReservation(e) {
    e.preventDefault();
    
    const reservationData = {
        customer: document.getElementById('resName').value,
        phone: document.getElementById('resPhone').value,
        table: document.getElementById('tableNum').value,
        date: document.getElementById('resDate').value,
        time: document.getElementById('resTime').value,
        guests: document.getElementById('guestCount').value,
        user_id: currentUserId
    };
    
    fetch('/api/reservations', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(reservationData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            e.target.reset();
            showMessage(`🎉 Table reserved successfully! Reservation ID: #${data.reservation_id}`);
        } else {
            alert('❌ Failed to make reservation: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Reservation error:', error);
        alert('❌ Failed to make reservation. Please check if Flask server is running.');
    });
}

function loadAdminData() {
    fetch('/api/orders')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                orders = data.orders;
                renderOrders();
            }
        })
        .catch(error => console.error('Error loading orders:', error));
    
    fetch('/api/reservations')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                reservations = data.reservations;
                renderReservations();
            }
        })
        .catch(error => console.error('Error loading reservations:', error));
    
    fetch('/api/stats')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const stats = data.stats;
                document.getElementById('totalOrders').textContent = stats.total_orders;
                document.getElementById('totalReservations').textContent = stats.total_reservations;
                document.getElementById('totalRevenue').textContent = 'Rs.' + stats.total_revenue.toFixed(0);
                document.getElementById('avgOrderValue').textContent = 'Rs.' + stats.avg_order_value.toFixed(0);
                
                if (stats.top_customer) {
                    document.getElementById('topCustomer').textContent = 
                        `${stats.top_customer.customer_name} (Rs.${parseFloat(stats.top_customer.total_spent).toFixed(0)})`;
                }
                
                if (stats.popular_category) {
                    document.getElementById('popularCategory').textContent = 
                        stats.popular_category.category.toUpperCase();
                }
                
                if (stats.peak_hour) {
                    const hour = stats.peak_hour.peak_hour;
                    const period = hour >= 12 ? 'PM' : 'AM';
                    const displayHour = hour > 12 ? hour - 12 : (hour === 0 ? 12 : hour);
                    document.getElementById('peakHour').textContent = `${displayHour}:00 ${period}`;
                }
                
                if (stats.popular_table) {
                    document.getElementById('popularTable').textContent = 
                        `Table ${stats.popular_table.table_number}`;
                }
            }
        })
        .catch(error => console.error('Error loading stats:', error));
}

function renderOrders() {
    const ordersTable = document.getElementById('ordersTable');
    if (orders.length === 0) {
        ordersTable.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:20px;">No orders yet</td></tr>';
    } else {
        let html = '';
        orders.slice(0, 20).forEach(order => {
            html += `
                <tr>
                    <td>#${order.id}</td>
                    <td>${order.customer_name}</td>
                    <td>${order.items}</td>
                    <td>Rs.${parseFloat(order.total_price).toFixed(0)}</td>
                    <td><span class="status-badge status-${order.status}">${order.status.toUpperCase()}</span></td>
                    <td>${order.order_date}</td>
                </tr>
            `;
        });
        ordersTable.innerHTML = html;
    }
}

function renderReservations() {
    const resTable = document.getElementById('reservationsTable');
    if (reservations.length === 0) {
        resTable.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:20px;">No reservations yet</td></tr>';
    } else {
        let html = '';
        reservations.slice(0, 20).forEach(res => {
            html += `
                <tr>
                    <td>#${res.id}</td>
                    <td>${res.customer_name}</td>
                    <td>${res.phone}</td>
                    <td>Table ${res.table_number}</td>
                    <td>${res.reservation_date}</td>
                    <td>${res.reservation_time}</td>
                    <td>${res.guests}</td>
                </tr>
            `;
        });
        resTable.innerHTML = html;
    }
}

function showMessage(message) {
    const msgBox = document.getElementById('messageBox');
    msgBox.textContent = message;
    msgBox.classList.add('show');
    setTimeout(() => {
        msgBox.classList.remove('show');
    }, 3000);
}