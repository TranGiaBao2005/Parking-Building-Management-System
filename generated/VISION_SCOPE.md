# VISION_SCOPE.md - Parking Building Management System

## PROJECT VISION

### Mission Statement
To deliver an intelligent, integrated parking building management software system that streamlines vehicle entry/exit processes, optimizes space utilization, automates revenue collection, and enhances the parking experience for facility managers, staff, and drivers in Vietnamese urban environments.

### Business Goals
1. **Operational Efficiency**: Reduce gate congestion and processing time from manual operations to sub-30-second automated entry/exit
2. **Data Integrity**: Eliminate manual data entry errors (targeting 99.9% accuracy)
3. **Capacity Optimization**: Maximize occupancy rates and reduce vehicle search time through intelligent slot allocation
4. **Revenue Assurance**: Achieve 100% revenue reconciliation with automated fee calculation and payment processing
5. **Exception Handling**: Systematically resolve edge cases (lost tickets, overdue vehicles, data discrepancies)
6. **User Experience**: Provide transparent information to drivers (availability, pricing, session tracking)

### Success Criteria
- System uptime: ≥99.5%
- Transaction processing: <2 seconds per entry/exit
- Data accuracy: 99.9% correctness in plate recognition and fee calculation
- Revenue reconciliation: 100% match between system records and actual collections
- User satisfaction: ≥4.0/5.0 for facility info and session tracking features

---

## PROJECT SCOPE (PHASE 1)

### INCLUDED - Core Functionality

#### 1. Parking Facility Management
- Multi-level parking building configuration
- Floor/section allocation by vehicle type
- Parking slot inventory and status tracking
- Real-time availability monitoring

#### 2. Vehicle & Entry/Exit Management
- Vehicle type classification (4-wheeler, 2-wheeler, etc.)
- Automated entry session creation (plate capture, vehicle type, entry time)
- Automated exit session completion (fee calculation, payment, slot release)
- Ticket/code generation for entry and exit

#### 3. Pricing & Revenue Management
- Flexible pricing policies (hourly, daily, monthly rates)
- Dynamic fee calculation based on duration, vehicle type, zone
- Payment processing integration
- Revenue reporting and reconciliation

#### 4. Session & Capacity Management
- Parking session lifecycle: entry → in-use → exit
- Occupancy rate monitoring
- Slot status transitions: vacant ↔ in-use ↔ maintenance ↔ blocked

#### 5. User Interfaces
- **Manager Dashboard**: Facility configuration, real-time monitoring, reports
- **Staff Portal**: Entry/exit processing, exception handling
- **Driver/User App**: Facility info viewing, session tracking, payment
- **Admin Console**: User account and permission management

#### 6. Reporting & Analytics (Basic)
- Entry/exit volume by hour/day
- Revenue reports
- Occupancy rate trends
- Peak hour analysis by vehicle type

#### 7. Exception Handling Framework
- Lost ticket tracking and recovery workflow
- Wrong plate number correction
- Overdue vehicle alerts
- Wrong zone/section navigation assistance
- Unpaid vehicle tracking

---

### OUT OF SCOPE - Phase 2 Features

#### 1. Advanced AI Features
- ML-based slot allocation optimization
- Predictive occupancy forecasting
- Dynamic pricing based on demand

#### 2. Mobile App Development
- Complete mobile app (iOS/Android)
- Real-time push notifications
- Mobile payment integration

#### 3. Advanced Integrations
- License plate recognition (LPR/ANPR) hardware integration
- CCTV surveillance system integration
- Traffic signal coordination

#### 4. Multi-building Federation
- Corporate account management across multiple parking buildings
- Cross-building reservation system
- Consolidated reporting

#### 5. Advanced Reservation System
- Pre-booking with time slots
- Monthly/seasonal subscriptions
- Reserved spot allocation
- Guest vehicle management

#### 6. Payment Gateway Extensions
- Multiple payment processor integrations
- Cryptocurrency payments
- Credit system with loyalty rewards

#### 7. Customer Support & Communication
- SMS/Email notifications
- Live chat support
- Complaint management system

#### 8. Integration with External Systems
- Traffic authority APIs
- Municipality registration systems
- Insurance provider integration

---

## SCOPE BOUNDARIES

### Included in Phase 1
- ✅ Single parking building management
- ✅ Real-time slot status monitoring
- ✅ Basic entry/exit workflow
- ✅ Manual exception handling
- ✅ Standard reporting (volume, revenue, occupancy)

### Excluded from Phase 1
- ❌ Multi-building operations
- ❌ AI-powered optimization
- ❌ Automated plate recognition (manual entry assumed)
- ❌ Mobile native apps (web-based assumed)
- ❌ Advanced subscription management
- ❌ External API integrations

---

## CONSTRAINTS & LIMITATIONS

### Technical Constraints
1. **Hardware**: Assumes gate entry points have basic input devices (touchscreen or barcode scanner)
2. **Connectivity**: Requires consistent internet for cloud-based backend
3. **Offline Mode**: Limited - manual ticket generation fallback only
4. **Data Storage**: Initial design for single building (<1000 parking slots)

### Business Constraints
1. **Budget**: MVP phase - minimal paid integrations
2. **Timeline**: 4-6 months for MVP deployment
3. **Staffing**: 1-2 operators per 200 parking slots
4. **Language**: Vietnamese interface for drivers and staff; English for technical documentation
5. **Currency**: Vietnamese Dong (VND) for all pricing

### Regulatory Constraints
1. **Data Privacy**: Comply with Vietnam's personal data protection standards
2. **Vehicle Identification**: Support Vietnamese plate format (standard: 2-4 digit license plate)
3. **Tax Compliance**: Integration-ready for VAT/tax reporting (integration in Phase 2)
4. **Accessibility**: Basic WCAG 2.1 Level A compliance for web interfaces

### User Constraints
1. **Manager Skill Level**: Assumes basic computer literacy
2. **Staff Training**: 4-8 hours required per operator
3. **Driver Tech Adoption**: Targets primarily smartphone-capable drivers
4. **Network Bandwidth**: Requires minimum 5 Mbps connection for API operations

---

## STAKEHOLDER ANALYSIS

### Primary Stakeholders
1. **Parking Facility Manager** - Owns facility operations, revenue targets, quality metrics
2. **Parking Staff** - Gate operators, lot attendants, exception handlers
3. **Parking Users/Drivers** - Primary external users, experience-focused
4. **System Administrator** - Maintains platform uptime and security

### Secondary Stakeholders
1. **Facility Owner** - Investment returns, competitive advantage
2. **Regulatory Authority** - Tax reporting, vehicle records
3. **Payment Provider** - Transaction security, settlement
4. **IT Support Team** - System maintenance and troubleshooting

---

## KEY ASSUMPTIONS

1. **Vehicle Plate Format**: All vehicles have legible license plates following Vietnamese standard format
2. **Unique Identification**: Plate numbers are unique identifier for parking sessions
3. **Payment Capability**: All drivers have payment methods (cash, card, digital wallet)
4. **User Registration**: Drivers can self-register or use walk-in anonymous sessions
5. **Exit Requirement**: Vehicle must complete exit process before leaving (enforced by gate)
6. **Time Accuracy**: System clock synchronized across all components (NTP)
7. **Data Availability**: No backup parking system needed during maintenance windows
8. **Staff Compliance**: Staff properly trained on exception handling procedures

---

## PHASING & ROLLOUT STRATEGY

### Phase 1: MVP (Months 1-6)
- Core entry/exit workflow
- Basic facility and slot management
- Standard reporting
- Web-based interfaces

### Phase 2: Enhanced Features (Months 7-12)
- Mobile applications
- Pre-booking system
- AI-powered slot allocation
- External API integrations

### Phase 3: Enterprise Scale (Months 13+)
- Multi-building support
- Advanced subscription management
- Corporate account management

---

## DOCUMENT REFERENCES
- Source Data: Topic.xlsx - Hệ thống quản lý tòa nhà gửi xe
- Related Files: USER_STORIES.md, TECHNICAL_TASKS.md, PRIORITY_MATRIX.md, FR_MAPPING.md
- Individual FR Files: FR-001.md through FR-010.md
