# University-IT-Ticketing-Portal
A full-stack, role-based web application built with Java (JSP) and Oracle 11g to streamline and manage IT support tickets across a university campus.



Overview
The University IT Ticketing Portal is a full-stack, role-based web application designed to streamline technical support requests across a university campus. Built with Java (JSP) and an Oracle 11g database, this system replaces chaotic email chains with a centralized, secure, and trackable ticketing dashboard. It bridges the gap between university faculty experiencing technical issues and the IT administration team responsible for resolving them.

🚀 Key Features
Role-Based Access Control (RBAC): Secure, distinct session management for two user types:

Faculty: Can register accounts, submit new IT tickets, and track the real-time status of their specific issues.

IT Administrators: Have exclusive access to a master dashboard to view, manage, update, and permanently delete campus-wide tickets.

Full CRUD Functionality: Complete database integration allowing users to Create, Read, Update, and Delete support tickets.

Dynamic Search & Filtering: IT staff can instantly filter the active ticket queue by specific campus departments, buildings, or labs using dynamic SQL queries.

Automated Database Triggers: Utilizes custom Oracle sequences and triggers to automatically generate unique, auto-incrementing ID numbers for every new ticket submission.

Frontend Security: Includes inline JavaScript validation to prevent accidental record deletion.

🛠️ Tech Stack
Frontend: HTML5, CSS3, JavaScript, JSP (JavaServer Pages)

Backend: Java (Servlets, Session Management), JDBC (Java Database Connectivity)

Database: Oracle 11g Express Edition (SQL)

Server: Apache Tomcat

⚙️ How to Run Locally
To run this project on your local machine, you will need Apache Tomcat and Oracle 11g installed.

Clone this repository to your local machine.

Open the database_setup.sql file and execute the script in your Oracle environment to create the required tables, triggers, and test users.

Deploy the CampusITDesk.war file to your Apache Tomcat webapps directory.

Start the Tomcat server and navigate to http://localhost:8080/CampusITDesk/login.jsp.

Default Test Accounts:

IT Admin: Username: admin | Password: admin123

Faculty: Username: prof_cse | Password: pass123 (Or register a new account on the login page)
