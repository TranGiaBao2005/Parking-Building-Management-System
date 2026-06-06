# USER_STORIES.md - Parking Building Management System

## User Stories Format
**As a [Role], I want to [Action], So that [Value]**

---

## PARKING FACILITY MANAGER USER STORIES

### US-001: Manage Basic Facility Information
**As a** Parking Facility Manager,  
**I want to** create and configure parking facility information (name, location, operating hours, contact, capacity),  
**So that** the system accurately represents my facility and provides drivers with correct operational information.

### US-002: Define Vehicle Types
**As a** Parking Facility Manager,  
**I want to** define vehicle types served by the facility (motorcycles, cars, vans, trucks) with size classifications,  
**So that** I can allocate appropriate parking spaces and apply correct pricing for each vehicle category.

### US-003: Allocate Floors/Sections by Vehicle Type
**As a** Parking Facility Manager,  
**I want to** assign specific floors or sections for different vehicle types,  
**So that** I can optimize space usage and reduce driver confusion when searching for parking.

### US-004: Configure Parking Slots
**As a** Parking Facility Manager,  
**I want to** create parking slots with identifiers (e.g., A-01, B-05) and assign them to floors/sections,  
**So that** I can track individual slot usage and manage capacity precisely.

### US-005: Manage Slot Status
**As a** Parking Facility Manager,  
**I want to** view and update individual slot status (vacant, in-use, pre-booked, maintenance, blocked),  
**So that** I can control which slots are available for parking and which require maintenance.

### US-006: Configure Pricing Policies
**As a** Parking Facility Manager,  
**I want to** create pricing rules (hourly rates, daily rates, monthly rates) differentiated by vehicle type and time periods,  
**So that** I can establish flexible revenue models (peak/off-peak pricing, weekend/weekday variations).

### US-007: View Real-time Occupancy
**As a** Parking Facility Manager,  
**I want to** see real-time occupancy metrics (total occupied, vacant, occupancy rate, peak times),  
**So that** I can monitor facility utilization and make operational decisions.

### US-008: Generate Revenue Reports
**As a** Parking Facility Manager,  
**I want to** generate reports showing total revenue, transactions, revenue by vehicle type, and revenue by time period,  
**So that** I can track financial performance and reconcile with payment records.

### US-009: Generate Occupancy Reports
**As a** Parking Facility Manager,  
**I want to** view occupancy trends by hour, day, vehicle type, and zone,  
**So that** I can identify peak hours and optimize staffing and maintenance schedules.

### US-010: Track Exceptions
**As a** Parking Facility Manager,  
**I want to** view logged exceptions (lost tickets, wrong plate, overdue, wrong zone, unpaid vehicles),  
**So that** I can address operational issues and identify patterns.

---

## PARKING STAFF USER STORIES

### US-011: Process Vehicle Entry
**As a** Parking Staff member,  
**I want to** check vehicle documentation, capture plate number, select vehicle type, and record entry time,  
**So that** a parking session is created with accurate information.

### US-012: Direct Vehicle to Correct Zone
**As a** Parking Staff member,  
**I want to** receive recommended zone/floor based on vehicle type and availability,  
**So that** I can direct drivers efficiently to available parking slots.

### US-013: Generate Entry Ticket
**As a** Parking Staff member,  
**I want to** generate and provide a ticket/code to the driver at entry,  
**So that** the driver has proof of entry and duration reference.

### US-014: Process Vehicle Exit
**As a** Parking Staff member,  
**I want to** retrieve the parking session using ticket/code, verify exit time, confirm fees, and collect payment,  
**So that** the parking session is properly closed and revenue is captured.

### US-015: Handle Lost Ticket Exception
**As a** Parking Staff member,  
**I want to** search for lost parking sessions by plate number or vehicle description and manually create exit records,  
**So that** drivers who lost tickets can exit without system blockage.

### US-016: Handle Wrong Plate Exception
**As a** Parking Staff member,  
**I want to** correct plate information in active parking sessions,  
**So that** fee calculations and reports are accurate.

### US-017: Handle Overdue Exception
**As a** Parking Staff member,  
**I want to** identify parked vehicles exceeding maximum duration limits and apply additional fees,  
**So that** long-term parking does not monopolize premium slots.

### US-018: Update Slot Maintenance Status
**As a** Parking Staff member,  
**I want to** mark slots as maintenance or blocked and release them back to active status,  
**So that** the system accurately reflects available capacity.

### US-019: Collect Exception Fees
**As a** Parking Staff member,  
**I want to** calculate and collect additional fees (wrong zone, overdue, wrong vehicle info),  
**So that** revenue is recovered for all billable parking usage.

### US-020: View Session Details
**As a** Parking Staff member,  
**I want to** quickly retrieve session details (entry time, vehicle type, calculated duration, base fee),  
**So that** I can verify information before releasing a vehicle.

---

## PARKING USER/DRIVER USER STORIES

### US-021: View Facility Information
**As a** Parking User/Driver,  
**I want to** see facility details (location, operating hours, vehicle types served, pricing structure, vacant slots count),  
**So that** I can decide whether to park and understand costs upfront.

### US-022: Receive Entry Ticket
**As a** Parking User/Driver,  
**I want to** receive a ticket or unique code upon entry,  
**So that** I have proof of parking session and reference for exit.

### US-023: Locate Parking Space
**As a** Parking User/Driver,  
**I want to** receive directions to my assigned zone/floor with available slot information,  
**So that** I can find parking efficiently without excessive searching.

### US-024: Track Parking Session
**As a** Parking User/Driver,  
**I want to** view my active parking session details (entry time, vehicle type, zone, estimated fee based on duration),  
**So that** I have transparency on accruing charges.

### US-025: View Calculated Fees at Exit
**As a** Parking User/Driver,  
**I want to** see detailed fee breakdown (base fee, duration, vehicle type, applicable surcharges) before payment,  
**So that** I understand how charges were calculated.

### US-026: Make Payment
**As a** Parking User/Driver,  
**I want to** pay parking fees using multiple methods (cash, card, digital wallet),  
**So that** I can exit without delays and parking operates on sustainable revenue model.

### US-027: Pre-book Parking Space
**As a** Parking User/Driver,  
**I want to** reserve a parking space for specific vehicle type, date, and time window,  
**So that** I have guaranteed parking availability when I arrive.

### US-028: Retrieve Pre-booked Session
**As a** Parking User/Driver,  
**I want to** quickly activate my pre-booked reservation at entry using reservation code,  
**So that** entry process is expedited for pre-booked customers.

### US-029: Report Issues
**As a** Parking User/Driver,  
**I want to** report problems (lost ticket, wrong fees charged, facility issue, slot malfunction),  
**So that** facility management can investigate and resolve issues.

### US-030: Cancel Pre-booking
**As a** Parking User/Driver,  
**I want to** cancel my pre-booked reservation and receive refund if applicable,  
**So that** I can adjust plans if parking needs change.

---

## SYSTEM ADMINISTRATOR USER STORIES

### US-031: Manage User Accounts
**As a** System Administrator,  
**I want to** create, update, and deactivate user accounts for managers, staff, and drivers,  
**So that** access is controlled and user information is current.

### US-032: Assign Roles and Permissions
**As a** System Administrator,  
**I want to** assign roles (Manager, Staff, User, Admin) with specific permissions to each user,  
**So that** users can only access functions appropriate to their role.

### US-033: View System Audit Logs
**As a** System Administrator,  
**I want to** view system audit logs showing user actions, data changes, and access events,  
**So that** I can investigate issues and ensure compliance.

### US-034: Configure System Settings
**As a** System Administrator,  
**I want to** configure global system settings (time zone, currency, date format, parking slot quantity limit),  
**So that** the system operates correctly for the deployment environment.

### US-035: Manage Data Backup
**As a** System Administrator,  
**I want to** initiate data backups and view backup status,  
**So that** critical data is protected against loss.

### US-036: Monitor System Health
**As a** System Administrator,  
**I want to** view system health metrics (database status, API availability, storage usage),  
**So that** I can proactively address performance issues.

### US-037: Generate Compliance Reports
**As a** System Administrator,  
**I want to** generate reports for tax and regulatory compliance (transactions, revenue, vehicle records),  
**So that** facility management can fulfill reporting obligations.

---

## SUPPORTING USER STORIES (Exception Handling & Advanced)

### US-038: Track Lost Tickets Workflow
**As a** Parking Staff member,  
**I want to** log lost ticket incidents, search by vehicle characteristics, and resolve ambiguous cases,  
**So that** facility management has visibility into problem frequency and patterns.

### US-039: Reconcile Payment Discrepancies
**As a** Parking Facility Manager,  
**I want to** identify sessions with payment discrepancies and manual adjustments,  
**So that** revenue is accurately accounted for and issues are investigated.

### US-040: Configure Exception Fees
**As a** Parking Facility Manager,  
**I want to** define surcharge rules (overdue fees, wrong zone penalties, recovery fees),  
**So that** exception handling has consistent financial impact.

---

## SUMMARY TABLE

| ID | Role | Feature | Priority |
|---|---|---|---|
| US-001 | Manager | Facility Configuration | HIGH |
| US-002 | Manager | Vehicle Type Management | HIGH |
| US-003 | Manager | Floor/Section Allocation | HIGH |
| US-004 | Manager | Parking Slot Management | HIGH |
| US-005 | Manager | Slot Status Management | HIGH |
| US-006 | Manager | Pricing Configuration | HIGH |
| US-007 | Manager | Real-time Occupancy Monitoring | HIGH |
| US-008 | Manager | Revenue Reporting | HIGH |
| US-009 | Manager | Occupancy Reporting | MEDIUM |
| US-010 | Manager | Exception Tracking | MEDIUM |
| US-011 | Staff | Vehicle Entry Processing | HIGH |
| US-012 | Staff | Zone Direction | MEDIUM |
| US-013 | Staff | Entry Ticket Generation | HIGH |
| US-014 | Staff | Vehicle Exit Processing | HIGH |
| US-015 | Staff | Lost Ticket Handling | MEDIUM |
| US-016 | Staff | Wrong Plate Correction | MEDIUM |
| US-017 | Staff | Overdue Vehicle Handling | MEDIUM |
| US-018 | Staff | Slot Maintenance Status | MEDIUM |
| US-019 | Staff | Exception Fee Collection | MEDIUM |
| US-020 | Staff | Session Details Retrieval | HIGH |
| US-021 | Driver | View Facility Info | HIGH |
| US-022 | Driver | Receive Entry Ticket | HIGH |
| US-023 | Driver | Locate Parking Space | MEDIUM |
| US-024 | Driver | Track Parking Session | HIGH |
| US-025 | Driver | View Fee Breakdown | HIGH |
| US-026 | Driver | Make Payment | HIGH |
| US-027 | Driver | Pre-book Parking | MEDIUM |
| US-028 | Driver | Activate Pre-booking | MEDIUM |
| US-029 | Driver | Report Issues | LOW |
| US-030 | Driver | Cancel Pre-booking | LOW |
| US-031 | Admin | User Account Management | HIGH |
| US-032 | Admin | Role/Permission Assignment | HIGH |
| US-033 | Admin | Audit Logs Viewing | MEDIUM |
| US-034 | Admin | System Configuration | HIGH |
| US-035 | Admin | Data Backup Management | MEDIUM |
| US-036 | Admin | System Health Monitoring | MEDIUM |
| US-037 | Admin | Compliance Reporting | MEDIUM |
| US-038 | Staff | Lost Ticket Workflow | LOW |
| US-039 | Manager | Payment Reconciliation | MEDIUM |
| US-040 | Manager | Exception Fee Configuration | MEDIUM |

---

## ACCEPTANCE CRITERIA MAPPING
- Each user story links to one or more functional requirements (FR-001 through FR-010)
- Detailed acceptance criteria in BDD format are documented in individual FR-XXX.md files
- User story validation occurs during sprint review and UAT phases

