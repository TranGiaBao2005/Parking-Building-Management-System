# GITHUB_ISSUES.md - GitHub Issue Templates for Parking System Features

## GitHub Issue Templates

Use these templates to create issues for each functional requirement in your GitHub repository. Customize labels, assignees, and projects as needed.

---

## ISSUE TEMPLATE: FR-001 Manage Parking Facility Information

```markdown
---
name: FR-001 Manage Parking Facility Information
about: Create and manage parking facility core configuration
title: '[FR-001] Manage parking facility information'
labels: 'feature, FR-001, backend, frontend, database'
assignees: ''
---

## Description
Implement complete facility management system allowing facility administrators to create, update, and retrieve parking facility configuration including name, location, operating hours, and capacity.

## Acceptance Criteria
- [ ] Database schema created with `facilities` table (id, name, location, address, operating_hours_json, max_capacity, created_at, updated_at)
- [ ] API endpoint `POST /api/v1/facilities` creates facility with validation
- [ ] API endpoint `GET /api/v1/facilities/:id` retrieves facility details
- [ ] API endpoint `PUT /api/v1/facilities/:id` updates facility information
- [ ] Authorization enforced: only Admin and Manager roles can modify
- [ ] Facility name uniqueness constraint enforced
- [ ] Front-end FacilityDetailsPage component displays facility information
- [ ] Front-end FacilityEditForm component allows editing with validation
- [ ] Operating hours editor component for multi-day hour configuration
- [ ] Audit logging implemented for all facility modifications
- [ ] Error handling: 400 (invalid data), 403 (unauthorized), 404 (not found), 409 (conflict)

## Tasks
- [ ] Database design and migration
- [ ] Backend API implementation
- [ ] Frontend component development
- [ ] Form validation and error handling
- [ ] Authorization middleware integration
- [ ] Unit tests (API and service layer)
- [ ] Integration tests (database and API)
- [ ] UI/UX testing

## Estimated Effort
40-60 hours (1-1.5 sprints)

## Priority
🔴 CRITICAL - MVP Phase 1

## Related Issues
- None (foundation feature)

---
```

## ISSUE TEMPLATE: FR-002 Manage Vehicle Types and Floor/Section Allocation

```markdown
---
name: FR-002 Manage Vehicle Types and Floor/Section Allocation
about: Configure vehicle types and allocate facility sections by type
title: '[FR-002] Manage vehicle types and floor/section allocation'
labels: 'feature, FR-002, backend, frontend, database'
assignees: ''
---

## Description
Implement vehicle type management (motorcycles, cars, vans, trucks) with facility section allocation allowing managers to assign specific floors/sections to vehicle types.

## Acceptance Criteria
- [ ] Database schema: `vehicle_types` table (id, facility_id, type_name, size_category, height_limit_cm, width_limit_cm, length_limit_cm, base_rate_per_hour)
- [ ] Database schema: `facility_sections` table (id, facility_id, section_name, floor_number, section_code, vehicle_type_id, total_slots)
- [ ] API endpoint `POST /api/v1/facilities/:id/vehicle-types` creates vehicle type
- [ ] API endpoint `GET /api/v1/facilities/:id/vehicle-types` lists vehicle types
- [ ] API endpoint `PUT /api/v1/vehicle-types/:typeId` updates vehicle type
- [ ] API endpoint `DELETE /api/v1/vehicle-types/:typeId` soft-deletes vehicle type
- [ ] API endpoint `POST /api/v1/facilities/:id/sections` creates section with allocation
- [ ] API endpoint `GET /api/v1/facilities/:id/sections` lists sections with allocation
- [ ] Validation: section allocation total slots ≤ facility max capacity
- [ ] Authorization: only Manager and Admin roles can manage
- [ ] Frontend VehicleTypeManagementPage with CRUD interface
- [ ] Frontend SectionAllocationPage with allocation matrix visualization
- [ ] Unique constraint on (facility_id, type_name) and (facility_id, section_code)
- [ ] Error handling: 400 (invalid), 403 (unauthorized), 409 (conflict/over-allocation)

## Tasks
- [ ] Database design and migration
- [ ] Vehicle type CRUD service implementation
- [ ] Section allocation service implementation
- [ ] Backend API endpoints
- [ ] Frontend management components
- [ ] Allocation validation logic
- [ ] Unit tests (services and APIs)
- [ ] Integration tests
- [ ] UI/UX testing

## Estimated Effort
60-80 hours (1.5-2 sprints)

## Priority
🟡 MEDIUM-HIGH (MVP Phase 1, but can use single type initially)

## Related Issues
- Depends on: FR-001

---
```

## ISSUE TEMPLATE: FR-003 Manage Parking Slots and Their Status

```markdown
---
name: FR-003 Manage Parking Slots and Their Status
about: Create and manage individual parking slots with status tracking
title: '[FR-003] Manage parking slots and their status'
labels: 'feature, FR-003, backend, frontend, database, performance'
assignees: ''
---

## Description
Implement parking slot management system allowing creation, tracking, and status updates of individual parking slots with concurrency control and real-time availability.

## Acceptance Criteria
- [ ] Database schema: `parking_slots` table (id, facility_id, section_id, slot_code, floor_number, status, is_handicap_accessible, created_at, updated_at)
- [ ] Status enum: VACANT, IN_USE, PRE_BOOKED, MAINTENANCE, BLOCKED
- [ ] Valid status transitions enforced (VACANT↔IN_USE, VACANT→PRE_BOOKED, IN_USE→MAINTENANCE, any→BLOCKED)
- [ ] API endpoint `POST /api/v1/sections/:id/slots` bulk creates slots atomically
- [ ] API endpoint `GET /api/v1/facilities/:id/slots` lists slots with status filtering
- [ ] API endpoint `GET /api/v1/sections/:id/slots` lists section slots
- [ ] API endpoint `PATCH /api/v1/slots/:slotId/status` updates slot status
- [ ] API endpoint `GET /api/v1/facilities/:id/availability` returns availability summary
- [ ] Concurrent slot reservation handled (pessimistic/optimistic locking)
- [ ] Indices on (facility_id, status) and (section_id, status) for query performance
- [ ] Availability queries respond in ≤500ms
- [ ] Unique index on (facility_id, slot_code)
- [ ] Authorization: only Manager and Staff can update status
- [ ] Frontend SlotManagementPage with visualization
- [ ] Frontend SlotVisualizer component (floor map with color-coded status)
- [ ] Bulk slot creation form with template-based generation
- [ ] Real-time occupancy updates (WebSocket or polling)
- [ ] HTTP 409 response on concurrent reservation conflict
- [ ] Audit log maintained for all slot status changes

## Tasks
- [ ] Database schema and migration
- [ ] Concurrent access control implementation (choose locking strategy)
- [ ] Backend API endpoints
- [ ] SlotManagementService implementation
- [ ] Availability query optimization (caching/materialized view)
- [ ] Frontend components development
- [ ] Real-time update mechanism (WebSocket setup)
- [ ] Comprehensive test coverage
- [ ] Performance testing and optimization
- [ ] UI/UX testing

## Estimated Effort
80-100 hours (2-2.5 sprints)

## Priority
🔴 CRITICAL (MVP Phase 1, core feature)

## Related Issues
- Depends on: FR-001, FR-002

---
```

## ISSUE TEMPLATE: FR-004 Manage Pricing and Fee Policies

```markdown
---
name: FR-004 Manage Pricing and Fee Policies
about: Configure flexible pricing policies and fee calculation rules
title: '[FR-004] Manage pricing and fee policies'
labels: 'feature, FR-004, backend, frontend, database, critical'
assignees: ''
---

## Description
Implement pricing management system supporting hourly rates, daily rates, monthly rates, peak/off-peak pricing, grace periods, and surcharges with precise fee calculation logic.

## Acceptance Criteria
- [ ] Database schema: `pricing_policies` table (id, facility_id, policy_name, vehicle_type_id, time_period, rate_per_hour, daily_rate, monthly_rate, grace_period_minutes, active)
- [ ] Database schema: `fee_surcharges` table (id, facility_id, surcharge_type, amount, description, active)
- [ ] Time_period enum: PEAK, OFF_PEAK, WEEKEND, WEEKDAY
- [ ] API endpoint `POST /api/v1/facilities/:id/pricing-policies` creates policy
- [ ] API endpoint `GET /api/v1/facilities/:id/pricing-policies` lists policies
- [ ] API endpoint `PUT /api/v1/pricing-policies/:policyId` updates policy
- [ ] API endpoint `DELETE /api/v1/pricing-policies/:policyId` deactivates policy
- [ ] API endpoint `POST /api/v1/facilities/:id/surcharges` manages surcharges
- [ ] Fee calculation formula: (duration_minutes / 60) × hourly_rate
- [ ] Rounding to nearest 1000 VND implemented
- [ ] Grace period logic: if duration ≤ grace_period, charge 0; else charge full fee
- [ ] Peak/off-peak determination based on entry time and policy time windows
- [ ] Surcharge application: lost ticket, overdue, wrong zone
- [ ] Validation: rates ≥ 0, grace period sensible, time windows valid
- [ ] Authorization: only Manager and Admin can manage pricing
- [ ] FeeCalculationService with comprehensive test suite (>100 test cases)
- [ ] Frontend PricingPolicyPage with CRUD interface
- [ ] Frontend PricingPreviewCard showing sample calculations
- [ ] Frontend pricing simulation tool for drivers
- [ ] Fixed-point arithmetic used (not floating-point) for currency
- [ ] Error handling: 400 (invalid), 403 (unauthorized), 409 (conflict)

## Tasks
- [ ] Database schema design and migration
- [ ] FeeCalculationService implementation (fixed-point math)
- [ ] Peak/off-peak time detection service
- [ ] Backend API endpoints for policy management
- [ ] Backend API endpoints for fee calculation
- [ ] Surcharge service implementation
- [ ] Frontend management components
- [ ] Frontend preview and simulation tools
- [ ] Comprehensive unit tests (fees, rounding, surcharges)
- [ ] Edge case testing (grace periods, overlapping policies, timezone handling)
- [ ] Performance testing
- [ ] UI/UX testing

## Estimated Effort
70-90 hours (1.75-2.25 sprints)

## Priority
🔴 CRITICAL (MVP Phase 1, revenue-critical)

## Related Issues
- Depends on: FR-001, FR-002

---
```

## ISSUE TEMPLATE: FR-005 Vehicle Entry and Parking Session Creation

```markdown
---
name: FR-005 Vehicle Entry and Parking Session Creation
about: Process vehicle entry and create parking sessions with ticket generation
title: '[FR-005] Vehicle entry and parking session creation'
labels: 'feature, FR-005, backend, frontend, database, critical'
assignees: ''
---

## Description
Implement vehicle entry processing system capturing plate information, vehicle type, assigning parking slot, generating ticket code, and creating parking session record.

## Acceptance Criteria
- [ ] Database schema: `parking_sessions` table (id, facility_id, vehicle_plate, vehicle_type_id, section_id, slot_id, entry_time, entry_gate, staff_id, ticket_code, session_status)
- [ ] Session_status enum: ACTIVE, EXITED, LOST_TICKET, EXCEPTION
- [ ] API endpoint `POST /api/v1/sessions` creates entry session
- [ ] Vehicle plate validation against Vietnamese format
- [ ] Automatic available slot allocation for vehicle type
- [ ] HTTP 503 response when no available slots
- [ ] Unique ticket code generation (UUID or sequence)
- [ ] Entry data persisted in ACID transaction
- [ ] Authorization: only Staff and Manager can create sessions
- [ ] Response time: ≤2 seconds for entry processing
- [ ] Indices on (facility_id, entry_time), (vehicle_plate), (ticket_code)
- [ ] Frontend VehicleEntryPage for staff entry processing
- [ ] Frontend PlateInputForm with barcode scanner integration
- [ ] Frontend VehicleTypeSelector
- [ ] Frontend EntryConfirmationModal showing allocated zone/slot
- [ ] Barcode scanner support (USB HID emulation)
- [ ] Fallback to manual plate entry if scanner fails
- [ ] Ticket printing/display functionality
- [ ] Audit log: entry event, plate (masked), gate, staff ID, timestamp
- [ ] Error handling: 400 (invalid plate), 403 (unauthorized), 503 (no slots), 409 (concurrent)

## Tasks
- [ ] Database schema and migration
- [ ] Session creation service implementation
- [ ] Slot allocation algorithm (automatic or request-based)
- [ ] Plate format validation service
- [ ] Ticket code generation service
- [ ] Transaction management for atomic operations
- [ ] Backend API implementation
- [ ] Barcode scanner integration (USB support)
- [ ] Frontend entry processing page
- [ ] Plate input form with validation
- [ ] Scanner error handling and fallback
- [ ] Ticket generation and printing
- [ ] Unit tests (validation, allocation, transaction)
- [ ] Integration tests (concurrent entries)
- [ ] Manual testing with actual scanner
- [ ] UI/UX testing

## Estimated Effort
100-130 hours (2.5-3.25 sprints)

## Priority
🔴 CRITICAL (MVP Phase 1, core revenue flow)

## Related Issues
- Depends on: FR-001, FR-002, FR-003, FR-004

---
```

## ISSUE TEMPLATE: FR-006 Vehicle Exit and Fee Collection

```markdown
---
name: FR-006 Vehicle Exit and Fee Collection
about: Process vehicle exit, calculate fees, handle payment, and release parking slot
title: '[FR-006] Vehicle exit and fee collection'
labels: 'feature, FR-006, backend, frontend, database, critical, payments'
assignees: ''
---

## Description
Implement vehicle exit processing with fee calculation, payment transaction recording, parking session closure, and slot release. Support multiple payment methods and ensure revenue accuracy.

## Acceptance Criteria
- [ ] Database schema: `payment_records` table (id, session_id, amount, payment_method, payment_status, receipt_code, processed_at)
- [ ] Database schema: `session_fees` table (id, session_id, base_fee, surcharge_amount, total_fee, fee_breakdown_json, calculated_at)
- [ ] Payment_method enum: CASH, CARD, DIGITAL_WALLET, PREPAID
- [ ] Payment_status enum: COMPLETED, FAILED, PENDING, REFUNDED
- [ ] API endpoint `POST /api/v1/sessions/:sessionId/calculate-fee` calculates exit fee
- [ ] API endpoint `POST /api/v1/sessions/:sessionId/exit` processes complete exit
- [ ] API endpoint `POST /api/v1/payments` records payment transaction
- [ ] Fee calculation: (exit_time - entry_time) / 3600 × hourly_rate
- [ ] Rounding to nearest 1000 VND
- [ ] Surcharge application: overdue, wrong zone, lost ticket
- [ ] Receipt code generation (unique per transaction)
- [ ] Transactional consistency: session closure + payment + slot release atomic
- [ ] HTTP 200 with fee details on success
- [ ] HTTP 402 (Payment Required) on payment failure
- [ ] HTTP 404 on session not found
- [ ] Idempotency: duplicate exit requests don't double-charge
- [ ] Response time: ≤3 seconds
- [ ] Authorization: only Staff and Manager
- [ ] Frontend VehicleExitPage for staff exit processing
- [ ] Frontend TicketLookupForm (search by ticket code or plate)
- [ ] Frontend FeeDetailsCard (entry time, duration, fee breakdown)
- [ ] Frontend PaymentMethodSelector (cash, card, wallet)
- [ ] Frontend PaymentProcessingForm (amount input, card reader)
- [ ] Frontend ReceiptDisplay with print option
- [ ] Audit log: exit event, duration, fees, payment method, staff ID, receipt code
- [ ] Payment error handling and recovery

## Tasks
- [ ] Database schema and migration
- [ ] ExitProcessingService implementation
- [ ] Fee calculation with fee breakdown tracking
- [ ] Session lookup by ticket/plate
- [ ] Payment transaction recording service
- [ ] Slot release mechanism
- [ ] Transactional exit processing (all-or-nothing)
- [ ] Idempotency key implementation or session status check
- [ ] Receipt code generation service
- [ ] Backend API endpoints
- [ ] Payment method selector UI
- [ ] Lookup form implementation
- [ ] Fee details card component
- [ ] Receipt display and printing
- [ ] Error handling and user feedback
- [ ] Unit tests (fee calculation edge cases, idempotency)
- [ ] Integration tests (payment flow, transaction consistency)
- [ ] Manual testing with different payment methods
- [ ] UI/UX testing

## Estimated Effort
120-160 hours (3-4 sprints)

## Priority
🔴 CRITICAL (MVP Phase 1, revenue-critical)

## Related Issues
- Depends on: FR-005, FR-004

---
```

## ISSUE TEMPLATE: FR-007 Parking Session Tracking and Fee Calculation

```markdown
---
name: FR-007 Parking Session Tracking and Fee Calculation
about: Track parking sessions and provide live fee estimates for drivers
title: '[FR-007] Parking session tracking and fee calculation'
labels: 'feature, FR-007, backend, frontend, user-facing'
assignees: ''
---

## Description
Provide drivers with real-time visibility into their parking sessions including entry time, duration, assigned zone, and live fee estimates that update every 30 seconds.

## Acceptance Criteria
- [ ] API endpoint `GET /api/v1/drivers/sessions/:plateNumber` retrieves current/past sessions
- [ ] API endpoint `GET /api/v1/drivers/sessions/:sessionId` retrieves session tracking details
- [ ] API endpoint `GET /api/v1/drivers/sessions/:sessionId/fee-estimate` calculates live fee
- [ ] Session details include: entry time, duration (live), vehicle type, zone, slot
- [ ] Live fee estimate updates every 30 seconds (±1% of final fee)
- [ ] Historical sessions queryable with date range filtering
- [ ] Session history retained minimum 24 months
- [ ] Authorization: drivers see only their sessions; managers see all
- [ ] Response time: session retrieval ≤1 second
- [ ] HTTP 404 on session not found
- [ ] HTTP 403 on unauthorized access (driver viewing another driver's session)
- [ ] Frontend SessionTrackingPage (driver view of current session)
- [ ] Frontend SessionDetailsCard (entry time, duration, zone, slot, live fee)
- [ ] Frontend LiveFeeEstimateWidget (real-time fee updating)
- [ ] Frontend SessionHistoryPage (past sessions with fee details)
- [ ] Frontend SessionEventTimeline (visual timeline)
- [ ] Auto-refresh: WebSocket or polling every 30 seconds
- [ ] Payment status included in session details (PENDING, COMPLETED, UNPAID)
- [ ] Database index on (facility_id, entry_time) and (vehicle_plate, entry_time)

## Tasks
- [ ] SessionTrackingService implementation
- [ ] Live fee estimation algorithm (current_duration × rate)
- [ ] Backend API endpoint implementations
- [ ] Session history query with date range support
- [ ] Authorization logic for driver vs. manager
- [ ] Frontend session tracking page
- [ ] Real-time update mechanism (WebSocket setup)
- [ ] Live fee widget with auto-refresh
- [ ] Session event timeline component
- [ ] Session history page with filtering
- [ ] Unit tests (fee estimation, authorization)
- [ ] Integration tests (real-time updates)
- [ ] Performance testing (query optimization)
- [ ] UI/UX testing

## Estimated Effort
40-60 hours (1-1.5 sprints)

## Priority
🟡 MEDIUM (Phase 1b, informational feature)

## Related Issues
- Depends on: FR-005

---
```

## ISSUE TEMPLATE: FR-008 View Parking Facility Information (User)

```markdown
---
name: FR-008 View Parking Facility Information (User)
about: Provide drivers with public facility information and current availability
title: '[FR-008] View parking facility information (user)'
labels: 'feature, FR-008, backend, frontend, user-facing, public'
assignees: ''
---

## Description
Provide public endpoint for drivers to view facility details without authentication including operating hours, vehicle types served, pricing, current occupancy, and available slots.

## Acceptance Criteria
- [ ] API endpoint `GET /api/v1/public/facilities/:id/info` returns facility information
- [ ] API endpoint `GET /api/v1/public/facilities/:id/availability` returns current availability
- [ ] API endpoint `GET /api/v1/public/facilities/:id/pricing` returns pricing information
- [ ] No authentication required for public endpoints
- [ ] Response time: ≤500ms
- [ ] Occupancy percentage calculated and returned (0-100%)
- [ ] Available slots displayed by vehicle type
- [ ] Pricing returned with hourly, daily, monthly rates
- [ ] Operating hours returned in 24-hour format
- [ ] Amenities list included (if available)
- [ ] Availability data cached within 5-minute maximum staleness
- [ ] HTTP 404 on facility not found
- [ ] Frontend FacilityInfoPage (public view for drivers)
- [ ] Frontend FacilityDetailsCard (name, address, hours, phone)
- [ ] Frontend AvailabilityDisplay (occupancy %, vacant slots by type)
- [ ] Frontend PricingTable (rates by vehicle type)
- [ ] Frontend CapacityGaugeChart (visual occupancy representation)
- [ ] Cache invalidation on entry/exit events
- [ ] Analytics logging (requests per facility, response times)

## Tasks
- [ ] PublicFacilityService implementation
- [ ] Data caching strategy (5-minute TTL)
- [ ] Backend API endpoints (public endpoints)
- [ ] Cache invalidation on entry/exit
- [ ] Frontend facility info page
- [ ] Availability display component
- [ ] Pricing table component
- [ ] Occupancy gauge chart
- [ ] Performance optimization
- [ ] Testing (cache behavior, response times)
- [ ] UI/UX testing

## Estimated Effort
30-40 hours (0.75-1 sprint)

## Priority
🟢 LOW (Phase 1b, public information)

## Related Issues
- Depends on: FR-001, FR-002, FR-003

---
```

## ISSUE TEMPLATE: FR-009 Pre-booking Parking Spaces

```markdown
---
name: FR-009 Pre-booking Parking Spaces
about: Allow drivers to reserve parking spaces in advance
title: '[FR-009] Pre-booking parking spaces'
labels: 'feature, FR-009, backend, frontend, user-facing'
assignees: ''
---

## Description
Implement parking reservation system allowing drivers to pre-book spaces by vehicle type, date, and time with automatic confirmation/cancellation and reservation code generation.

## Acceptance Criteria
- [ ] Database schema: `reservations` table (id, facility_id, vehicle_type_id, driver_contact, reservation_date, start_time, end_time, reservation_code, status)
- [ ] Status enum: PENDING, CONFIRMED, ACTIVE, COMPLETED, CANCELLED, EXPIRED
- [ ] API endpoint `POST /api/v1/reservations` creates reservation
- [ ] API endpoint `GET /api/v1/reservations/:reservationId` retrieves reservation
- [ ] API endpoint `PUT /api/v1/reservations/:reservationId` modifies reservation
- [ ] API endpoint `DELETE /api/v1/reservations/:reservationId` cancels reservation
- [ ] Reservation date: ≥ today, ≤ 90 days future
- [ ] Time window: start_time < end_time, duration 30 min - 24 hours
- [ ] Unique reservation code generation (format: YYYYMMDD-XXXXX)
- [ ] Availability check: prevent double-booking of slots
- [ ] Auto-confirm reservations within 5 minutes if slots available
- [ ] Auto-cancel unused reservations 15 minutes before start_time
- [ ] Cancellation allowed up to 2 hours before start_time
- [ ] Contact validation: phone (Vietnamese format) or email
- [ ] HTTP 409 (Conflict) if no availability
- [ ] Authorization: drivers can only view/modify own reservations
- [ ] Frontend ReservationPage (driver reservation interface)
- [ ] Frontend ReservationForm (date/time picker, vehicle type, contact)
- [ ] Frontend AvailabilityChecker (show available slots for date/time)
- [ ] Frontend ReservationConfirmationModal
- [ ] Frontend ReservationHistoryPage (past and upcoming reservations)
- [ ] Activation at entry: use reservation_code to activate
- [ ] Response time: reservation creation ≤2 seconds
- [ ] Transactional overbooking prevention
- [ ] Audit log: reservation state transitions

## Tasks
- [ ] Database schema and migration
- [ ] ReservationService implementation
- [ ] Availability checking algorithm
- [ ] Auto-confirm scheduled job
- [ ] Auto-cancel scheduled job
- [ ] Reservation code generation
- [ ] Backend API endpoints
- [ ] Contact validation service
- [ ] Frontend reservation page
- [ ] Date/time picker component
- [ ] Availability checker component
- [ ] Reservation history page
- [ ] Activation mechanism at entry
- [ ] Unit tests (availability, auto-processes)
- [ ] Integration tests (reservation flow)
- [ ] UI/UX testing

## Estimated Effort
70-90 hours (1.75-2.25 sprints)

## Priority
🟡 MEDIUM (Phase 1b/Phase 2, premium feature)

## Related Issues
- Depends on: FR-001, FR-002, FR-003

---
```

## ISSUE TEMPLATE: FR-010 Reports and Analytics

```markdown
---
name: FR-010 Reports and Analytics
about: Generate business intelligence reports on volume, revenue, occupancy, and exceptions
title: '[FR-010] Reports and analytics'
labels: 'feature, FR-010, backend, frontend, analytics'
assignees: ''
---

## Description
Implement reporting system providing managers with actionable insights: Entry/Exit Volume, Revenue, Occupancy, and Exceptions reports with filtering and export capabilities.

## Acceptance Criteria
- [ ] Report types: Entry/Exit Volume, Revenue, Occupancy, Exceptions
- [ ] Date range filtering: start_date to end_date (inclusive, max 365 days)
- [ ] Grouping by period: hourly (≤7 days), daily (≤31 days), weekly (>31 days)
- [ ] API endpoint `GET /api/v1/reports/entry-exit-volume` (hourly/daily volume by gate, type)
- [ ] API endpoint `GET /api/v1/reports/revenue` (revenue by method, vehicle type, period)
- [ ] API endpoint `GET /api/v1/reports/occupancy` (occupancy trends, peak hours)
- [ ] API endpoint `GET /api/v1/reports/exceptions` (count and breakdown of exceptions)
- [ ] Occupancy rate: (occupied_slots / total_slots) × 100
- [ ] Peak hours: occupancy ≥ 80% of daily average
- [ ] Revenue calculation: sum of completed transactions
- [ ] Exception types: LOST_TICKET, WRONG_PLATE, OVERDUE, WRONG_ZONE, UNPAID
- [ ] Response time: ≤5 seconds for reports ≤90 days
- [ ] Authorization: Manager and Admin only
- [ ] Caching: reports cached, refresh every 1 hour or on-demand
- [ ] CSV export for all reports
- [ ] Timezone handling: store UTC, display facility timezone
- [ ] Data retention: minimum 36 months
- [ ] Frontend ReportsPage (manager dashboard)
- [ ] Frontend DateRangeSelector (date filtering)
- [ ] Frontend EntryExitVolumeChart (bar/line chart)
- [ ] Frontend RevenueChart (trend and breakdown)
- [ ] Frontend OccupancyHeatmap (by hour and day)
- [ ] Frontend PeakHoursAnalysis
- [ ] Frontend ExceptionsSummary (count and breakdown)
- [ ] Frontend ExportButton (CSV/PDF download)
- [ ] Error handling: large date ranges, missing data

## Tasks
- [ ] Database denormalization (analytics_aggregates table) or materialized views
- [ ] Nightly aggregation job implementation
- [ ] AnalyticsService with aggregation logic
- [ ] Backend report API endpoints
- [ ] Caching strategy (hourly refresh)
- [ ] Date range and grouping logic
- [ ] Peak hours calculation
- [ ] Revenue aggregation queries
- [ ] Exception counting and breakdown
- [ ] CSV export service
- [ ] Frontend reports page
- [ ] Charts and visualizations (charting library)
- [ ] Date range selector component
- [ ] Export button implementation
- [ ] Performance optimization (large result sets)
- [ ] Unit tests (aggregation logic)
- [ ] Integration tests (report generation)
- [ ] UI/UX testing

## Estimated Effort
60-80 hours (1.5-2 sprints)

## Priority
🟡 MEDIUM (Phase 1b, important for management but not blocking)

## Related Issues
- Depends on: FR-005, FR-006

---
```

---

## HOW TO USE THESE TEMPLATES

### In GitHub Repository
1. Save each template block as `.github/ISSUE_TEMPLATE/FR-XXX.yml` (YAML format) or `.github/ISSUE_TEMPLATE/FR-XXX.md` (Markdown format)
2. Adjust labels based on your repository configuration
3. Customize assignees and projects as needed

### Creating Issues
1. Go to GitHub repository → Issues → New Issue
2. Select appropriate FR-XXX template
3. Fill in title, description, acceptance criteria
4. Assign to team member
5. Add to project/milestone for Phase 1 or Phase 1b

### Template Customization
- Add your team's specific labels
- Include links to Slack channels or documentation
- Add acceptance tests checklist items
- Reference architecture diagrams if available

---

## SAMPLE GITHUB WORKFLOW

### Week 1-2: FR-001 Sprint
1. Create issue from FR-001 template
2. Break down into 2-3 pull requests (schema, API, UI)
3. Assign to backend and frontend developers
4. Complete within 1-2 sprints

### Week 3-4: FR-002 + FR-003 Sprint (Parallel)
1. Create FR-002 and FR-003 issues
2. Coordinate database schema to ensure FK relationships
3. Parallel development: backend APIs + frontend UI
4. FR-003 includes performance optimization sprint

### Week 5-6: FR-004 + FR-005 Sprint
1. Create FR-004 (pricing) issue
2. Create FR-005 (entry) issue
3. FR-004 must complete before FR-005 full testing
4. Comprehensive test coverage for fee calculation

### Week 7-8: FR-006 + FR-009 Sprint
1. Create FR-006 (exit) issue - high priority
2. Create FR-009 (pre-booking) - lower priority, can slip
3. Payment integration testing critical
4. Exception handling review

### Week 9-10: FR-010 Sprint
1. Create FR-010 (reports) issue
2. Denormalization or materialized view setup
3. Report generation testing
4. Performance optimization for large date ranges

### Weeks 11-12: FR-007 + FR-008 Sprint
1. Create FR-007 (session tracking) issue
2. Create FR-008 (public info) issue
3. Real-time updates testing
4. Cache validation testing

---

## LABEL SUGGESTIONS
- `feature` - New feature implementation
- `bug` - Bug fix (use for exceptions found during development)
- `FR-001` through `FR-010` - FR-specific labels
- `backend` - Backend implementation
- `frontend` - Frontend implementation
- `database` - Database schema/migration
- `critical` - MVP critical path
- `payments` - Payment-related
- `performance` - Performance optimization
- `user-facing` - Visible to end users

