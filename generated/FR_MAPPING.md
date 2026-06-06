# FR_MAPPING.md - Refined Functional Requirements with "System Shall" Language

## Requirement Definition Standards

Each functional requirement is written using strict "The system shall..." language:
- **Precise**: No vague terms like "user-friendly," "fast," "intuitive," or "nice interface"
- **Measurable**: Includes specific thresholds, counts, or time limits where applicable
- **Testable**: Can be verified through automated or manual testing
- **Technical**: Avoids business jargon without context

---

## FR-001: MANAGE PARKING FACILITY INFORMATION

### Refined Requirement Statement
The system shall store and manage parking facility configuration data including facility name, location, address, operating hours, maximum capacity, and amenities. The system shall provide RESTful API endpoints to create, retrieve, update, and deactivate facility records. The system shall validate facility data before persistence and enforce unique constraints on facility names within the deployment instance. The system shall restrict facility management operations to authenticated users with the Administrator or Manager role. The system shall display facility information in the user interface only after successful persistence to the database. The system shall maintain an audit log of all facility data modifications with timestamps and user identifiers.

### Key Constraints
- Facility name: mandatory, string 1-255 characters
- Location: mandatory, geographic coordinates (latitude, longitude) with ±0.0001 degree precision
- Operating hours: mandatory, JSON structure defining opening/closing times for each day of week
- Maximum capacity: mandatory, positive integer (1-9999 parking slots)
- Modification timestamp: automatically set to current UTC time on every update
- Only users with Admin or Manager role can modify facility information

### Dependencies
- Requires database schema creation (parking_facilities table)
- Requires authentication and authorization framework
- Requires audit logging service

---

## FR-002: MANAGE VEHICLE TYPES AND FLOOR/SECTION ALLOCATION

### Refined Requirement Statement
The system shall define vehicle types served by the facility with attributes including type name, size category, dimensional limits (height, width, length in cm), and base hourly rate (in Vietnamese Dong). The system shall allocate floor numbers and section codes to specific vehicle types, creating a mapping between physical space and vehicle category. The system shall prevent allocation conflicts (same section assigned to multiple incompatible vehicle types). The system shall allow only authenticated users with Manager or Administrator role to create, modify, or delete vehicle type and section allocation records. The system shall enforce that section allocation totals do not exceed facility maximum capacity. The system shall provide API endpoints to retrieve complete allocation mappings. The system shall maintain soft deletes for vehicle types (mark inactive rather than remove). The system shall validate all dimensional limits are numeric and positive.

### Key Constraints
- Vehicle type name: mandatory, unique per facility, string 1-100 characters
- Height/Width/Length: mandatory, positive integers 0-999 centimeters
- Base rate: mandatory, positive decimal, precision to 0.01 VND
- Section codes: mandatory, unique per facility, alphanumeric format
- Floor numbers: mandatory, positive integers (1-50 floors typical)
- Only Manager and Admin roles can assign vehicle types to sections
- Over-allocation prevention: sum(sections.total_slots) ≤ facility.max_capacity

---

## FR-003: MANAGE PARKING SLOTS AND THEIR STATUS

### Refined Requirement Statement
The system shall create and maintain individual parking slot records with unique identifiers per facility. The system shall track slot status through one of five states: VACANT (available for entry), IN_USE (occupied), PRE_BOOKED (reserved), MAINTENANCE (not available), or BLOCKED (not available). The system shall enforce valid status transitions: VACANT↔IN_USE, VACANT→PRE_BOOKED, IN_USE→MAINTENANCE, any→BLOCKED. The system shall prevent concurrent assignments of the same slot to multiple parking sessions through transactional database operations. The system shall index slots by facility ID and status to support queries returning availability in ≤500ms. The system shall provide bulk creation operations to create multiple slots for a section in a single transaction. The system shall maintain slot history records for audit trail. The system shall only allow Manager and Staff roles to update slot status. The system shall return HTTP 409 (Conflict) if concurrent slot reservation attempts occur.

### Key Constraints
- Slot code: mandatory, unique per facility, format [SECTION]-[NUMBER] (e.g., A-001, B-047)
- Status: mandatory, one of {VACANT, IN_USE, PRE_BOOKED, MAINTENANCE, BLOCKED}
- Valid transitions: VACANT→[IN_USE|PRE_BOOKED|BLOCKED]; IN_USE→MAINTENANCE; MAINTENANCE→VACANT; any→BLOCKED
- Query performance: slot availability query ≤500ms (use caching if needed)
- Concurrent access: pessimistic locking or database-level constraints required
- Only Manager and Staff (not Driver or User) can update slot status
- Bulk operations: atomic - all slots created or all rolled back on failure

---

## FR-004: MANAGE PRICING AND FEE POLICIES

### Refined Requirement Statement
The system shall store and manage pricing policies defined by facility administrators. Each policy shall include: vehicle type, time period classification (PEAK, OFF_PEAK, WEEKEND, WEEKDAY), hourly rate, daily maximum rate, monthly rate (if offered), and grace period in minutes. The system shall calculate parking fees using the formula: (duration_minutes / 60) × hourly_rate, with rounding rules applied. The system shall round fees to nearest 1000 VND (Vietnamese standard). The system shall apply grace period: if duration ≤ grace_period, charge 0; if duration > grace_period, charge full calculated fee (no grace period deduction). The system shall determine peak/off-peak status based on entry time and configured time windows. The system shall store surcharge rules: lost ticket fee (fixed amount), overdue fee (per hour), wrong zone penalty (percentage or fixed). The system shall validate: all rates ≥ 0, grace period ≥ 0, time windows valid. The system shall only allow Manager and Administrator roles to create/modify pricing policies.

### Key Constraints
- Hourly rate: decimal with 2-digit precision (VND), minimum 10000, maximum 500000
- Daily rate: optional, if set must be ≥ hourly_rate × 8
- Monthly rate: optional, if set must be ≥ daily_rate × 20
- Grace period: 0-30 minutes (typical 0-5 for parking)
- Rounding: to nearest 1000 VND (0.5 VND rounds up)
- Peak hour windows: 24-hour format HH:MM to HH:MM per day
- Surcharges: apply in addition to base fee
- Soft delete pricing policies (mark inactive, keep history)
- Time period detection: based on entry_time, matches facility timezone

---

## FR-005: VEHICLE ENTRY AND PARKING SESSION CREATION

### Refined Requirement Statement
The system shall create a parking session record when a vehicle enters the facility. The system shall capture the following data: vehicle license plate (Vietnamese format), vehicle type (selected by staff or auto-detected if available), entry timestamp (server time, UTC), entry gate identifier, and staff user identifier. The system shall validate vehicle plate format against Vietnamese standard format (e.g., 29A-12345 or similar variants). The system shall automatically allocate an available parking slot from sections designated for the vehicle type. The system shall return HTTP 503 (Service Unavailable) if no slots available for the vehicle type. The system shall generate a unique ticket code (UUID or sequence-based) to identify the parking session. The system shall store the ticket code in the session record. The system shall persist all entry data in an ACID transaction: if any component fails (plate validation, slot allocation), entire operation rolls back. The system shall only allow Staff or Manager roles to create entry sessions. The system shall return the allocated slot information and ticket code to the staff UI within 2 seconds. The system shall log entry event with all captured data to audit trail.

### Key Constraints
- Vehicle plate: mandatory, matches Vietnamese regex pattern, unique per facility per day typically
- Entry timestamp: server time in UTC, stored to millisecond precision
- Entry gate: optional, string 1-50 characters, identifier of entry point
- Ticket code: mandatory, generated unique code, stored encrypted or hashed for lookup
- Slot allocation: transactional, prevents double-booking
- Response time: ≤2 seconds for entry processing
- Authorization: only Staff and Manager roles
- Error handling: 503 if no slots; 400 if invalid plate; 401 if unauthorized
- Audit log: entry event, plate (masked for privacy: XX-12345), gate, staff ID, timestamp

---

## FR-006: VEHICLE EXIT AND FEE COLLECTION

### Refined Requirement Statement
The system shall process vehicle exit by: (1) retrieving the parking session using ticket code or vehicle plate, (2) calculating the fee based on entry and exit timestamps, applied pricing policy, and any applicable surcharges, (3) recording the fee in the database, (4) processing payment transaction, (5) updating parking session status to EXITED, (6) releasing the parked slot to VACANT status, and (7) generating a receipt code. The system shall calculate exit fee using formula: (exit_time - entry_time) / 3600 × hourly_rate, rounded to nearest 1000 VND. The system shall add surcharges if applicable (overdue, wrong zone, etc.). The system shall record payment transaction with amount, payment method (CASH, CARD, DIGITAL_WALLET), payment status (COMPLETED or FAILED), and timestamp. The system shall store payment record in database before releasing the vehicle. The system shall return HTTP 402 (Payment Required) if payment fails. The system shall return HTTP 200 with fee details and payment confirmation on successful exit. The system shall generate a receipt code for audit trail. The system shall only allow Staff or Manager roles to process exit. The system shall ensure idempotency: duplicate exit requests for same session shall not double-charge. The system shall complete exit processing within 3 seconds. The system shall maintain transactional consistency: session closure, payment recording, and slot release all succeed together or all fail.

### Key Constraints
- Exit timestamp: server time in UTC, stored to millisecond precision
- Fee calculation: (duration_minutes / 60) × rate, round to 1000 VND
- Surcharges: applied after base fee calculation
- Payment status: COMPLETED only when payment confirmed
- Payment method: exactly one of {CASH, CARD, DIGITAL_WALLET}
- Receipt code: unique, stored for audit trail
- Idempotency: use idempotent key or session status check (prevent if already EXITED)
- Response time: ≤3 seconds
- Authorization: only Staff and Manager roles
- Transaction: atomic - all components (session, payment, slot) succeed or all fail
- Audit log: exit event, duration, calculated fee, payment method, staff ID, receipt code

---

## FR-007: PARKING SESSION TRACKING AND FEE CALCULATION

### Refined Requirement Statement
The system shall provide API endpoints allowing drivers to retrieve their current and historical parking sessions. The system shall retrieve session information by vehicle plate number or session identifier. The system shall display session details: entry time, vehicle type, assigned zone/floor/slot, current session duration (calculated as current_time - entry_time), and live fee estimate (current_duration × hourly_rate). The system shall update live fee estimate every 30 seconds for current sessions. The system shall store historical sessions for minimum 24 months for audit and dispute resolution. The system shall restrict driver access to only their own sessions (identified by plate number). The system shall restrict manager access to retrieve all sessions. The system shall return HTTP 404 if requested session not found. The system shall return HTTP 403 if driver attempts to view another driver's session. The system shall calculate fee estimates in real-time using current pricing policies (not cached policies). The system shall include payment status in session details (PENDING, COMPLETED, UNPAID). The system shall provide session history with date range filtering.

### Key Constraints
- Session lookup: by plate number (primary), by session_id (backup)
- Live fee estimation: updated every 30 seconds, based on current duration
- Historical retention: minimum 24 months (configurable, default 36 months)
- Authorization: drivers see only their sessions; managers see all
- Response time: session retrieval ≤1 second
- Fee estimate accuracy: ±1% of final calculated fee
- Date filtering: support date range queries with timezone handling
- Access control: 403 Forbidden if unauthorized access attempted
- Privacy: mask sensitive information (plate partially: XX-12345)

---

## FR-008: VIEW PARKING FACILITY INFORMATION (USER)

### Refined Requirement Statement
The system shall provide a public API endpoint returning facility information without authentication requirements. The system shall return facility details: name, address, operating hours, vehicle types served, current occupancy count, total available slots by vehicle type, and pricing for each vehicle type. The system shall return current availability data cached within 5 minutes of actual slot state. The system shall return facility information in response time ≤500ms. The system shall return HTTP 404 if facility not found. The system shall support facility lookup by facility identifier only (no search or filtering). The system shall return occupancy percentage (occupied_slots / total_slots × 100). The system shall return pricing information in JSON format with vehicle type as key and rates (hourly, daily, monthly) as value. The system shall include operating hours in 24-hour format {day: [opening_time, closing_time]} for each day of week. The system shall return amenities list (if available). The system shall not require authentication for this endpoint. The system shall log all requests for analytics purposes (anonymized). The system shall implement caching to support high query volume without database strain.

### Key Constraints
- Response time: ≤500ms, including cache lookup
- Cache refresh: maximum 5-minute staleness
- Data returned: name, address, hours, vehicle types, pricing, occupancy, availability
- No authentication required (public endpoint)
- Facility lookup: by facility_id only
- Occupancy calculation: (occupied_slots / total_slots) × 100, return as percentage 0-100
- Rate format: hourly_rate, daily_rate, monthly_rate in VND
- Hours format: {mon: [08:00, 22:00], tue: [...], ...}
- Response status: 200 success, 404 not found
- Logging: requests logged with facility_id, timestamp, response_time (no IP or sensitive data)

---

## FR-009: PRE-BOOKING PARKING SPACES

### Refined Requirement Statement
The system shall allow drivers to reserve parking spaces for specified vehicle type, date, and time window. The system shall store reservations with data: facility_id, vehicle_type_id, reservation_date, start_time, end_time, driver_contact (phone or email), and reservation_code. The system shall check facility capacity and available slots for requested vehicle type and time period. The system shall return HTTP 409 (Conflict) if no slots available for requested parameters. The system shall generate unique reservation code (format: YYYYMMDD-XXXXX). The system shall validate reservation parameters: date ≥ today, time windows valid (start_time < end_time), duration ≥ 30 minutes and ≤ 24 hours. The system shall only allow driver to make reservations for themselves (vehicle_type confirmed, contact verified). The system shall store reservation with status PENDING (awaiting confirmation). The system shall auto-confirm reservations within 5 minutes or mark CONFIRMED. The system shall auto-cancel reservations 15 minutes before start_time if not activated. The system shall provide API to activate reservation at entry (using reservation_code, transitions session to ACTIVE). The system shall allow drivers to cancel reservations up to 2 hours before start_time. The system shall store all reservation states and transitions in audit log.

### Key Constraints
- Reservation date: mandatory, ≥ today, ≤ 90 days in future
- Time window: mandatory, start_time < end_time, minimum 30 minutes, maximum 24 hours
- Reservation code: unique, format YYYYMMDD-XXXXX, returned to driver immediately
- Status transitions: PENDING → CONFIRMED → ACTIVE → COMPLETED or CANCELLED or EXPIRED
- Auto-confirm: within 5 minutes of creation if slots available
- Auto-cancel: 15 minutes before start_time (unused)
- Cancellation: allowed ≤2 hours before start_time
- Overbooking prevention: real-time availability check, transactional
- Authorization: drivers can only view/modify own reservations
- Contact validation: phone (Vietnamese format) or email required
- Response time: reservation creation ≤2 seconds

---

## FR-010: REPORTS AND ANALYTICS

### Refined Requirement Statement
The system shall generate four standard reports: Entry/Exit Volume, Revenue, Occupancy, and Exceptions. Entry/Exit Volume Report shall display entry and exit counts by hour, day, vehicle type, and gate. Revenue Report shall display total revenue, revenue by payment method, revenue by vehicle type, and revenue by time period. Occupancy Report shall display occupancy rate trends (percentage occupied over time), occupied/vacant slot counts by section, and peak hours by vehicle type. Exceptions Report shall display count and breakdown of exceptions: lost tickets, wrong plates, overdue vehicles, unpaid vehicles, and payment failures. All reports shall support date range filtering (start_date to end_date inclusive). All reports shall group data by day, week, or month based on date range (≤7 days: hourly, ≤31 days: daily, >31 days: weekly). All reports shall display data in tabular format with totals row. The system shall calculate occupancy rate as (occupied_slots_at_time / total_slots) × 100. The system shall identify peak hours as hours where occupancy ≥ 80% of daily average. Revenue calculation shall sum all completed payment transactions within date range. The system shall only allow Manager and Administrator roles to access reports. The system shall cache report queries; refresh cache every 1 hour or on demand. The system shall support CSV export for all reports. Report generation shall complete within 5 seconds for date range ≤90 days. The system shall handle timezone correctly (all times stored in UTC, display in facility timezone).

### Key Constraints
- Date filtering: start_date, end_date (inclusive), maximum range 365 days
- Grouping: hourly (≤7 days), daily (≤31 days), weekly (>31 days)
- Occupancy calculation: (occupied / total) × 100, store as percentage
- Peak hour definition: occupancy ≥ 80% of daily average occupancy
- Revenue: sum of completed transactions only (status = COMPLETED)
- Exception types: LOST_TICKET, WRONG_PLATE, OVERDUE, WRONG_ZONE, UNPAID
- Report formats: JSON (default), CSV export
- Response time: ≤5 seconds for reports ≤90 day range
- Authorization: Manager and Admin only
- Cache refresh: every 1 hour or on-demand
- Timezone: store in UTC, display in facility timezone
- Data retention: 36 months minimum for analytics

---

## CROSS-REQUIREMENT DEPENDENCIES

| FR | Depends On | Relationship |
|----|----|---|
| FR-002 | FR-001 | Vehicle types and sections reference facilities |
| FR-003 | FR-002 | Parking slots belong to sections |
| FR-005 | FR-003, FR-004 | Entry uses slot allocation and pricing |
| FR-006 | FR-005, FR-004 | Exit processes fees from active sessions |
| FR-007 | FR-005, FR-006 | Session tracking queries active/historical sessions |
| FR-009 | FR-003 | Pre-booking reserves slots |
| FR-010 | FR-005, FR-006 | Reports aggregate session and payment data |

---

## REFINEMENT SUMMARY

### Removed Vague Language
- ❌ "User-friendly interface" → ✅ "Specific UI components with defined interactions"
- ❌ "Fast performance" → ✅ "Response time ≤500ms" or "≤2 seconds"
- ❌ "Nice features" → ✅ "Optional amenities display, monthly rate support"
- ❌ "Easy to use" → ✅ "Three-field entry form, bulk creation support"

### Added Precision
- ❌ "Parking slots" → ✅ "Parking slots with unique codes [SECTION]-[NUMBER] format"
- ❌ "Fee calculation" → ✅ "(duration_minutes / 60) × hourly_rate, rounded to 1000 VND"
- ❌ "Manage vehicle types" → ✅ "Create, read, update, soft-delete vehicle types with dimensional limits"
- ❌ "View availability" → ✅ "List available slots by section, cached within 5 minutes, ≤500ms response time"

### Added Constraints & Validation Rules
- Numeric precision: 2-digit decimal for currency
- Rounding rules: to nearest 1000 VND
- Time precision: millisecond accuracy for timestamps
- Uniqueness constraints: facility names, slot codes, ticket codes, reservation codes
- Authorization matrix: who can perform each operation
- Response times: ≤500ms, ≤2 seconds, ≤3 seconds, ≤5 seconds per context

