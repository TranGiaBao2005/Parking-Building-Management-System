# PRIORITY_MATRIX.md - Parking Building Management System

## Priority Calculation Methodology

**Formula**: Priority = (Business Value + 2×Relative Cost + Relative Risk) / 4

Where:
- **Business Value**: How critical to core business operations (1-9 scale)
- **Relative Cost**: Implementation complexity and effort (1-9 scale)
- **Relative Risk**: Technical risk, dependency risk, testing complexity (1-9 scale)

**Priority Classification**:
- **HIGH**: Score ≥ 7.0 (Critical path, must implement in Phase 1)
- **MEDIUM**: Score 5.0-6.9 (Important but not blocking, Phase 1-2)
- **LOW**: Score < 5.0 (Nice-to-have, Phase 2-3)

---

## DETAILED SCORING MATRIX

### FR-001: Manage Parking Facility Information

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 9 | Foundation for all operations; must exist before any other features |
| **Relative Cost** | 3 | Simple CRUD operations, straightforward data model |
| **Relative Risk** | 2 | Low technical risk; no complex integrations |
| **PRIORITY SCORE** | (9 + 2×3 + 2) / 4 = 17/4 = **8.25** | **HIGH** |

**Status**: MVP Critical - Required from day 1  
**Effort Estimate**: 40-60 hours (1-1.5 sprints)  
**Dependencies**: None

---

### FR-002: Manage Vehicle Types and Floor/Section Allocation

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 8 | Critical for capacity management and pricing differentiation |
| **Relative Cost** | 4 | Moderate schema complexity; allocation logic requires planning |
| **Relative Risk** | 3 | Low risk; allocation conflicts solvable with validation |
| **PRIORITY SCORE** | (8 + 2×4 + 3) / 4 = 23/4 = **5.75** | **MEDIUM** |

**Status**: MVP Critical - Should implement early  
**Effort Estimate**: 60-80 hours (1.5-2 sprints)  
**Dependencies**: FR-001 (facility must exist)

**Note**: Can use default single vehicle type initially; upgrade to multi-type in Phase 1b

---

### FR-003: Manage Parking Slots and Their Status

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 9 | Core to capacity tracking; essential for occupancy management |
| **Relative Cost** | 5 | Large potential number of records; requires efficient indexing |
| **Relative Risk** | 4 | Race condition risk on concurrent slot reservations; requires transaction management |
| **PRIORITY SCORE** | (9 + 2×5 + 4) / 4 = 27/4 = **6.75** | **MEDIUM-HIGH** |

**Status**: MVP Critical - Must implement early  
**Effort Estimate**: 80-100 hours (2-2.5 sprints)  
**Dependencies**: FR-001, FR-002

**Technical Notes**: 
- Requires pessimistic or optimistic locking
- Consider materialized view for availability queries
- Implement caching for performance

---

### FR-004: Manage Pricing and Fee Policies

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 9 | Revenue generation core feature; incorrect pricing = revenue loss |
| **Relative Cost** | 5 | Fee calculation logic has many edge cases (rounding, peak hours, surcharges) |
| **Relative Risk** | 5 | High financial impact if calculations incorrect; requires rigorous testing |
| **PRIORITY SCORE** | (9 + 2×5 + 5) / 4 = 28/4 = **7.0** | **HIGH** |

**Status**: MVP Critical - Must implement carefully  
**Effort Estimate**: 70-90 hours (1.75-2.25 sprints)  
**Dependencies**: FR-001

**Technical Notes**:
- Implement fee calculation service with comprehensive unit tests
- Use fixed-point arithmetic (not floating-point) for currency
- Document all rounding rules explicitly

---

### FR-005: Vehicle Entry and Parking Session Creation

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 9 | Direct revenue impact; every vehicle entry must be captured |
| **Relative Cost** | 6 | Requires barcode scanner integration; moderate complexity |
| **Relative Risk** | 6 | Many concurrent entry points; potential race conditions; plate recognition errors |
| **PRIORITY SCORE** | (9 + 2×6 + 6) / 4 = 27/4 = **6.75** | **MEDIUM-HIGH** |

**Status**: MVP Critical - Core workflow  
**Effort Estimate**: 100-130 hours (2.5-3.25 sprints)  
**Dependencies**: FR-001, FR-002, FR-003, FR-004

**Technical Notes**:
- Barcode scanner integration can start with USB HID emulation
- Implement fallback manual entry
- Use transaction to ensure slot + session atomicity
- Consider queue-based processing for high-concurrency scenarios

---

### FR-006: Vehicle Exit and Fee Collection

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 9 | Direct revenue impact; fee collection critical to business model |
| **Relative Cost** | 7 | Payment processing complexity; multiple payment methods; receipt handling |
| **Relative Risk** | 7 | Payment failures, fraud risk, reconciliation complexity; regulatory compliance |
| **PRIORITY SCORE** | (9 + 2×7 + 7) / 4 = 30/4 = **7.5** | **HIGH** |

**Status**: MVP Critical - Revenue critical path  
**Effort Estimate**: 120-160 hours (3-4 sprints)  
**Dependencies**: FR-005, FR-004

**Technical Notes**:
- Payment provider integration (Phase 1: cash + manual card; Phase 2: automated gateways)
- Implement comprehensive payment error handling
- Ensure idempotency (duplicate exit requests must not double-charge)
- Detailed audit trail for compliance

---

### FR-007: Parking Session Tracking and Fee Calculation

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 8 | Driver visibility improves experience; required for dispute resolution |
| **Relative Cost** | 3 | Query-based feature; no complex logic |
| **Relative Risk** | 3 | Data already captured by FR-005/006; low risk |
| **PRIORITY SCORE** | (8 + 2×3 + 3) / 4 = 17/4 = **4.25** | **LOW-MEDIUM** |

**Status**: MVP - Lower priority than entry/exit  
**Effort Estimate**: 40-60 hours (1-1.5 sprints)  
**Dependencies**: FR-005

**Technical Notes**:
- Can implement as read-only queries after entry/exit are solid
- Real-time fee estimation can use caching
- Separate from entry/exit workflows

---

### FR-008: View Parking Facility Information (User)

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 7 | Improves driver experience; reduces support inquiries; marketing benefit |
| **Relative Cost** | 2 | Primarily aggregation of existing data; denormalization sufficient |
| **Relative Risk** | 2 | No write operations; data already validated elsewhere |
| **PRIORITY SCORE** | (7 + 2×2 + 2) / 4 = 13/4 = **3.25** | **LOW** |

**Status**: Phase 1b - After core entry/exit  
**Effort Estimate**: 30-40 hours (0.75-1 sprint)  
**Dependencies**: FR-001, FR-002, FR-003

**Technical Notes**:
- Use cache aggressively (5-minute refresh interval acceptable)
- Public API endpoint (no authentication)
- Can be implemented as skin over existing manager dashboards

---

### FR-009: Pre-booking Parking Spaces

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 6 | Nice-to-have for premium service; not critical to MVP |
| **Relative Cost** | 6 | Availability checking complex; reservation management moderate |
| **Relative Risk** | 4 | Business logic somewhat complex; overbooking risk manageable |
| **PRIORITY SCORE** | (6 + 2×6 + 4) / 4 = 22/4 = **5.5** | **MEDIUM** |

**Status**: Phase 1b/Phase 2 - Post-MVP  
**Effort Estimate**: 70-90 hours (1.75-2.25 sprints)  
**Dependencies**: FR-001, FR-002, FR-003

**Technical Notes**:
- Can overlap with core development but lower priority
- Reservation auto-expiry logic can reduce manual exceptions
- Consider slot pre-allocation vs. capacity reservation approaches

---

### FR-010: Reports and Analytics

| Factor | Score | Reasoning |
|--------|-------|-----------|
| **Business Value** | 8 | Critical for business intelligence; required for revenue reconciliation |
| **Relative Cost** | 4 | Data aggregation moderate; queries can leverage existing tables |
| **Relative Risk** | 3 | No live system impact; can iterate on reports without affecting operations |
| **PRIORITY SCORE** | (8 + 2×4 + 3) / 4 = 19/4 = **4.75** | **MEDIUM** |

**Status**: Phase 1b - Implement after core workflows  
**Effort Estimate**: 60-80 hours (1.5-2 sprints)  
**Dependencies**: FR-005, FR-006

**Technical Notes**:
- Basic reports can go live quickly; advanced analytics in Phase 2
- Implement nightly aggregation job for performance
- CSV export sufficient for MVP; PDF/advanced formats in Phase 2

---

## PRIORITY RANKING SUMMARY

### Phase 1 (MVP) - Immediate Implementation
| Rank | FR | Name | Score | Status |
|------|----|----|-------|--------|
| 1 | FR-001 | Manage Parking Facility Information | 8.25 | **CRITICAL** |
| 2 | FR-004 | Manage Pricing and Fee Policies | 7.0 | **CRITICAL** |
| 3 | FR-006 | Vehicle Exit and Fee Collection | 7.5 | **CRITICAL** |
| 4 | FR-005 | Vehicle Entry and Parking Session | 6.75 | **CRITICAL** |
| 5 | FR-003 | Manage Parking Slots and Status | 6.75 | **CRITICAL** |

**Subtotal Effort**: 350-450 hours (8-11 sprints)  
**Target Timeline**: 4-6 months

---

### Phase 1b (Post-MVP) - Early Enhancement
| Rank | FR | Name | Score | Status |
|------|----|----|-------|--------|
| 6 | FR-002 | Manage Vehicle Types | 5.75 | **HIGH-MEDIUM** |
| 7 | FR-010 | Reports and Analytics | 4.75 | **MEDIUM** |
| 8 | FR-009 | Pre-booking Parking | 5.5 | **MEDIUM** |

**Subtotal Effort**: 190-250 hours (5-6 sprints)  
**Target Timeline**: 1-2 months post-MVP

---

### Phase 2 (Enhancement) - Secondary Features
| Rank | FR | Name | Score | Status |
|------|----|----|-------|--------|
| 9 | FR-007 | Session Tracking | 4.25 | **LOW-MEDIUM** |
| 10 | FR-008 | View Facility Info | 3.25 | **LOW** |

**Subtotal Effort**: 70-100 hours (1.75-2.5 sprints)  
**Target Timeline**: 2-4 months post-Phase-1b

---

## PRIORITIZATION RATIONALE

### Why FR-001, FR-004, FR-006 are CRITICAL (High Score)
- **FR-001**: Foundation - all other features depend on facility configuration
- **FR-004**: Revenue critical - incorrect pricing = revenue loss
- **FR-006**: Revenue critical - fee collection is business core

### Why FR-005 and FR-003 are CRITICAL (Medium-High Score)
- **FR-005**: Every vehicle entry must be captured; core workflow
- **FR-003**: Capacity management essential; prevents overselling

### Why FR-002 is MEDIUM (Post-MVP)
- Single vehicle type (cars) can work for MVP
- Multi-type upgrade can wait 1-2 sprints after core stability
- Doesn't block core entry/exit workflow

### Why FR-010 is MEDIUM (Post-MVP)
- Basic reports can be manual initially
- System performs core functions without reporting
- Important for management but not for day-to-day operations

### Why FR-009 is MEDIUM (Post-MVP)
- Nice-to-have premium feature
- Core parking works without pre-booking
- Can add after system stability proven

### Why FR-007 and FR-008 are LOW (Phase 2)
- **FR-007**: Informational feature; no blocking impact
- **FR-008**: Public info; can be simple HTML initially
- Lower business value; non-critical for MVP viability

---

## EFFORT ESTIMATION BREAKDOWN

### Phase 1 (MVP) - 350-450 hours

**Backend (150-180 hours)**
- Database schema design and migration: 40-50 hours
- Core APIs (entry, exit, fee calculation): 80-100 hours
- Business logic services: 30-40 hours

**Frontend (120-150 hours)**
- Manager dashboard (facility, slots, pricing config): 50-60 hours
- Staff portal (entry/exit processing): 40-50 hours
- Error handling and validation: 30-40 hours

**DevOps/Infrastructure (40-60 hours)**
- Database setup and optimization: 20-30 hours
- API deployment and monitoring: 15-20 hours
- Basic security hardening: 10-20 hours

**Testing (40-60 hours)**
- Unit tests (core business logic): 20-30 hours
- Integration tests: 15-20 hours
- Manual UAT and bug fixes: 10-15 hours

---

## RISK MITIGATION

### High-Risk Items Requiring Attention
1. **FR-005 & FR-006 - Concurrent Access**: Use database-level locking or application-level queue
2. **FR-004 - Fee Calculation Accuracy**: Comprehensive test suite; use fixed-point math
3. **FR-006 - Payment Failures**: Robust error handling; manual override capability
4. **FR-003 - Scalability**: Implement caching and indexing from start

### Recommended Risk Mitigation
- Implement transaction management early
- Create comprehensive fee calculation test suite (>100 test cases)
- Plan for payment gateway failures (fallback to manual)
- Use feature flags for gradual rollout

---

## SUCCESS METRICS

### Phase 1 MVP Success Criteria
- ✅ System processes ≥95% of vehicles through entry/exit without manual intervention
- ✅ Revenue reconciliation: 100% match between system and payment records
- ✅ Fee calculation accuracy: 99.9%+ correct
- ✅ Transaction processing: <2 seconds per entry/exit
- ✅ System uptime: ≥99.5%

### Phase 1b Enhancement Success Criteria
- ✅ Multi-vehicle type support with correct pricing differentiation
- ✅ Reports provide actionable insights
- ✅ Pre-booking captures ≥10% of revenue

