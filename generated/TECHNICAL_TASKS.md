# TECHNICAL_TASKS.md - Parking Building Management System

## Task Decomposition Structure

Each major functional requirement is decomposed into:
- **Database Tasks** (D-XXX) - Schema, migrations, indexing
- **Backend Tasks** (B-XXX) - API endpoints, business logic, services
- **Frontend Tasks** (F-XXX) - UI components, pages, state management
- **Exception Handling Tasks** (E-XXX) - Error scenarios, recovery workflows

---

## FR-001: MANAGE PARKING FACILITY INFORMATION

### Database Tasks
- [ ] **D-001.1** Create `facilities` table (id, name, location, address, city, postal_code, phone, email, operating_hours_json, max_capacity, created_at, updated_at)
- [ ] **D-001.2** Create `facility_amenities` table (id, facility_id, amenity_type, is_available)
- [ ] **D-001.3** Create indices on facility_id, city for fast queries
- [ ] **D-001.4** Define JSON schema for operating_hours (structured format for multi-day hours)

### Backend Tasks
- [ ] **B-001.1** Implement `POST /api/v1/facilities` endpoint (create facility)
- [ ] **B-001.2** Implement `GET /api/v1/facilities/:id` endpoint (retrieve facility details)
- [ ] **B-001.3** Implement `PUT /api/v1/facilities/:id` endpoint (update facility info)
- [ ] **B-001.4** Implement `GET /api/v1/facilities` endpoint (list facilities for admin)
- [ ] **B-001.5** Create FacilityService with CRUD operations
- [ ] **B-001.6** Add validation: facility name not empty, valid phone/email format
- [ ] **B-001.7** Implement operating_hours parsing and validation
- [ ] **B-001.8** Add authorization check: only Admin and assigned Manager roles

### Frontend Tasks
- [ ] **F-001.1** Create FacilityDetailsPage component (display facility information)
- [ ] **F-001.2** Create FacilityEditForm component (form to update facility details)
- [ ] **F-001.3** Create OperatingHoursEditor subcomponent (configure hours per day)
- [ ] **F-001.4** Implement form validation (required fields, email/phone format)
- [ ] **F-001.5** Add loading and error states
- [ ] **F-001.6** Create SuccessNotification component for save confirmations

### Exception Handling Tasks
- [ ] **E-001.1** Handle 400: Invalid facility data (missing required fields)
- [ ] **E-001.2** Handle 403: Unauthorized access (non-admin/non-manager access)
- [ ] **E-001.3** Handle 404: Facility not found
- [ ] **E-001.4** Handle 409: Facility name conflict (uniqueness constraint)
- [ ] **E-001.5** Handle validation: invalid operating hours format
- [ ] **E-001.6** Implement retry logic for transient DB errors

---

## FR-002: MANAGE VEHICLE TYPES AND FLOOR/SECTION ALLOCATION

### Database Tasks
- [ ] **D-002.1** Create `vehicle_types` table (id, facility_id, type_name, size_category, height_limit_cm, width_limit_cm, length_limit_cm, base_rate_per_hour, active, created_at)
- [ ] **D-002.2** Create `facility_sections` table (id, facility_id, section_name, floor_number, section_code, vehicle_type_id, total_slots, created_at)
- [ ] **D-002.3** Add foreign keys: vehicle_types.facility_id → facilities.id; facility_sections.vehicle_type_id → vehicle_types.id
- [ ] **D-002.4** Create unique index on (facility_id, type_name) for vehicle types
- [ ] **D-002.5** Create unique index on (facility_id, section_code) for sections

### Backend Tasks
- [ ] **B-002.1** Implement `POST /api/v1/facilities/:id/vehicle-types` (create vehicle type)
- [ ] **B-002.2** Implement `GET /api/v1/facilities/:id/vehicle-types` (list vehicle types)
- [ ] **B-002.3** Implement `PUT /api/v1/vehicle-types/:typeId` (update vehicle type)
- [ ] **B-002.4** Implement `DELETE /api/v1/vehicle-types/:typeId` (soft delete vehicle type)
- [ ] **B-002.5** Implement `POST /api/v1/facilities/:id/sections` (create floor/section)
- [ ] **B-002.6** Implement `GET /api/v1/facilities/:id/sections` (list sections with allocation)
- [ ] **B-002.7** Implement `PUT /api/v1/sections/:sectionId` (update section allocation)
- [ ] **B-002.8** Create VehicleTypeService and SectionAllocationService
- [ ] **B-002.9** Add validation: section must have valid floor number, vehicle type must exist
- [ ] **B-002.10** Implement allocation logic: ensure sections don't exceed facility capacity

### Frontend Tasks
- [ ] **F-002.1** Create VehicleTypeManagementPage (CRUD for vehicle types)
- [ ] **F-002.2** Create VehicleTypeForm component (add/edit vehicle type with size specifications)
- [ ] **F-002.3** Create SectionAllocationPage (visualize floor/section layout)
- [ ] **F-002.4** Create AllocationMatrix component (drag-drop or table to assign vehicle types to sections)
- [ ] **F-002.5** Implement capacity validation warning in UI
- [ ] **F-002.6** Create section visualization (floor map with section boundaries)

### Exception Handling Tasks
- [ ] **E-002.1** Handle duplicate vehicle type names per facility
- [ ] **E-002.2** Handle deletion of vehicle type with active sessions (soft delete only)
- [ ] **E-002.3** Handle over-allocation (section total slots exceeding facility capacity)
- [ ] **E-002.4** Handle invalid floor numbers (negative, non-sequential)
- [ ] **E-002.5** Validate dimension constraints (height < width < length logically)

---

## FR-003: MANAGE PARKING SLOTS AND THEIR STATUS

### Database Tasks
- [ ] **D-003.1** Create `parking_slots` table (id, facility_id, section_id, slot_code, floor_number, status, is_handicap_accessible, last_maintenance_at, notes, created_at, updated_at)
- [ ] **D-003.2** Status enum: VACANT, IN_USE, PRE_BOOKED, MAINTENANCE, BLOCKED
- [ ] **D-003.3** Create indices on (facility_id, status) and (section_id, status) for filtering
- [ ] **D-003.4** Create unique index on (facility_id, slot_code)

### Backend Tasks
- [ ] **B-003.1** Implement `POST /api/v1/sections/:id/slots` (bulk create slots for section)
- [ ] **B-003.2** Implement `GET /api/v1/facilities/:id/slots` (list all slots with filter by status)
- [ ] **B-003.3** Implement `GET /api/v1/sections/:id/slots` (list slots in section)
- [ ] **B-003.4** Implement `PATCH /api/v1/slots/:slotId/status` (update slot status)
- [ ] **B-003.5** Implement `GET /api/v1/facilities/:id/availability` (get availability summary)
- [ ] **B-003.6** Create SlotManagementService with status transition logic
- [ ] **B-003.7** Implement slot reservation logic (transactional)
- [ ] **B-003.8** Add validation: slot code format, status transitions (VACANT→IN_USE→VACANT, etc.)
- [ ] **B-003.9** Implement availability query optimization (materialized view or caching)

### Frontend Tasks
- [ ] **F-003.1** Create SlotManagementPage (view all slots with status filter)
- [ ] **F-003.2** Create SlotVisualizer component (floor map showing slot status with color coding)
- [ ] **F-003.3** Create BulkSlotCreationForm (template-based slot generation by section)
- [ ] **F-003.4** Create SlotStatusBadge component (visual indicator: vacant=green, in-use=red, etc.)
- [ ] **F-003.5** Implement real-time updates (WebSocket or polling for occupancy changes)
- [ ] **F-003.6** Create MaintenanceMarking UI (quick mark/unmark slots for maintenance)

### Exception Handling Tasks
- [ ] **E-003.1** Handle concurrent slot reservation (race condition prevention)
- [ ] **E-003.2** Handle invalid status transitions (e.g., IN_USE → PRE_BOOKED not allowed)
- [ ] **E-003.3** Handle slot code conflicts (uniqueness violation)
- [ ] **E-003.4** Handle bulk slot creation failure (partial rollback on error)
- [ ] **E-003.5** Handle stale data (optimistic locking on slot status updates)

---

## FR-004: MANAGE PRICING AND FEE POLICIES

### Database Tasks
- [ ] **D-004.1** Create `pricing_policies` table (id, facility_id, policy_name, vehicle_type_id, time_period, rate_per_hour, daily_rate, monthly_rate, grace_period_minutes, active, created_at, updated_at)
- [ ] **D-004.2** Create `fee_surcharges` table (id, facility_id, surcharge_type, amount, description, active, created_at)
- [ ] **D-004.3** Time_period enum: PEAK, OFF_PEAK, WEEKEND, WEEKDAY
- [ ] **D-004.4** Create indices on (facility_id, vehicle_type_id) for quick lookup

### Backend Tasks
- [ ] **B-004.1** Implement `POST /api/v1/facilities/:id/pricing-policies` (create pricing rule)
- [ ] **B-004.2** Implement `GET /api/v1/facilities/:id/pricing-policies` (list pricing policies)
- [ ] **B-004.3** Implement `PUT /api/v1/pricing-policies/:policyId` (update pricing)
- [ ] **B-004.4** Implement `DELETE /api/v1/pricing-policies/:policyId` (deactivate pricing)
- [ ] **B-004.5** Implement `POST /api/v1/facilities/:id/surcharges` (add surcharge types)
- [ ] **B-004.6** Create FeeCalculationService with complex logic
- [ ] **B-004.7** Implement fee calculation: hourly with grace period, rounding rules
- [ ] **B-004.8** Implement peak/off-peak time detection (configurable time windows)
- [ ] **B-004.9** Add validation: rates must be positive, grace period sensible

### Frontend Tasks
- [ ] **F-004.1** Create PricingPolicyPage (manage pricing rules by vehicle type)
- [ ] **F-004.2** Create PricingPolicyForm (add/edit pricing with time period selection)
- [ ] **F-004.3** Create SurchargeManagementForm (manage additional fees)
- [ ] **F-004.4** Create PricingPreviewCard (show sample calculations for different durations)
- [ ] **F-004.5** Implement pricing simulation tool (driver input duration, get estimate)

### Exception Handling Tasks
- [ ] **E-004.1** Handle pricing policy conflicts (overlapping vehicle type and time period)
- [ ] **E-004.2** Handle rounding precision (ensure consistency in fee calculation)
- [ ] **E-004.3** Handle missing pricing for vehicle type (fallback default rate)
- [ ] **E-004.4** Handle date/time parsing for peak hours definition

---

## FR-005: VEHICLE ENTRY AND PARKING SESSION CREATION

### Database Tasks
- [ ] **D-005.1** Create `parking_sessions` table (id, facility_id, vehicle_plate, vehicle_type_id, section_id, slot_id, entry_time, entry_gate, staff_id, ticket_code, session_status, created_at)
- [ ] **D-005.2** Session_status enum: ACTIVE, EXITED, LOST_TICKET, EXCEPTION
- [ ] **D-005.3** Create indices on (facility_id, entry_time), (vehicle_plate), (ticket_code) for quick lookups
- [ ] **D-005.4** Create unique index on ticket_code (generate UUID or sequence-based code)

### Backend Tasks
- [ ] **B-005.1** Implement `POST /api/v1/sessions` (create parking session on vehicle entry)
- [ ] **B-005.2** Implement `GET /api/v1/sessions/:sessionId` (retrieve session details)
- [ ] **B-005.3** Implement `GET /api/v1/sessions/ticket/:ticketCode` (lookup session by ticket)
- [ ] **B-005.4** Create SessionCreationService with entry validation
- [ ] **B-005.5** Implement slot allocation logic: find available slot in vehicle-type section
- [ ] **B-005.6** Generate unique ticket code (format: FACILITY-DATETIME-RANDOM or sequence)
- [ ] **B-005.7** Validate: vehicle plate format (Vietnamese standard), vehicle type exists
- [ ] **B-005.8** Add authorization: only Staff or Manager roles can create entry
- [ ] **B-005.9** Implement transaction to ensure atomicity (slot reservation + session creation)
- [ ] **B-005.10** Log entry event with timestamp, staff ID, gate ID

### Frontend Tasks
- [ ] **F-005.1** Create VehicleEntryPage (staff interface for entry processing)
- [ ] **F-005.2** Create PlateInputForm (barcode scanner or manual plate entry)
- [ ] **F-005.3** Create VehicleTypeSelector (dropdown with vehicle types)
- [ ] **F-005.4** Create EntryConfirmationModal (show allocated zone, slot, ticket code)
- [ ] **F-005.5** Implement barcode scanner integration (USB scanner support)
- [ ] **F-005.6** Create PrintTicketButton (print or display ticket for driver)

### Exception Handling Tasks
- [ ] **E-005.1** Handle no available slots (direct driver to wait list or another facility)
- [ ] **E-005.2** Handle invalid plate format (reject, ask for reentry)
- [ ] **E-005.3** Handle vehicle type selection mismatch (confirm with driver)
- [ ] **E-005.4** Handle concurrent entry requests (ensure slot not double-booked)
- [ ] **E-005.5** Handle scanner timeout or malfunction (fallback to manual entry)
- [ ] **E-005.6** Handle session creation failure (log and retry logic)

---

## FR-006: VEHICLE EXIT AND FEE COLLECTION

### Database Tasks
- [ ] **D-006.1** Create `payment_records` table (id, session_id, amount, payment_method, payment_status, receipt_code, processed_at, created_at)
- [ ] **D-006.2** Create `session_fees` table (id, session_id, base_fee, surcharge_amount, total_fee, fee_breakdown_json, calculated_at)
- [ ] **D-006.3** Payment_method enum: CASH, CARD, DIGITAL_WALLET, PREPAID
- [ ] **D-006.4** Payment_status enum: PENDING, COMPLETED, FAILED, REFUNDED
- [ ] **D-006.5** Create indices on (session_id), (payment_status), (processed_at)

### Backend Tasks
- [ ] **B-006.1** Implement `POST /api/v1/sessions/:sessionId/calculate-fee` (calculate exit fee)
- [ ] **B-006.2** Implement `POST /api/v1/sessions/:sessionId/exit` (process vehicle exit)
- [ ] **B-006.3** Implement `POST /api/v1/payments` (record payment transaction)
- [ ] **B-006.4** Create ExitProcessingService with fee calculation
- [ ] **B-006.5** Implement fee calculation: duration × hourly_rate + surcharges
- [ ] **B-006.6** Generate receipt code and store payment record
- [ ] **B-006.7** Update parking session status to EXITED
- [ ] **B-006.8** Update slot status from IN_USE back to VACANT
- [ ] **B-006.9** Add authorization: Staff or Manager can process exit
- [ ] **B-006.10** Implement transaction: payment + session closure + slot release
- [ ] **B-006.11** Log exit event with all fee details for audit trail

### Frontend Tasks
- [ ] **F-006.1** Create VehicleExitPage (staff interface for exit processing)
- [ ] **F-006.2** Create TicketLookupForm (search by ticket code or plate number)
- [ ] **F-006.3** Create FeeDetailsCard (display entry time, duration, calculated fee breakdown)
- [ ] **F-006.4** Create PaymentMethodSelector (cash, card, digital wallet options)
- [ ] **F-006.5** Create PaymentProcessingForm (amount input, card reader integration)
- [ ] **F-006.6** Create ReceiptDisplay (show receipt with transaction details, print option)

### Exception Handling Tasks
- [ ] **E-006.1** Handle session not found by ticket (lost ticket scenario - see FR-007)
- [ ] **E-006.2** Handle payment failure (card declined, insufficient balance)
- [ ] **E-006.3** Handle overdue charges (apply surcharge for exceeding duration limit)
- [ ] **E-006.4** Handle partial payment (allow staff to manually adjust or split payment)
- [ ] **E-006.5** Handle receipt printer failure (store digital receipt, email to driver if contact available)
- [ ] **E-006.6** Ensure idempotency: duplicate exit requests should not double-charge

---

## FR-007: PARKING SESSION TRACKING AND FEE CALCULATION

### Database Tasks
- [ ] **D-007.1** Create `session_tracking_events` table (id, session_id, event_type, event_timestamp, details_json, created_at)
- [ ] **D-007.2** Event_type enum: ENTRY_CREATED, LOCATION_ASSIGNED, EXIT_INITIATED, PAYMENT_PROCESSED, RESOLVED
- [ ] **D-007.3** Create index on (session_id, event_timestamp)
- [ ] **D-007.4** Create materialized view for session summary (for driver lookup)

### Backend Tasks
- [ ] **B-007.1** Implement `GET /api/v1/drivers/sessions/:plateNumber` (retrieve current/past sessions)
- [ ] **B-007.2** Implement `GET /api/v1/drivers/sessions/:sessionId` (retrieve session tracking details)
- [ ] **B-007.3** Implement `GET /api/v1/drivers/sessions/:sessionId/fee-estimate` (calculate live fee estimate)
- [ ] **B-007.4** Create SessionTrackingService with event logging
- [ ] **B-007.5** Implement fee estimation formula (current_duration × rate + estimated_surcharges)
- [ ] **B-007.6** Log all session state changes (entry, zone assignment, exit initiated, payment)
- [ ] **B-007.7** Implement session history query (past parking sessions by driver)
- [ ] **B-007.8** Add authorization: drivers see only their sessions, managers see all

### Frontend Tasks
- [ ] **F-007.1** Create SessionTrackingPage (driver view of current session)
- [ ] **F-007.2** Create SessionDetailsCard (entry time, zone, slot, live duration counter)
- [ ] **F-007.3** Create LiveFeeEstimateWidget (real-time fee calculation as time passes)
- [ ] **F-007.4** Create SessionHistoryPage (view past parking sessions with fee details)
- [ ] **F-007.5** Create SessionEventTimeline (visual timeline of entry, zone assignment, exit)
- [ ] **F-007.6** Implement auto-refresh (WebSocket or polling every 30 seconds for live fee update)

### Exception Handling Tasks
- [ ] **E-007.1** Handle missing tracking events (reconstruct from timestamps)
- [ ] **E-007.2** Handle fee calculation discrepancies (flag for manager review)
- [ ] **E-007.3** Handle long-running sessions (alert driver of approaching overdue if applicable)
- [ ] **E-007.4** Handle session query timeouts (implement pagination for large result sets)

---

## FR-008: VIEW PARKING FACILITY INFORMATION (USER)

### Database Tasks
- [ ] **D-008.1** Create `facility_info_cache` table (id, facility_id, availability_json, last_updated, created_at) for denormalization
- [ ] **D-008.2** Create index on facility_id for cache lookup

### Backend Tasks
- [ ] **B-008.1** Implement `GET /api/v1/public/facilities/:id/info` (public endpoint for facility info)
- [ ] **B-008.2** Implement `GET /api/v1/public/facilities/:id/availability` (current occupancy, vacant slots)
- [ ] **B-008.3** Implement `GET /api/v1/public/facilities/:id/pricing` (current pricing for all vehicle types)
- [ ] **B-008.4** Create PublicFacilityService (no auth required for read-only info)
- [ ] **B-008.5** Implement caching: update cache on each entry/exit or every 5 minutes
- [ ] **B-008.6** Ensure performance: queries respond in <500ms (use cache aggressively)

### Frontend Tasks
- [ ] **F-008.1** Create FacilityInfoPage (public view of facility details for drivers)
- [ ] **F-008.2** Create FacilityDetailsCard (name, location, phone, operating hours)
- [ ] **F-008.3** Create AvailabilityDisplay (vacant slots by vehicle type, occupancy percentage)
- [ ] **F-008.4** Create PricingTable (show rates by vehicle type and time period)
- [ ] **F-008.5** Create AmenitiesDisplay (show available amenities: parking, EV charging, etc.)
- [ ] **F-008.6** Create CapacityGaugeChart (visual representation of occupancy)

### Exception Handling Tasks
- [ ] **E-008.1** Handle stale cache (invalidate cache on entry/exit)
- [ ] **E-008.2** Handle facility not found (404 with friendly message)
- [ ] **E-008.3** Handle cache retrieval failure (fallback to live query)

---

## FR-009: PRE-BOOKING PARKING SPACES

### Database Tasks
- [ ] **D-009.1** Create `reservations` table (id, facility_id, vehicle_type_id, driver_contact, reservation_date, start_time, end_time, reservation_code, status, created_at, updated_at)
- [ ] **D-009.2** Status enum: PENDING, CONFIRMED, ACTIVE, COMPLETED, CANCELLED
- [ ] **D-009.3** Create indices on (facility_id, reservation_date, status), (reservation_code)

### Backend Tasks
- [ ] **B-009.1** Implement `POST /api/v1/reservations` (create parking pre-booking)
- [ ] **B-009.2** Implement `GET /api/v1/reservations/:reservationId` (retrieve reservation)
- [ ] **B-009.3** Implement `PUT /api/v1/reservations/:reservationId` (modify reservation)
- [ ] **B-009.4** Implement `DELETE /api/v1/reservations/:reservationId` (cancel reservation)
- [ ] **B-009.5** Create ReservationService with availability checking
- [ ] **B-009.6** Implement capacity check: ensure enough slots for peak period
- [ ] **B-009.7** Generate unique reservation code
- [ ] **B-009.8** Implement reservation validation: date in future, duration reasonable
- [ ] **B-009.9** Send confirmation (SMS/Email if contact provided)
- [ ] **B-009.10** Implement auto-release of unused reservations (configurable grace period)

### Frontend Tasks
- [ ] **F-009.1** Create ReservationPage (driver interface for pre-booking)
- [ ] **F-009.2** Create ReservationForm (date/time picker, vehicle type selector, contact input)
- [ ] **F-009.3** Create AvailabilityChecker (show available slots for selected date/time)
- [ ] **F-009.4** Create ReservationConfirmationModal (show reservation code, instructions)
- [ ] **F-009.5** Create ReservationHistoryPage (view past and upcoming reservations)

### Exception Handling Tasks
- [ ] **E-009.1** Handle no availability for requested date/time (suggest alternatives)
- [ ] **E-009.2** Handle overbooking (prevent double-booking of same slot)
- [ ] **E-009.3** Handle reservation expiry (auto-cancel if not activated at entry)
- [ ] **E-009.4** Handle invalid contact information (require valid phone/email format)
- [ ] **E-009.5** Handle duplicate reservation (same driver, same time) - prevent

---

## FR-010: REPORTS AND ANALYTICS

### Database Tasks
- [ ] **D-010.1** Create `analytics_aggregates` table (id, facility_id, date, hour, metric_type, metric_value, created_at) for denormalization
- [ ] **D-010.2** Metric_type enum: ENTRY_COUNT, EXIT_COUNT, OCCUPANCY_RATE, REVENUE, AVG_DURATION
- [ ] **D-010.3** Create indices on (facility_id, date, metric_type)
- [ ] **D-010.4** Implement nightly aggregation job to pre-calculate metrics

### Backend Tasks
- [ ] **B-010.1** Implement `GET /api/v1/reports/entry-exit-volume` (volume by hour/day with filters)
- [ ] **B-010.2** Implement `GET /api/v1/reports/revenue` (revenue by period, vehicle type, payment method)
- [ ] **B-010.3** Implement `GET /api/v1/reports/occupancy` (occupancy trends by floor, vehicle type)
- [ ] **B-010.4** Implement `GET /api/v1/reports/peak-hours` (identify peak hours by vehicle type)
- [ ] **B-010.5** Implement `GET /api/v1/reports/exceptions` (exceptions by type: lost ticket, overdue, etc.)
- [ ] **B-010.6** Create AnalyticsService with aggregation logic
- [ ] **B-010.7** Implement date range filtering and grouping (daily, weekly, monthly)
- [ ] **B-010.8** Add authorization: only Manager and Admin can access reports
- [ ] **B-010.9** Implement caching for pre-calculated metrics
- [ ] **B-010.10** Implement data export (CSV, PDF formats)

### Frontend Tasks
- [ ] **F-010.1** Create ReportsPage (manager dashboard with multiple report tabs)
- [ ] **F-010.2** Create DateRangeSelector (pick start/end date, filtering options)
- [ ] **F-010.3** Create EntryExitVolumeChart (bar/line chart of hourly/daily volume)
- [ ] **F-010.4** Create RevenueChart (revenue trend, breakdown by vehicle type)
- [ ] **F-010.5** Create OccupancyHeatmap (occupancy by hour and day)
- [ ] **F-010.6** Create PeakHoursAnalysis (identify and display peak hours)
- [ ] **F-010.7** Create ExceptionsSummary (count and breakdown of exceptions)
- [ ] **F-010.8** Create ExportButton (download report as CSV/PDF)

### Exception Handling Tasks
- [ ] **E-010.1** Handle large date ranges (pagination, data sampling for performance)
- [ ] **E-010.2** Handle missing aggregation data (recalculate on-demand)
- [ ] **E-010.3** Handle timezone issues (ensure consistent time-zone handling in aggregation)
- [ ] **E-010.4** Handle export failure (retry with different format or email as attachment)

---

## SUMMARY CHECKLIST

### High-Priority Tasks (Must Complete)
- [ ] All Database Tasks (D-XXX)
- [ ] Core Backend Tasks (B-XXX.1 through B-XXX.6 for each FR)
- [ ] Core Frontend Tasks (F-XXX.1 through F-XXX.5 for each FR)
- [ ] Critical Exception Handling (E-XXX.1 through E-XXX.3 for each FR)

### Medium-Priority Tasks (Should Complete)
- [ ] Advanced Backend Tasks (validation, authorization, transactions)
- [ ] Advanced Frontend Tasks (real-time updates, visualization)
- [ ] Extended Exception Handling

### Low-Priority Tasks (Nice-to-Have)
- [ ] Performance optimization tasks
- [ ] Advanced analytics tasks
- [ ] Export/reporting enhancements

---

## DEPENDENCIES MATRIX

| Task | Depends On | Reason |
|---|---|---|
| B-002.x | D-002.x | Schema must exist before API implementation |
| F-002.x | B-002.x | API contract needed before UI implementation |
| E-002.x | B-002.x | Exception handling implemented alongside API |
| B-005.x | B-003.x, B-004.x | Slot availability and pricing required |
| B-006.x | B-005.x | Session must exist before exit |
| B-010.x | All B-XXX tasks | Analytics depend on all data being captured |

