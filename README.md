# 🎓 Unishare: Campus Marketplace

![.NET Framework](https://img.shields.io/badge/.NET_Framework-4.8-5C2D91?style=for-the-badge&logo=.net)
![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap_5-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)

Unishare is a secure, centralized e-commerce platform originally pioneered by University of Fort Hare students, designed to serve the entire South African student population. It provides a peer-to-peer marketplace for students to buy and sell essential academic resources like textbooks, electronics, and dorm room essentials.

## ✨ Key Features
* **Guest Browsing & Secure Purchasing:** Anyone can browse the catalogue, but a secure login is required to purchase or list items.
* **Dynamic Multi-Variant Listings:** Sellers can list a single item with multiple color and stock variations (powered by native HTML5 Hex Color pickers and JavaScript).
* **Simulated Payment Gateway:** A built-in checkout simulation that charges a dynamic 10% platform fee before an item is published to the database.
* **Smart Cart System:** Prevents duplicate variant additions and manages user sessions.
* **Comprehensive Admin Dashboard:** * Real-time financial analytics and dynamic charts (powered by Chart.js).
  * Platform revenue tracking (calculating the 10% cut).
  * Discount/Promo Code generation and toggling.
  * System Audit Logging for marketplace moderation.
* **Data Integrity:** Utilizes SQL Transactions and "Soft Deletes" to maintain order history while safely removing active listings.

## 🛠️ Tech Stack
* **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5, Chart.js
* **Backend:** C#, ASP.NET Web Forms
* **Database:** Microsoft SQL Server (ADO.NET with parameterized queries for SQL Injection prevention)

## 🚀 How to Run Locally
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/JusttMJ/Unishare-Campus-Marketplace.git](https://github.com/JusttMJ/Unishare-Campus-Marketplace.git)

   👥 Authors
MJ Mukhumeni - Lead Developer - JusttMJ

Group 11 (University of Fort Hare)
