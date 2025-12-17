

DROP DATABASE IF EXISTS fastfood_db;
CREATE DATABASE fastfood_db;
USE fastfood_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE menu_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category ENUM('burgers', 'pizza', 'sides', 'drinks', 'combos') NOT NULL,
    image_url VARCHAR(500),
    is_combo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    items TEXT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'preparing', 'delivered', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    table_number INT NOT NULL,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    guests INT NOT NULL,
    status ENUM('confirmed', 'cancelled', 'completed') DEFAULT 'confirmed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


DELIMITER $$


CREATE TRIGGER validate_users_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.username REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username cannot contain numbers!';
    END IF;
    
    IF LENGTH(NEW.username) < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username must be at least 3 characters!';
    END IF;
    
    IF LENGTH(NEW.password) < 6 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 6 characters!';
    END IF;
    
    IF NEW.phone IS NOT NULL THEN
        IF LENGTH(NEW.phone) != 11 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Phone must be EXACTLY 11 digits!';
        END IF;
        
        IF NEW.phone REGEXP '[^0-9]' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Phone can only contain numbers (no +, -, spaces)!';
        END IF;
    END IF;
    
    IF NEW.email IS NOT NULL THEN
        IF NEW.email NOT LIKE '%@%.%' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Email must be valid (e.g., user@email.com)!';
        END IF;
    END IF;
END$$

CREATE TRIGGER validate_users_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.username REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username cannot contain numbers!';
    END IF;
    
    IF LENGTH(NEW.username) < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username must be at least 3 characters!';
    END IF;
    
    IF LENGTH(NEW.password) < 6 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 6 characters!';
    END IF;
    
    IF NEW.phone IS NOT NULL THEN
        IF LENGTH(NEW.phone) != 11 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Phone must be EXACTLY 11 digits!';
        END IF;
        
        IF NEW.phone REGEXP '[^0-9]' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Phone can only contain numbers (no +, -, spaces)!';
        END IF;
    END IF;
    
    IF NEW.email IS NOT NULL THEN
        IF NEW.email NOT LIKE '%@%.%' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Email must be valid (e.g., user@email.com)!';
        END IF;
    END IF;
END$$


CREATE TRIGGER validate_menu_insert
BEFORE INSERT ON menu_items
FOR EACH ROW
BEGIN

    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price must be greater than 0!';
    END IF;
    
    IF NEW.price > 10000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot exceed 10,000!';
    END IF;
    
    IF LENGTH(TRIM(NEW.name)) < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Item name must be at least 3 characters!';
    END IF;
END$$

CREATE TRIGGER validate_menu_update
BEFORE UPDATE ON menu_items
FOR EACH ROW
BEGIN

    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price must be greater than 0!';
    END IF;
    
    IF NEW.price > 10000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot exceed 10,000!';
    END IF;
    
    IF LENGTH(TRIM(NEW.name)) < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Item name must be at least 3 characters!';
    END IF;
END$$


CREATE TRIGGER validate_orders_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.total_price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total price must be greater than 0!';
    END IF;
    
    IF NEW.total_price > 50000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total price cannot exceed 50,000!';
    END IF;
    
    IF LENGTH(TRIM(NEW.customer_name)) < 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name must be at least 2 characters!';
    END IF;
    
    IF NEW.customer_name REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name cannot contain numbers!';
    END IF;
    
    IF NEW.order_date > DATE_ADD(CURDATE(), INTERVAL 1 DAY) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order date cannot be in the future!';
    END IF;
END$$

CREATE TRIGGER validate_orders_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN

    IF NEW.total_price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total price must be greater than 0!';
    END IF;
    

    IF NEW.total_price > 50000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total price cannot exceed 50,000!';
    END IF;
    
    IF LENGTH(TRIM(NEW.customer_name)) < 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name must be at least 2 characters!';
    END IF;
    
    IF NEW.customer_name REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name cannot contain numbers!';
    END IF;
END$$


CREATE TRIGGER validate_reservations_insert
BEFORE INSERT ON reservations
FOR EACH ROW
BEGIN
    
    IF LENGTH(NEW.phone) != 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone must be EXACTLY 11 digits!';
    END IF;
    
    
    IF NEW.phone REGEXP '[^0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone can only contain numbers (no +, -, spaces)!';
    END IF;
    
    
    IF NEW.table_number < 1 OR NEW.table_number > 20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table number must be between 1 and 20!';
    END IF;
    
    IF NEW.guests < 1 OR NEW.guests > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Guests must be between 1 and 10!';
    END IF;
    
    IF LENGTH(TRIM(NEW.customer_name)) < 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name must be at least 2 characters!';
    END IF;
    
    IF NEW.customer_name REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name cannot contain numbers!';
    END IF;
    
    IF NEW.reservation_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation date cannot be in the past!';
    END IF;
    
    IF NEW.reservation_time < '10:00:00' OR NEW.reservation_time > '23:00:00' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation time must be between 10:00 AM and 11:00 PM!';
    END IF;
END$$

CREATE TRIGGER validate_reservations_update
BEFORE UPDATE ON reservations
FOR EACH ROW
BEGIN
    
    IF LENGTH(NEW.phone) != 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone must be EXACTLY 11 digits!';
    END IF;
    
    IF NEW.phone REGEXP '[^0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone can only contain numbers (no +, -, spaces)!';
    END IF;
    
    IF NEW.table_number < 1 OR NEW.table_number > 20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table number must be between 1 and 20!';
    END IF;
    
    IF NEW.guests < 1 OR NEW.guests > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Guests must be between 1 and 10!';
    END IF;
    
    IF LENGTH(TRIM(NEW.customer_name)) < 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name must be at least 2 characters!';
    END IF;
    
    IF NEW.customer_name REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer name cannot contain numbers!';
    END IF;
    
    IF NEW.reservation_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation date cannot be in the past!';
    END IF;
    
    IF NEW.reservation_time < '10:00:00' OR NEW.reservation_time > '23:00:00' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation time must be between 10:00 AM and 11:00 PM!';
    END IF;
END$$

DELIMITER ;


INSERT INTO users (username, password, role, email, phone) VALUES 
('admin', '0192023a7bbd73250516f069df18b500', 'admin', 'admin@quickbite.com', '03001234567');

INSERT INTO users (username, password, role, email, phone) VALUES 
('customer', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'customer@email.com', '03001111111'),
('ali_khan', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'ali.khan@email.com', '03002222222'),
('sara_ahmed', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'sara.ahmed@email.com', '03003333333'),
('usman_ali', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'usman.ali@email.com', '03004444444'),
('fatima_shah', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'fatima.shah@email.com', '03005555555'),
('ahmed_raza', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'ahmed.raza@email.com', '03006666666'),
('ayesha_malik', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'ayesha.malik@email.com', '03007777777'),
('bilal_hassan', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'bilal.hassan@email.com', '03008888888'),
('zainab_noor', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'zainab.noor@email.com', '03009999999'),
('hamza_saeed', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'hamza.saeed@email.com', '03001010101'),
('mariam_tariq', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'mariam.tariq@email.com', '03001111112'),
('junaid_iqbal', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'junaid.iqbal@email.com', '03001212121'),
('hira_naveed', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'hira.naveed@email.com', '03001313131'),
('talha_amir', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'talha.amir@email.com', '03001414141'),
('nida_farooq', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'nida.farooq@email.com', '03001515151'),
('kashif_butt', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'kashif.butt@email.com', '03001616161'),
('sana_jamil', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'sana.jamil@email.com', '03001717171'),
('faisal_sheikh', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'faisal.sheikh@email.com', '03001818181'),
('khadija_aziz', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'khadija.aziz@email.com', '03001919191'),
('imran_rashid', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'imran.rashid@email.com', '03002020202'),
('rabia_munir', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'rabia.munir@email.com', '03002121212'),
('nabeel_warsi', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'nabeel.warsi@email.com', '03002222223'),
('amna_yousaf', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'amna.yousaf@email.com', '03002323232'),
('shahzad_akram', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'shahzad.akram@email.com', '03002424242'),
('maryam_iftikhar', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'maryam.iftikhar@email.com', '03002525252'),
('adnan_saleem', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'adnan.saleem@email.com', '03002626262'),
('bushra_khalid', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'bushra.khalid@email.com', '03002727272'),
('waleed_javed', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'waleed.javed@email.com', '03002828282'),
('sidra_bashir', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'sidra.bashir@email.com', '03002929292'),
('arslan_waheed', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'arslan.waheed@email.com', '03003030303'),
('anum_haider', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'anum.haider@email.com', '03003131313'),
('rizwan_mahmood', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'rizwan.mahmood@email.com', '03003232323'),
('laiba_nasir', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'laiba.nasir@email.com', '03003333334'),
('hammad_qadir', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'hammad.qadir@email.com', '03003434343'),
('iqra_sajjad', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'iqra.sajjad@email.com', '03003535353'),
('kamran_latif', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'kamran.latif@email.com', '03003636363'),
('mahnoor_zahid', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'mahnoor.zahid@email.com', '03003737373'),
('zeeshan_nawaz', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'zeeshan.nawaz@email.com', '03003838383'),
('aleena_riaz', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'aleena.riaz@email.com', '03003939393'),
('muneeb_anwar', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'muneeb.anwar@email.com', '03004040404'),
('hoorain_batool', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'hoorain.batool@email.com', '03004141414'),
('danish_mirza', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'danish.mirza@email.com', '03004242424'),
('nimra_faisal', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'nimra.faisal@email.com', '03004343434'),
('taimoor_hussain', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'taimoor.hussain@email.com', '03004444445'),
('mehwish_liaquat', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'mehwish.liaquat@email.com', '03004545454'),
('usama_rehman', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'usama.rehman@email.com', '03004646464'),
('sadia_pervez', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'sadia.pervez@email.com', '03004747474'),
('owais_ashraf', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'owais.ashraf@email.com', '03004848484'),
('aliza_chaudhry', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'aliza.chaudhry@email.com', '03004949494'),
('shoaib_zaheer', '482c811da5d5b4bc6d497ffa98491e38', 'customer', 'shoaib.zaheer@email.com', '03005050505');


INSERT INTO menu_items (name, description, price, category, image_url, is_combo) VALUES 

('Classic Beef Burger', 'Juicy beef patty, lettuce, tomato, pickles, cheese', 8.99, 'burgers', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', FALSE),
('Chicken Burger', 'Crispy chicken breast, mayo, lettuce', 7.99, 'burgers', 'https://images.unsplash.com/photo-1606755962773-d324e0a13086', FALSE),
('Double Cheese Burger', 'Two beef patties, double cheese, BBQ sauce', 11.99, 'burgers', 'https://images.unsplash.com/photo-1550547660-d9450f859349', FALSE),
('Bacon Burger', 'Beef patty, crispy bacon, cheese, special sauce', 10.99, 'burgers', 'https://images.unsplash.com/photo-1553979459-d2229ba7433b', FALSE),
('Veggie Burger', 'Plant-based patty, lettuce, tomato, vegan sauce', 9.99, 'burgers', 'https://images.unsplash.com/photo-1520072959219-c595dc870360', FALSE),
('Spicy Chicken Burger', 'Extra spicy chicken, jalapeños, hot sauce', 8.99, 'burgers', 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9', FALSE),
('Mushroom Swiss Burger', 'Beef patty, mushrooms, swiss cheese', 10.49, 'burgers', 'https://images.unsplash.com/photo-1586816001966-79b736744398', FALSE),
('BBQ Bacon Burger', 'BBQ sauce, bacon, onion rings, cheddar', 12.49, 'burgers', 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5', FALSE),
('Turkey Burger', 'Lean turkey patty, cranberry sauce, greens', 9.49, 'burgers', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', FALSE),
('Fish Burger', 'Crispy fish fillet, tartar sauce, lettuce', 8.49, 'burgers', 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143', FALSE),


('Pepperoni Pizza', 'Classic pepperoni with mozzarella', 12.99, 'pizza', 'https://images.unsplash.com/photo-1628840042765-356cda07504e', FALSE),
('Margherita Pizza', 'Fresh tomatoes, mozzarella, basil', 10.99, 'pizza', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002', FALSE),
('BBQ Chicken Pizza', 'Grilled chicken, BBQ sauce, onions', 13.99, 'pizza', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', FALSE),
('Hawaiian Pizza', 'Ham, pineapple, mozzarella cheese', 11.99, 'pizza', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828', FALSE),
('Veggie Supreme', 'Mushrooms, peppers, olives, onions', 12.49, 'pizza', 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f', FALSE),
('Meat Lovers', 'Pepperoni, sausage, bacon, ham', 14.99, 'pizza', 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee', FALSE),
('Four Cheese Pizza', 'Mozzarella, parmesan, cheddar, gouda', 13.49, 'pizza', 'https://images.unsplash.com/photo-1513104890138-7c749659a591', FALSE),
('Buffalo Chicken Pizza', 'Spicy buffalo chicken, ranch drizzle', 14.49, 'pizza', 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f', FALSE),
('Mushroom Truffle Pizza', 'Mushrooms, truffle oil, arugula', 15.99, 'pizza', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', FALSE),
('Mediterranean Pizza', 'Feta, olives, sun-dried tomatoes, spinach', 13.99, 'pizza', 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f', FALSE),
('White Pizza', 'Ricotta, mozzarella, garlic, herbs', 12.99, 'pizza', 'https://images.unsplash.com/photo-1513104890138-7c749659a591', FALSE),
('Pesto Chicken Pizza', 'Pesto sauce, chicken, sun-dried tomatoes', 14.99, 'pizza', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', FALSE),


('French Fries', 'Crispy golden fries with sea salt', 3.99, 'sides', 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877', FALSE),
('Chicken Nuggets', 'Tender chicken nuggets (8pc)', 5.99, 'sides', 'https://images.unsplash.com/photo-1562967914-608f82629710', FALSE),
('Onion Rings', 'Crispy battered onion rings', 4.49, 'sides', 'https://images.unsplash.com/photo-1639024471283-03518883512d', FALSE),
('Mozzarella Sticks', 'Fried mozzarella with marinara sauce (6pc)', 5.49, 'sides', 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7', FALSE),
('Loaded Fries', 'Fries with cheese, bacon, sour cream', 6.99, 'sides', 'https://images.unsplash.com/photo-1639744091413-b0c2e20b5b07', FALSE),
('Buffalo Wings', 'Spicy buffalo chicken wings (10pc)', 8.99, 'sides', 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7', FALSE),
('Caesar Salad', 'Fresh romaine, parmesan, croutons', 5.99, 'sides', 'https://images.unsplash.com/photo-1546793665-c74683f339c1', FALSE),
('Garden Salad', 'Mixed greens, tomatoes, cucumbers', 4.99, 'sides', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd', FALSE),
('Garlic Bread', 'Toasted bread with garlic butter (4pc)', 3.49, 'sides', 'https://images.unsplash.com/photo-1573140401552-388e1c49c41d', FALSE),
('Coleslaw', 'Creamy coleslaw with cabbage and carrots', 2.99, 'sides', 'https://images.unsplash.com/photo-1604909052399-83e21df3d16c', FALSE),
('Jalapeno Poppers', 'Cream cheese filled jalapeños (6pc)', 5.99, 'sides', 'https://images.unsplash.com/photo-1601924638867-3a6de6b7a500', FALSE),
('Potato Wedges', 'Seasoned potato wedges', 4.49, 'sides', 'https://images.unsplash.com/photo-1639024471283-03518883512d', FALSE),
('Sweet Potato Fries', 'Crispy sweet potato fries', 4.99, 'sides', 'https://images.unsplash.com/photo-1630384082906-7b9a134e59f3', FALSE),
('Mac and Cheese', 'Creamy mac and cheese', 5.49, 'sides', 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6', FALSE),


('Coca Cola', 'Classic refreshing cola 500ml', 2.49, 'drinks', 'https://images.unsplash.com/photo-1554866585-cd94860890b7', FALSE),
('Sprite', 'Lemon-lime soda 500ml', 2.49, 'drinks', 'https://images.unsplash.com/photo-1625772452859-1c03d5bf1137', FALSE),
('Fanta Orange', 'Orange flavored soda 500ml', 2.49, 'drinks', 'https://images.unsplash.com/photo-1624517452488-04869289c4ca', FALSE),
('Orange Juice', 'Fresh squeezed orange juice', 3.49, 'drinks', 'https://images.unsplash.com/photo-1600271886742-f049cd451bba', FALSE),
('Apple Juice', 'Pure apple juice', 3.49, 'drinks', 'https://images.unsplash.com/photo-1560781290-7dc94c0f8f4f', FALSE),
('Chocolate Milkshake', 'Creamy chocolate shake', 4.99, 'drinks', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699', FALSE),
('Strawberry Milkshake', 'Fresh strawberry shake', 4.99, 'drinks', 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4', FALSE),
('Iced Coffee', 'Cold brew coffee with ice', 3.99, 'drinks', 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7', FALSE),
('Lemonade', 'Fresh lemonade', 2.99, 'drinks', 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9d', FALSE),

('Classic Burger Combo', 'Burger + Fries + Drink', 12.99, 'combos', 'https://images.unsplash.com/photo-1561758033-d89a9ad46330', TRUE),
('Chicken Meal Deal', 'Chicken Burger + Nuggets + Drink', 15.99, 'combos', 'https://images.unsplash.com/photo-1619221882420-09d6f1c08d6f', TRUE),
('Pizza Party Box', '2 Large Pizzas + Wings + 4 Drinks', 39.99, 'combos', 'https://images.unsplash.com/photo-1513104890138-7c749659a591', TRUE),
('Family Feast', '3 Burgers + 2 Large Fries + 4 Drinks', 34.99, 'combos', 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5', TRUE),
('Kids Happy Meal', 'Mini Burger + Small Fries + Juice', 7.99, 'combos', 'https://images.unsplash.com/photo-1625938145312-446e0939953e', TRUE);


INSERT INTO orders (user_id, customer_name, items, total_price, status, order_date, order_time) VALUES 
(2, 'customer', 'Classic Beef Burger x1, French Fries x1, Coca Cola x1', 15.47, 'completed', '2024-12-01', '12:15:00'),
(3, 'ali khan', 'Pepperoni Pizza x1, Buffalo Wings x1', 21.98, 'completed', '2024-12-01', '13:20:00'),
(4, 'sara ahmed', 'Chicken Burger x2, French Fries x2', 23.96, 'delivered', '2024-12-02', '14:30:00'),
(5, 'usman ali', 'Classic Burger Combo x1', 12.99, 'completed', '2024-12-02', '18:45:00'),
(6, 'fatima shah', 'Margherita Pizza x1, Caesar Salad x1', 16.98, 'completed', '2024-12-03', '19:10:00'),
(7, 'ahmed raza', 'Double Cheese Burger x1, Loaded Fries x1, Sprite x1', 21.47, 'delivered', '2024-12-03', '20:00:00'),
(8, 'ayesha malik', 'BBQ Chicken Pizza x1, Onion Rings x1', 18.48, 'completed', '2024-12-04', '12:30:00'),
(9, 'bilal hassan', 'Chicken Meal Deal x1', 15.99, 'completed', '2024-12-04', '13:45:00'),
(10, 'zainab noor', 'Bacon Burger x1, French Fries x1, Lemonade x1', 17.47, 'preparing', '2024-12-05', '15:00:00'),
(11, 'hamza saeed', 'Hawaiian Pizza x1, Mozzarella Sticks x1', 17.48, 'completed', '2024-12-05', '16:20:00'),
(12, 'mariam tariq', 'Veggie Burger x1, Caesar Salad x1, Orange Juice x1', 19.47, 'delivered', '2024-12-06', '17:30:00'),
(13, 'junaid iqbal', 'Family Feast x1', 34.99, 'completed', '2024-12-06', '18:00:00'),
(14, 'hira naveed', 'Meat Lovers Pizza x1, Buffalo Wings x1', 23.98, 'completed', '2024-12-07', '19:15:00'),
(15, 'talha amir', 'Chicken Burger x1, Chicken Nuggets x1, Fanta Orange x1', 16.47, 'delivered', '2024-12-07', '12:00:00'),
(16, 'nida farooq', 'Classic Burger Combo x2', 25.98, 'completed', '2024-12-08', '13:30:00'),
(17, 'kashif butt', 'Veggie Supreme Pizza x1, Onion Rings x1', 16.98, 'completed', '2024-12-08', '14:45:00'),
(18, 'sana jamil', 'Double Cheese Burger x1, Loaded Fries x1', 18.98, 'preparing', '2024-12-09', '16:00:00'),
(19, 'faisal sheikh', 'Pizza Party Box x1', 39.99, 'completed', '2024-12-09', '19:30:00'),
(20, 'khadija aziz', 'Bacon Burger x1, French Fries x1, Chocolate Milkshake x1', 20.47, 'delivered', '2024-12-10', '12:20:00'),
(21, 'imran rashid', 'Pepperoni Pizza x1, Caesar Salad x1, Sprite x1', 21.47, 'completed', '2024-12-10', '13:40:00'),
(22, 'rabia munir', 'Chicken Meal Deal x1', 15.99, 'completed', '2024-12-11', '15:10:00'),
(23, 'nabeel warsi', 'Classic Beef Burger x1, Mozzarella Sticks x1, Coca Cola x1', 17.97, 'delivered', '2024-12-11', '16:30:00'),
(24, 'amna yousaf', 'BBQ Chicken Pizza x1, Buffalo Wings x1', 22.98, 'completed', '2024-12-12', '17:45:00'),
(25, 'shahzad akram', 'Veggie Burger x2, French Fries x2, Apple Juice x2', 33.94, 'completed', '2024-12-12', '18:50:00'),
(26, 'maryam iftikhar', 'Hawaiian Pizza x1, Onion Rings x1, Lemonade x1', 19.47, 'preparing', '2024-12-13', '12:15:00'),
(27, 'adnan saleem', 'Family Feast x1', 34.99, 'completed', '2024-12-13', '19:00:00'),
(28, 'bushra khalid', 'Double Cheese Burger x1, Chicken Nuggets x1, Strawberry Milkshake x1', 22.97, 'delivered', '2024-12-14', '13:20:00'),
(29, 'waleed javed', 'Margherita Pizza x1, Caesar Salad x1', 16.98, 'completed', '2024-12-14', '14:35:00'),
(30, 'sidra bashir', 'Classic Burger Combo x1', 12.99, 'completed', '2024-12-15', '15:50:00'),
(31, 'arslan waheed', 'Meat Lovers Pizza x1, Loaded Fries x1', 21.98, 'delivered', '2024-12-15', '17:00:00'),
(32, 'anum haider', 'Chicken Burger x1, French Fries x1, Iced Coffee x1', 16.47, 'completed', '2024-12-16', '12:30:00'),
(33, 'rizwan mahmood', 'Bacon Burger x1, Mozzarella Sticks x1', 16.48, 'completed', '2024-12-16', '13:45:00'),
(34, 'laiba nasir', 'Pepperoni Pizza x1, Buffalo Wings x1, Sprite x2', 26.96, 'preparing', '2024-12-17', '15:00:00'),
(35, 'hammad qadir', 'Chicken Meal Deal x1', 15.99, 'delivered', '2024-12-17', '16:15:00'),
(36, 'iqra sajjad', 'Veggie Supreme Pizza x1, Onion Rings x1, Orange Juice x1', 20.97, 'completed', '2024-12-18', '17:30:00'),
(37, 'kamran latif', 'Double Cheese Burger x2, Loaded Fries x2', 37.96, 'completed', '2024-12-18', '18:45:00'),
(38, 'mahnoor zahid', 'Hawaiian Pizza x1, Caesar Salad x1, Lemonade x1', 20.97, 'delivered', '2024-12-19', '12:00:00'),
(39, 'zeeshan nawaz', 'Pizza Party Box x1', 39.99, 'completed', '2024-12-19', '19:20:00'),
(40, 'aleena riaz', 'Classic Beef Burger x1, French Fries x1, Chocolate Milkshake x1', 20.47, 'completed', '2024-12-20', '13:30:00'),
(41, 'muneeb anwar', 'BBQ Chicken Pizza x1, Chicken Nuggets x1', 19.98, 'preparing', '2024-12-20', '14:45:00'),
(42, 'hoorain batool', 'Veggie Burger x1, Mozzarella Sticks x1, Apple Juice x1', 19.47, 'delivered', '2024-12-21', '16:00:00'),
(43, 'danish mirza', 'Meat Lovers Pizza x1, Buffalo Wings x1', 23.98, 'completed', '2024-12-21', '17:15:00'),
(44, 'nimra faisal', 'Chicken Burger x1, Onion Rings x1, Fanta Orange x1', 14.97, 'completed', '2024-12-22', '12:45:00'),
(45, 'taimoor hussain', 'Family Feast x1', 34.99, 'delivered', '2024-12-22', '19:30:00'),
(46, 'mehwish liaquat', 'Classic Burger Combo x1', 12.99, 'completed', '2024-12-23', '13:00:00'),
(47, 'usama rehman', 'Pepperoni Pizza x1, Loaded Fries x1, Strawberry Milkshake x1', 22.97, 'completed', '2024-12-23', '14:20:00'),
(48, 'sadia pervez', 'Double Cheese Burger x1, Caesar Salad x1, Coca Cola x1', 20.47, 'preparing', '2024-12-24', '15:40:00'),
(49, 'owais ashraf', 'Hawaiian Pizza x1, French Fries x1, Iced Coffee x1', 18.47, 'delivered', '2024-12-24', '17:00:00'),
(50, 'aliza chaudhry', 'Bacon Burger x1, Chicken Nuggets x1', 16.98, 'completed', '2024-12-25', '18:20:00'),
(51, 'shoaib zaheer', 'Chicken Meal Deal x1', 15.99, 'completed', '2024-12-25', '19:35:00');


INSERT INTO reservations 
(user_id, customer_name, phone, table_number, reservation_date, reservation_time, guests, status) 
VALUES
(2, 'customer', '03001111111', 5, '2026-12-15', '19:00:00', 4, 'confirmed'),
(3, 'ali khan', '03002222222', 3, '2026-12-15', '20:00:00', 2, 'confirmed'),
(4, 'sara ahmed', '03003333333', 8, '2026-12-16', '18:30:00', 3, 'confirmed'),
(5, 'usman ali', '03004444444', 10, '2026-12-16', '19:45:00', 5, 'confirmed'),
(6, 'fatima shah', '03005555555', 2, '2026-12-17', '20:15:00', 6, 'confirmed'),
(7, 'ahmed raza', '03006666666', 12, '2026-12-17', '18:20:00', 4, 'confirmed'),
(8, 'ayesha malik', '03007777777', 7, '2026-12-18', '19:30:00', 2, 'confirmed'),
(9, 'bilal hassan', '03008888888', 4, '2026-12-18', '20:00:00', 3, 'confirmed'),
(10, 'zainab noor', '03009999999', 9, '2026-12-19', '18:45:00', 5, 'confirmed'),
(11, 'hamza saeed', '03001010101', 6, '2026-12-19', '19:55:00', 2, 'confirmed'),
(12, 'mariam tariq', '03001111112', 11, '2026-12-20', '18:35:00', 4, 'confirmed'),
(13, 'junaid iqbal', '03001212121', 1, '2026-12-20', '20:10:00', 3, 'confirmed'),
(14, 'hira naveed', '03001313131', 15, '2026-12-21', '19:25:00', 8, 'confirmed'),
(15, 'talha amir', '03001414141', 13, '2026-12-21', '18:50:00', 2, 'confirmed'),
(16, 'nida farooq', '03001515151', 5, '2026-12-22', '19:40:00', 6, 'confirmed'),
(17, 'kashif butt', '03001616161', 8, '2026-12-22', '20:20:00', 3, 'confirmed'),
(18, 'sana jamil', '03001717171', 14, '2026-12-23', '18:15:00', 5, 'confirmed'),
(19, 'faisal sheikh', '03001818181', 2, '2026-12-23', '19:50:00', 4, 'confirmed'),
(20, 'khadija aziz', '03001919191', 7, '2026-12-24', '20:30:00', 2, 'confirmed'),
(21, 'imran rashid', '03002020202', 10, '2026-12-24', '18:25:00', 3, 'confirmed'),
(22, 'rabia munir', '03002121212', 3, '2026-12-25', '19:10:00', 4, 'confirmed'),
(23, 'nabeel warsi', '03002222223', 9, '2026-12-25', '20:00:00', 6, 'confirmed'),
(24, 'amna yousaf', '03002323232', 12, '2026-12-26', '18:55:00', 3, 'confirmed'),
(25, 'shahzad akram', '03002424242', 4, '2026-12-26', '19:45:00', 2, 'confirmed'),
(26, 'maryam iftikhar', '03002525252', 6, '2026-12-27', '20:35:00', 5, 'confirmed'),
(27, 'adnan saleem', '03002626262', 1, '2026-12-27', '18:40:00', 3, 'confirmed'),
(28, 'bushra khalid', '03002727272', 11, '2026-12-28', '19:30:00', 4, 'confirmed'),
(29, 'waleed javed', '03002828282', 14, '2026-12-28', '20:15:00', 7, 'confirmed'),
(30, 'sidra bashir', '03002929292', 8, '2026-12-29', '18:30:00', 2, 'confirmed'),
(31, 'arslan waheed', '03003030303', 5, '2026-12-29', '19:55:00', 3, 'confirmed'),
(32, 'anum haider', '03003131313', 13, '2026-12-30', '20:20:00', 6, 'confirmed'),
(33, 'rizwan mahmood', '03003232323', 9, '2026-12-30', '18:45:00', 3, 'confirmed'),
(34, 'laiba nasir', '03003333334', 7, '2026-12-31', '19:50:00', 2, 'confirmed'),
(35, 'hammad qadir', '03003434343', 10, '2026-12-31', '20:30:00', 4, 'confirmed'),
(36, 'iqra sajjad', '03003535353', 12, '2027-01-01', '18:15:00', 5, 'confirmed'),
(37, 'kamran latif', '03003636363', 3, '2027-01-01', '19:30:00', 2, 'confirmed'),
(38, 'mahnoor zahid', '03003737373', 6, '2027-01-02', '20:40:00', 4, 'confirmed'),
(39, 'zeeshan nawaz', '03003838383', 1, '2027-01-02', '18:50:00', 3, 'confirmed'),
(40, 'aleena riaz', '03003939393', 4, '2027-01-03', '19:40:00', 5, 'confirmed'),
(41, 'muneeb anwar', '03004040404', 15, '2027-01-03', '20:10:00', 8, 'confirmed'),
(42, 'hoorain batool', '03004141414', 11, '2027-01-04', '18:35:00', 3, 'confirmed'),
(43, 'danish mirza', '03004242424', 2, '2027-01-04', '19:55:00', 2, 'confirmed'),
(44, 'nimra faisal', '03004343434', 9, '2027-01-05', '20:25:00', 4, 'confirmed'),
(45, 'taimoor hussain', '03004444445', 14, '2027-01-05', '18:45:00', 6, 'confirmed'),
(46, 'mehwish liaquat', '03004545454', 5, '2027-01-06', '19:35:00', 3, 'confirmed'),
(47, 'usama rehman', '03004646464', 13, '2027-01-06', '20:15:00', 2, 'confirmed'),
(48, 'sadia pervez', '03004747474', 7, '2027-01-07', '18:55:00', 4, 'confirmed'),
(49, 'owais ashraf', '03004848484', 10, '2027-01-07', '19:30:00', 3, 'confirmed'),
(50, 'aliza chaudhry', '03004949494', 6, '2027-01-08', '20:10:00', 5, 'confirmed'),
(51, 'shoaib zaheer', '03005050505', 8, '2027-01-08', '18:30:00', 2, 'confirmed');


CREATE VIEW daily_revenue AS
SELECT 
    order_date,
    COUNT(*) as total_orders,
    SUM(total_price) as daily_revenue,
    AVG(total_price) as avg_order_value
FROM orders
WHERE status != 'cancelled'
GROUP BY order_date
ORDER BY order_date DESC;

CREATE VIEW popular_items AS
SELECT 
    category,
    COUNT(*) as order_count,
    SUM(price) as total_revenue
FROM menu_items
GROUP BY category
ORDER BY order_count DESC;

CREATE VIEW customer_activity AS
SELECT 
    u.username,
    u.email,
    COUNT(DISTINCT o.id) as total_orders,
    COUNT(DISTINCT r.id) as total_reservations,
    COALESCE(SUM(o.total_price), 0) as total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN reservations r ON u.id = r.user_id
WHERE u.role = 'customer'
GROUP BY u.id, u.username, u.email
ORDER BY total_spent DESC;

CREATE VIEW peak_hours AS
SELECT 
    HOUR(order_time) as hour,
    COUNT(*) as order_count,
    SUM(total_price) as hourly_revenue
FROM orders
GROUP BY HOUR(order_time)
ORDER BY order_count DESC;

CREATE VIEW table_utilization AS
SELECT 
    table_number,
    COUNT(*) as reservation_count,
    AVG(guests) as avg_guests
FROM reservations
WHERE status = 'confirmed'
GROUP BY table_number
ORDER BY reservation_count DESC;


SELECT '========================================' AS '';
SELECT '✅ DATABASE CREATED SUCCESSFULLY!' AS '';
SELECT '========================================' AS '';

SELECT '' AS '';
SELECT '📊 DATABASE STATISTICS:' AS '';
SELECT '─────────────────────────' AS '';
SELECT CONCAT('Total Users: ', COUNT(*)) as Stat FROM users;
SELECT CONCAT('Total Menu Items: ', COUNT(*)) as Stat FROM menu_items;
SELECT CONCAT('Total Orders: ', COUNT(*)) as Stat FROM orders;
SELECT CONCAT('Total Reservations: ', COUNT(*)) as Stat FROM reservations;



SELECT COUNT(*) as Total_Triggers
FROM information_schema.TRIGGERS 
WHERE TRIGGER_SCHEMA = 'fastfood_db';

