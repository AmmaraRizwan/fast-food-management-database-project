from flask import Flask, request, jsonify, render_template, session
import mysql.connector
from mysql.connector import Error
from datetime import datetime, date
import hashlib
import traceback
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'quickbite-secret-key-2024')

# DATABASE CONFIGURATION - WORKS FOR BOTH LOCAL AND VERCEL
DB_CONFIG = {
    'host': os.environ.get('DB_HOST', 'localhost'),
    'user': os.environ.get('DB_USER', 'root'),
    'password': os.environ.get('DB_PASSWORD', 'rkmsfeA@7'),
    'database': os.environ.get('DB_NAME', 'fastfood_db')
}

def get_db_connection():
    """Create and return a database connection - Works on Vercel with cloud DB"""
    try:
        # Add SSL config for cloud databases (PlanetScale, Railway, etc.)
        config = DB_CONFIG.copy()
        
        # If not localhost, assume cloud database needs SSL
        if config['host'] != 'localhost':
            config['ssl_disabled'] = False
            # For PlanetScale specifically
            if 'psdb.cloud' in config['host']:
                config['ssl_verify_cert'] = False
                config['ssl_verify_identity'] = False
        
        connection = mysql.connector.connect(**config)
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        print(f"Host: {DB_CONFIG['host']}")
        print(f"User: {DB_CONFIG['user']}")
        print(f"Database: {DB_CONFIG['database']}")
        print(traceback.format_exc())
        return None

def hash_password(password):
    """Hash password using MD5"""
    return hashlib.md5(password.encode()).hexdigest()


@app.route('/')
def index():
    """Serve the main HTML page"""
    return render_template('index.html')

@app.route('/api/login', methods=['POST'])
def login():
    """Handle user login"""
    try:
        data = request.json
        username = data.get('username')
        password = data.get('password')
        role = data.get('role')
        
        print(f"Login attempt: username={username}, role={role}")
        
        if not username or not password or not role:
            return jsonify({'success': False, 'message': 'Missing credentials'})
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor(dictionary=True)
        hashed_password = hash_password(password)
        
        cursor.execute(
            "SELECT * FROM users WHERE username=%s AND password=%s AND role=%s",
            (username, hashed_password, role)
        )
        user = cursor.fetchone()
        
        cursor.close()
        conn.close()
        
        if user:
            session['user_id'] = user['id']
            session['username'] = user['username']
            session['role'] = user['role']
            print(f"Login successful for user: {username}")
            return jsonify({
                'success': True,
                'user': {
                    'id': user['id'],
                    'username': user['username'],
                    'role': user['role']
                }
            })
        else:
            print(f"Login failed for user: {username}")
            return jsonify({'success': False, 'message': 'Invalid credentials or role'})
    
    except Exception as e:
        print(f"Login error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

@app.route('/api/register', methods=['POST'])
def register():
    """Register a new customer"""
    try:
        data = request.json
        username = data.get('username')
        password = data.get('password')
        email = data.get('email', f'{username}@quickbite.com')
        
        if not username or not password:
            return jsonify({'success': False, 'message': 'Missing credentials'})
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor()
        hashed_password = hash_password(password)
        
        try:
            cursor.execute(
                "INSERT INTO users (username, password, role, email) VALUES (%s, %s, 'customer', %s)",
                (username, hashed_password, email)
            )
            conn.commit()
            user_id = cursor.lastrowid
            
            cursor.close()
            conn.close()
            
            return jsonify({'success': True, 'user_id': user_id})
        
        except mysql.connector.IntegrityError as e:
            cursor.close()
            conn.close()
            if 'username' in str(e):
                return jsonify({'success': False, 'message': 'Username already exists'})
            elif 'email' in str(e):
                return jsonify({'success': False, 'message': 'Email already exists'})
            else:
                return jsonify({'success': False, 'message': 'Registration failed'})
    
    except Exception as e:
        print(f"Registration error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

@app.route('/api/orders', methods=['POST'])
def create_order():
    """Create a new order"""
    try:
        data = request.json
        customer = data.get('customer')
        items = data.get('items')
        total = data.get('total')
        user_id = data.get('user_id', 2)  
        
        print(f"Creating order: customer={customer}, items={items}, total={total}")
        
        if not customer or not items or not total:
            return jsonify({'success': False, 'message': 'Missing order data'})
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor()
        
        now = datetime.now()
        order_date = now.date()
        order_time = now.time()
        
        cursor.execute(
            """INSERT INTO orders (user_id, customer_name, items, total_price, status, order_date, order_time) 
               VALUES (%s, %s, %s, %s, 'pending', %s, %s)""",
            (user_id, customer, items, total, order_date, order_time)
        )
        conn.commit()
        order_id = cursor.lastrowid
        
        print(f"Order created with ID: {order_id}")
        
        cursor.close()
        conn.close()
        
        return jsonify({'success': True, 'order_id': order_id})
    
    except Exception as e:
        print(f"Order creation error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

@app.route('/api/orders', methods=['GET'])
def get_orders():
    """Get all orders"""
    try:
        print("Fetching orders...")
        
        conn = get_db_connection()
        if not conn:
            print("Database connection failed")
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM orders ORDER BY created_at DESC")
        orders = cursor.fetchall()
        
        print(f"Fetched {len(orders)} orders")
        
        for order in orders:
            if 'created_at' in order and order['created_at']:
                order['created_at'] = order['created_at'].strftime('%Y-%m-%d %H:%M:%S')
            if 'order_date' in order and order['order_date']:
                order['order_date'] = order['order_date'].strftime('%Y-%m-%d')
            if 'order_time' in order and order['order_time']:
                order['order_time'] = str(order['order_time'])
        
        cursor.close()
        conn.close()
        
        return jsonify({'success': True, 'orders': orders})
    
    except Exception as e:
        print(f"Orders fetch error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

@app.route('/api/reservations', methods=['POST'])
def create_reservation():
    """Create a new table reservation"""
    try:
        data = request.json
        customer = data.get('customer')
        phone = data.get('phone')
        table = data.get('table')
        date = data.get('date')
        time = data.get('time')
        guests = data.get('guests')
        user_id = data.get('user_id', 2)
        
        print(f"Creating reservation: customer={customer}, table={table}, date={date}")
        
        if not all([customer, phone, table, date, time, guests]):
            return jsonify({'success': False, 'message': 'Missing reservation data'})
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor()
        cursor.execute(
            """INSERT INTO reservations 
               (user_id, customer_name, phone, table_number, reservation_date, reservation_time, guests) 
               VALUES (%s, %s, %s, %s, %s, %s, %s)""",
            (user_id, customer, phone, table, date, time, guests)
        )
        conn.commit()
        reservation_id = cursor.lastrowid
        
        print(f"Reservation created with ID: {reservation_id}")
        
        cursor.close()
        conn.close()
        
        return jsonify({'success': True, 'reservation_id': reservation_id})
    
    except Exception as e:
        print(f"Reservation creation error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

@app.route('/api/reservations', methods=['GET'])
def get_reservations():
    """Get all reservations"""
    try:
        print("Fetching reservations...")
        
        conn = get_db_connection()
        if not conn:
            print("Database connection failed")
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT * FROM reservations ORDER BY reservation_date DESC, reservation_time DESC"
        )
        reservations = cursor.fetchall()
        
        print(f"Fetched {len(reservations)} reservations")
        
        for res in reservations:
            if 'reservation_date' in res and res['reservation_date']:
                res['reservation_date'] = res['reservation_date'].strftime('%Y-%m-%d')
            if 'reservation_time' in res and res['reservation_time']:
                res['reservation_time'] = str(res['reservation_time'])
            if 'created_at' in res and res['created_at']:
                res['created_at'] = res['created_at'].strftime('%Y-%m-%d %H:%M:%S')
        
        cursor.close()
        conn.close()
        
        return jsonify({'success': True, 'reservations': reservations})
    
    except Exception as e:
        print(f"Reservations fetch error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Get dashboard statistics with advanced queries"""
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'success': False, 'message': 'Database connection failed'})
        
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT COUNT(*) as total FROM orders")
        total_orders = cursor.fetchone()['total']
        
        cursor.execute("SELECT SUM(total_price) as revenue FROM orders WHERE status != 'cancelled'")
        total_revenue = cursor.fetchone()['revenue'] or 0
        
        cursor.execute("SELECT COUNT(*) as total FROM reservations")
        total_reservations = cursor.fetchone()['total']
        
        cursor.execute("SELECT AVG(total_price) as avg_value FROM orders WHERE status != 'cancelled'")
        avg_order_value = cursor.fetchone()['avg_value'] or 0
        
        cursor.execute("SELECT COUNT(*) as today FROM orders WHERE order_date = CURDATE()")
        today_orders = cursor.fetchone()['today']
        
        cursor.execute("SELECT COUNT(*) as pending FROM orders WHERE status = 'pending'")
        pending_orders = cursor.fetchone()['pending']
        
        cursor.execute("""
            SELECT customer_name, COUNT(*) as order_count, SUM(total_price) as total_spent
            FROM orders
            WHERE status != 'cancelled'
            GROUP BY customer_name
            ORDER BY total_spent DESC
            LIMIT 1
        """)
        top_customer = cursor.fetchone()
        
        cursor.execute("""
            SELECT category, COUNT(*) as sales_count
            FROM menu_items
            GROUP BY category
            ORDER BY sales_count DESC
            LIMIT 1
        """)
        popular_category = cursor.fetchone()
        
        cursor.execute("""
            SELECT HOUR(order_time) as peak_hour, COUNT(*) as order_count
            FROM orders
            WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            GROUP BY HOUR(order_time)
            ORDER BY order_count DESC
            LIMIT 1
        """)
        peak_hour = cursor.fetchone()
        
        cursor.execute("""
            SELECT table_number, COUNT(*) as reservation_count
            FROM reservations
            WHERE status = 'confirmed'
            GROUP BY table_number
            ORDER BY reservation_count DESC
            LIMIT 1
        """)
        popular_table = cursor.fetchone()
        
        cursor.execute("""
            SELECT 
                DATE_FORMAT(order_date, '%Y-%m') as month,
                SUM(total_price) as monthly_revenue
            FROM orders
            WHERE status != 'cancelled'
            GROUP BY DATE_FORMAT(order_date, '%Y-%m')
            ORDER BY month DESC
            LIMIT 3
        """)
        monthly_trends = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'stats': {
                'total_orders': total_orders,
                'total_revenue': float(total_revenue),
                'total_reservations': total_reservations,
                'avg_order_value': float(avg_order_value),
                'today_orders': today_orders,
                'pending_orders': pending_orders,
                'top_customer': top_customer,
                'popular_category': popular_category,
                'peak_hour': peak_hour,
                'popular_table': popular_table,
                'monthly_trends': monthly_trends
            }
        })
    
    except Exception as e:
        print(f"Stats fetch error: {e}")
        print(traceback.format_exc())
        return jsonify({'success': False, 'message': 'Server error', 'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
