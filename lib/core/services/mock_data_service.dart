import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'package:uuid/uuid.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    _init();
  }

  final _uuid = const Uuid();
  final _random = Random();

  // Building config
  String buildingName = 'Bãi Xe Thông Minh SWP08';
  String buildingAddress = '123 Nguyễn Văn Linh, TP.HCM';
  String openTime = '06:00';
  String closeTime = '22:00';

  // Users
  late List<AppUser> users;
  AppUser? currentUser;

  // Floors & Slots
  late List<ParkingFloor> floors;
  late List<ParkingSlot> slots;

  // Sessions
  late List<ParkingSession> sessions;

  // Pricing
  late List<PricingPolicy> pricingPolicies;

  // Prebooking
  late List<Prebooking> prebookings;

  // Feedback
  late List<FeedbackReport> feedbacks;

  void _init() {
    _initUsers();
    _initFloors();
    _initSlots();
    _initPricing();
    _initSessions();
    _initPrebookings();
    _initFeedbacks();
  }

  void _initUsers() {
    users = [
      AppUser(
        id: 'u001',
        username: 'manager',
        fullName: 'Nguyễn Văn Quản',
        email: 'manager@parking.vn',
        phone: '0901234567',
        role: UserRole.manager,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      AppUser(
        id: 'u002',
        username: 'staff1',
        fullName: 'Trần Thị Lan',
        email: 'lan@parking.vn',
        phone: '0912345678',
        role: UserRole.staff,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
      AppUser(
        id: 'u003',
        username: 'staff2',
        fullName: 'Lê Văn Hùng',
        email: 'hung@parking.vn',
        phone: '0923456789',
        role: UserRole.staff,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
      ),
      AppUser(
        id: 'u004',
        username: 'driver1',
        fullName: 'Phạm Minh Tuấn',
        email: 'tuan@gmail.com',
        phone: '0934567890',
        role: UserRole.driver,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      AppUser(
        id: 'u005',
        username: 'driver2',
        fullName: 'Hoàng Thị Mai',
        email: 'mai@gmail.com',
        phone: '0945678901',
        role: UserRole.driver,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      AppUser(
        id: 'u006',
        username: 'admin',
        fullName: 'Vũ Quốc Bảo',
        email: 'admin@parking.vn',
        phone: '0956789012',
        role: UserRole.admin,
        createdAt: DateTime.now().subtract(const Duration(days: 400)),
      ),
    ];
  }

  void _initFloors() {
    floors = [
      ParkingFloor(
        id: 'f1',
        name: 'Tầng 1 (Xe máy)',
        floorNumber: 1,
        capacityByType: {VehicleType.motorbike: 60},
      ),
      ParkingFloor(
        id: 'f2',
        name: 'Tầng 2 (Xe máy)',
        floorNumber: 2,
        capacityByType: {VehicleType.motorbike: 60},
      ),
      ParkingFloor(
        id: 'f3',
        name: 'Tầng 3 (Ô tô)',
        floorNumber: 3,
        capacityByType: {VehicleType.car: 40},
      ),
      ParkingFloor(
        id: 'f4',
        name: 'Tầng 4 (Ô tô + Xe tải)',
        floorNumber: 4,
        capacityByType: {VehicleType.car: 20, VehicleType.truck: 10},
      ),
    ];
  }

  void _initSlots() {
    slots = [];
    int slotNum = 1;

    // Floor 1&2: motorbike
    for (final floor in floors.sublist(0, 2)) {
      for (int i = 0; i < 60; i++) {
        final statusRoll = _random.nextDouble();
        SlotStatus status;
        if (statusRoll < 0.45) {
          status = SlotStatus.occupied;
        } else if (statusRoll < 0.48) {
          status = SlotStatus.reserved;
        } else if (statusRoll < 0.50) {
          status = SlotStatus.maintenance;
        } else {
          status = SlotStatus.available;
        }
        slots.add(ParkingSlot(
          id: 'sl${slotNum.toString().padLeft(3, '0')}',
          floorId: floor.id,
          slotCode:
              '${floor.floorNumber}M${(i + 1).toString().padLeft(2, '0')}',
          allowedType: VehicleType.motorbike,
          status: status,
        ));
        slotNum++;
      }
    }

    // Floor 3: car
    for (int i = 0; i < 40; i++) {
      final statusRoll = _random.nextDouble();
      SlotStatus status;
      if (statusRoll < 0.55) {
        status = SlotStatus.occupied;
      } else if (statusRoll < 0.60) {
        status = SlotStatus.reserved;
      } else if (statusRoll < 0.62) {
        status = SlotStatus.maintenance;
      } else {
        status = SlotStatus.available;
      }
      slots.add(ParkingSlot(
        id: 'sl${slotNum.toString().padLeft(3, '0')}',
        floorId: 'f3',
        slotCode: '3C${(i + 1).toString().padLeft(2, '0')}',
        allowedType: VehicleType.car,
        status: status,
      ));
      slotNum++;
    }

    // Floor 4: car + truck
    for (int i = 0; i < 20; i++) {
      final status =
          _random.nextBool() ? SlotStatus.occupied : SlotStatus.available;
      slots.add(ParkingSlot(
        id: 'sl${slotNum.toString().padLeft(3, '0')}',
        floorId: 'f4',
        slotCode: '4C${(i + 1).toString().padLeft(2, '0')}',
        allowedType: VehicleType.car,
        status: status,
      ));
      slotNum++;
    }
    for (int i = 0; i < 10; i++) {
      final status =
          _random.nextBool() ? SlotStatus.occupied : SlotStatus.available;
      slots.add(ParkingSlot(
        id: 'sl${slotNum.toString().padLeft(3, '0')}',
        floorId: 'f4',
        slotCode: '4T${(i + 1).toString().padLeft(2, '0')}',
        allowedType: VehicleType.truck,
        status: status,
      ));
      slotNum++;
    }
  }

  void _initPricing() {
    pricingPolicies = [
      PricingPolicy(
        id: 'p001',
        vehicleType: VehicleType.motorbike,
        ratePerHour: 5000,
        overnightRate: 15000,
        monthlyRate: 300000,
        description: 'Xe máy / moped',
      ),
      PricingPolicy(
        id: 'p002',
        vehicleType: VehicleType.car,
        ratePerHour: 20000,
        overnightRate: 60000,
        monthlyRate: 1200000,
        description: 'Ô tô dưới 7 chỗ',
      ),
      PricingPolicy(
        id: 'p003',
        vehicleType: VehicleType.truck,
        ratePerHour: 40000,
        overnightRate: 120000,
        monthlyRate: 2400000,
        description: 'Xe tải / xe lớn',
      ),
    ];
  }

  void _initSessions() {
    sessions = [];
    final plates = [
      '51A-12345',
      '59B-67890',
      '51C-11223',
      '43D-55678',
      '29E-99001',
      '51F-44332',
      '30G-88765',
      '51H-22110',
      '51K-77654',
      '61L-33219',
      '51M-66543',
      '92N-12398',
    ];
    final vehicleTypes = [
      VehicleType.motorbike,
      VehicleType.car,
      VehicleType.truck
    ];

    // Past completed sessions (last 7 days)
    for (int day = 6; day >= 1; day--) {
      final sessionCount = 15 + _random.nextInt(20);
      for (int i = 0; i < sessionCount; i++) {
        final plate = plates[_random.nextInt(plates.length)];
        final vType = vehicleTypes[_random.nextInt(3)];
        final floorId = _floorForType(vType);
        final slot = _randomSlotForFloor(floorId);
        final entry = DateTime.now().subtract(Duration(
          days: day,
          hours: 6 + _random.nextInt(14),
          minutes: _random.nextInt(60),
        ));
        final durationHours = 1 + _random.nextInt(8);
        final exit = entry.add(Duration(hours: durationHours));
        final rate = _rateForType(vType);
        final fee = (durationHours * rate).toDouble();

        sessions.add(ParkingSession(
          id: _uuid.v4(),
          licensePlate: plate,
          vehicleType: vType,
          floorId: floorId,
          slotId: slot?.id ?? 'sl001',
          slotCode: slot?.slotCode ?? '1M01',
          entryTime: entry,
          exitTime: exit,
          totalFee: fee,
          status: SessionStatus.completed,
          exceptionType: ExceptionType.none,
          staffId: 'u002',
          isPaid: true,
        ));
      }
    }

    // Today active sessions
    final activePlates = [
      '51A-78901',
      '51B-23456',
      '43C-34567',
      '29D-45678',
      '51E-56789',
      '61F-67890',
      '30G-78901',
      '92H-89012',
    ];
    for (int i = 0; i < activePlates.length; i++) {
      final plate = activePlates[i];
      final vType = vehicleTypes[_random.nextInt(3)];
      final floorId = _floorForType(vType);
      final slot = _availableSlotForFloor(floorId, vType);
      if (slot == null) continue;

      final entry = DateTime.now().subtract(Duration(
        hours: _random.nextInt(5),
        minutes: _random.nextInt(60),
      ));

      slot.status = SlotStatus.occupied;
      slot.currentLicensePlate = plate;

      sessions.add(ParkingSession(
        id: _uuid.v4(),
        licensePlate: plate,
        vehicleType: vType,
        floorId: floorId,
        slotId: slot.id,
        slotCode: slot.slotCode,
        entryTime: entry,
        status: SessionStatus.active,
        exceptionType: ExceptionType.none,
        staffId: 'u002',
        isPaid: false,
      ));
    }

    // Exception sessions – đa dạng loại ngoại lệ
    sessions.add(ParkingSession(
      id: _uuid.v4(),
      licensePlate: '51X-99999',
      vehicleType: VehicleType.motorbike,
      floorId: 'f1',
      slotId: 'sl001',
      slotCode: '1M01',
      entryTime: DateTime.now().subtract(const Duration(hours: 26)),
      status: SessionStatus.exception,
      exceptionType: ExceptionType.overtime,
      exceptionNote: 'Xe gửi quá 24 giờ, chưa thanh toán',
      staffId: 'u002',
      isPaid: false,
    ));
    sessions.add(ParkingSession(
      id: _uuid.v4(),
      licensePlate: '51Y-88888',
      vehicleType: VehicleType.car,
      floorId: 'f3',
      slotId: 'sl121',
      slotCode: '3C01',
      entryTime: DateTime.now().subtract(const Duration(hours: 3)),
      status: SessionStatus.exception,
      exceptionType: ExceptionType.lostTicket,
      exceptionNote: 'Khách báo mất thẻ, cần xác minh',
      staffId: 'u003',
      isPaid: false,
    ));
    sessions.add(ParkingSession(
      id: _uuid.v4(),
      licensePlate: '43A-56789',
      vehicleType: VehicleType.motorbike,
      floorId: 'f2',
      slotId: 'sl075',
      slotCode: '2M15',
      entryTime: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
      status: SessionStatus.exception,
      exceptionType: ExceptionType.wrongPlate,
      exceptionNote: 'Biển số ghi trên vé không khớp với xe thực tế',
      staffId: 'u002',
      isPaid: false,
    ));
    sessions.add(ParkingSession(
      id: _uuid.v4(),
      licensePlate: '29B-11223',
      vehicleType: VehicleType.car,
      floorId: 'f4',
      slotId: 'sl181',
      slotCode: '4C03',
      entryTime: DateTime.now().subtract(const Duration(hours: 8)),
      status: SessionStatus.exception,
      exceptionType: ExceptionType.unpaid,
      exceptionNote: 'Khách bỏ xe đi, chưa thanh toán trước khi ra cổng',
      staffId: 'u003',
      isPaid: false,
    ));
    sessions.add(ParkingSession(
      id: _uuid.v4(),
      licensePlate: '92C-33445',
      vehicleType: VehicleType.truck,
      floorId: 'f3',
      slotId: 'sl145',
      slotCode: '3C25',
      entryTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: SessionStatus.exception,
      exceptionType: ExceptionType.wrongZone,
      exceptionNote: 'Xe tải đậu ở tầng 3 dành cho ô tô con, cần di chuyển',
      staffId: 'u002',
      isPaid: false,
    ));
    sessions.add(ParkingSession(
      id: _uuid.v4(),
      licensePlate: '61D-77654',
      vehicleType: VehicleType.motorbike,
      floorId: 'f1',
      slotId: 'sl032',
      slotCode: '1M32',
      entryTime: DateTime.now().subtract(const Duration(hours: 48)),
      status: SessionStatus.exception,
      exceptionType: ExceptionType.overtime,
      exceptionNote: 'Xe gửi 2 ngày, chủ xe không liên lạc được',
      staffId: 'u002',
      isPaid: false,
    ));
  }

  void _initPrebookings() {
    prebookings = [
      Prebooking(
        id: 'pb001',
        userId: 'u004',
        userFullName: 'Phạm Minh Tuấn',
        vehicleType: VehicleType.car,
        licensePlate: '51A-78901',
        floorId: 'f3',
        bookingTime: DateTime.now().subtract(const Duration(hours: 2)),
        expectedEntry: DateTime.now().add(const Duration(hours: 1)),
        expectedExit: DateTime.now().add(const Duration(hours: 5)),
        status: PrebookingStatus.confirmed,
        confirmationCode: 'PB-2024-001',
        assignedSlotCode: '3C05',
      ),
      Prebooking(
        id: 'pb002',
        userId: 'u005',
        userFullName: 'Hoàng Thị Mai',
        vehicleType: VehicleType.motorbike,
        licensePlate: '59B-67890',
        floorId: 'f1',
        bookingTime: DateTime.now().subtract(const Duration(minutes: 30)),
        expectedEntry: DateTime.now().add(const Duration(hours: 2)),
        expectedExit: DateTime.now().add(const Duration(hours: 6)),
        status: PrebookingStatus.pending,
        confirmationCode: 'PB-2024-002',
      ),
    ];
  }

  void _initFeedbacks() {
    feedbacks = [
      FeedbackReport(
        id: 'fb001',
        userId: 'u004',
        userFullName: 'Phạm Minh Tuấn',
        category: FeedbackCategory.wrongFee,
        description: 'Phí thu không đúng với bảng giá hiển thị tại cổng.',
        status: FeedbackStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      FeedbackReport(
        id: 'fb002',
        userId: 'u005',
        userFullName: 'Hoàng Thị Mai',
        category: FeedbackCategory.occupiedSlot,
        description: 'Slot 3C10 đã được đặt nhưng có xe khác đỗ ở đó.',
        status: FeedbackStatus.resolved,
        resolution: 'Đã di chuyển xe vi phạm, hoàn tiền đặt chỗ.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        resolvedAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
    ];
  }

  // Helpers
  String _floorForType(VehicleType type) {
    switch (type) {
      case VehicleType.motorbike:
        return _random.nextBool() ? 'f1' : 'f2';
      case VehicleType.car:
        return _random.nextBool() ? 'f3' : 'f4';
      case VehicleType.truck:
        return 'f4';
    }
  }

  ParkingSlot? _randomSlotForFloor(String floorId) {
    final floorSlots = slots.where((s) => s.floorId == floorId).toList();
    if (floorSlots.isEmpty) return null;
    return floorSlots[_random.nextInt(floorSlots.length)];
  }

  ParkingSlot? _availableSlotForFloor(String floorId, VehicleType type) {
    final floorSlots = slots
        .where((s) =>
            s.floorId == floorId &&
            s.status == SlotStatus.available &&
            s.allowedType == type)
        .toList();
    if (floorSlots.isEmpty) return null;
    return floorSlots[_random.nextInt(floorSlots.length)];
  }

  double _rateForType(VehicleType type) {
    switch (type) {
      case VehicleType.motorbike:
        return 5000;
      case VehicleType.car:
        return 20000;
      case VehicleType.truck:
        return 40000;
    }
  }

  // ─────────── Auth ───────────
  bool login(String username, String password) {
    final user = users.where((u) => u.username == username).firstOrNull;
    if (user == null || user.status != UserStatus.active) return false;
    // Demo: any password works
    currentUser = user;
    notifyListeners();
    return true;
  }

  AppUser? registerDriver({
    required String username,
    required String fullName,
    required String email,
    required String phone,
  }) {
    final normalizedUsername = username.trim().toLowerCase();
    final alreadyExists = users.any(
      (u) => u.username.toLowerCase() == normalizedUsername,
    );
    if (alreadyExists) return null;

    final user = AppUser(
      id: _uuid.v4(),
      username: normalizedUsername,
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      role: UserRole.driver,
      createdAt: DateTime.now(),
    );
    users.add(user);
    currentUser = user;
    notifyListeners();
    return user;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  // ─────────── Slot queries ───────────
  List<ParkingSlot> slotsForFloor(String floorId) =>
      slots.where((s) => s.floorId == floorId).toList();

  int availableCount(String floorId) => slots
      .where((s) => s.floorId == floorId && s.status == SlotStatus.available)
      .length;

  int occupiedCount(String floorId) => slots
      .where((s) => s.floorId == floorId && s.status == SlotStatus.occupied)
      .length;

  int totalAvailable() =>
      slots.where((s) => s.status == SlotStatus.available).length;

  int totalOccupied() =>
      slots.where((s) => s.status == SlotStatus.occupied).length;

  double occupancyRate() {
    if (slots.isEmpty) return 0;
    return totalOccupied() / slots.length;
  }

  // ─────────── Session operations ───────────
  ParkingSession? checkIn({
    required String licensePlate,
    required VehicleType vehicleType,
    required String floorId,
    required String staffId,
  }) {
    final slot = _availableSlotForFloor(floorId, vehicleType);
    if (slot == null) return null;

    slot.status = SlotStatus.occupied;
    slot.currentLicensePlate = licensePlate;

    final session = ParkingSession(
      id: _uuid.v4(),
      licensePlate: licensePlate,
      vehicleType: vehicleType,
      floorId: floorId,
      slotId: slot.id,
      slotCode: slot.slotCode,
      entryTime: DateTime.now(),
      status: SessionStatus.active,
      staffId: staffId,
    );
    sessions.add(session);
    notifyListeners();
    return session;
  }

  ParkingSession? checkOut({
    required String sessionId,
    required String staffId,
  }) {
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null || session.status != SessionStatus.active) return null;

    final slot = slots.where((s) => s.id == session.slotId).firstOrNull;
    if (slot != null) {
      slot.status = SlotStatus.available;
      slot.currentLicensePlate = null;
      slot.currentSessionId = null;
    }

    session.exitTime = DateTime.now();
    session.status = SessionStatus.completed;

    final policy = pricingPolicies
        .where((p) => p.vehicleType == session.vehicleType)
        .firstOrNull;
    final rate = policy?.ratePerHour ?? 5000;
    session.totalFee = session.calculateFee(rate);
    session.isPaid = true;
    session.staffId = staffId;

    notifyListeners();
    return session;
  }

  ParkingSession? findActiveSession(String licensePlate) {
    return sessions
        .where((s) =>
            s.status == SessionStatus.active &&
            s.licensePlate.toLowerCase() == licensePlate.toLowerCase())
        .firstOrNull;
  }

  List<ParkingSession> activeSessionsForUser(String userId) {
    // In real system, sessions would link to userId. For demo, show last 3 active.
    return sessions
        .where((s) => s.status == SessionStatus.active)
        .take(3)
        .toList();
  }

  List<ParkingSession> get activeSessions =>
      sessions.where((s) => s.status == SessionStatus.active).toList();

  List<ParkingSession> get exceptionSessions =>
      sessions.where((s) => s.status == SessionStatus.exception).toList();

  List<ParkingSession> get completedSessions =>
      sessions.where((s) => s.status == SessionStatus.completed).toList();

  void resolveException(String sessionId, String note) {
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;
    session.status = SessionStatus.active;
    session.exceptionNote = note;
    notifyListeners();
  }

  /// Giải quyết ngoại lệ và hoàn tất phiên (tính phí, giải phóng slot)
  ParkingSession? checkOutException({
    required String sessionId,
    required String staffId,
    String? note,
  }) {
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return null;

    final slot = slots.where((s) => s.id == session.slotId).firstOrNull;
    if (slot != null) {
      slot.status = SlotStatus.available;
      slot.currentLicensePlate = null;
      slot.currentSessionId = null;
    }

    session.exitTime = DateTime.now();
    session.status = SessionStatus.completed;
    session.exceptionType = ExceptionType.none;
    if (note != null && note.isNotEmpty) session.exceptionNote = note;

    final policy = pricingPolicies
        .where((p) => p.vehicleType == session.vehicleType)
        .firstOrNull;
    final rate = policy?.ratePerHour ?? 5000;
    session.totalFee = session.calculateFee(rate);
    session.isPaid = true;
    session.staffId = staffId;

    notifyListeners();
    return session;
  }

  /// Đánh dấu (hoặc đổi loại) ngoại lệ cho một phiên đang active
  void markAsException({
    required String sessionId,
    required ExceptionType exceptionType,
    String? note,
  }) {
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;
    session.status = SessionStatus.exception;
    session.exceptionType = exceptionType;
    if (note != null && note.isNotEmpty) session.exceptionNote = note;
    notifyListeners();
  }

  void updateSlotStatus(String slotId, SlotStatus status) {
    final slot = slots.where((s) => s.id == slotId).firstOrNull;
    if (slot == null) return;
    slot.status = status;
    notifyListeners();
  }

  // ─────────── Pricing operations ───────────
  void updatePricing(String policyId, double ratePerHour, double? overnightRate,
      double? monthlyRate) {
    final policy = pricingPolicies.where((p) => p.id == policyId).firstOrNull;
    if (policy == null) return;
    policy.ratePerHour = ratePerHour;
    policy.overnightRate = overnightRate;
    policy.monthlyRate = monthlyRate;
    notifyListeners();
  }

  double getPriceForType(VehicleType type) {
    return pricingPolicies
            .where((p) => p.vehicleType == type)
            .firstOrNull
            ?.ratePerHour ??
        5000;
  }

  // ─────────── Reports ───────────
  double todayRevenue() {
    final today = DateTime.now();
    return sessions
        .where((s) =>
            s.status == SessionStatus.completed &&
            s.exitTime != null &&
            s.exitTime!.day == today.day &&
            s.exitTime!.month == today.month &&
            s.exitTime!.year == today.year)
        .fold(0.0, (sum, s) => sum + (s.totalFee ?? 0));
  }

  double weekRevenue() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return sessions
        .where((s) =>
            s.status == SessionStatus.completed &&
            s.exitTime != null &&
            s.exitTime!.isAfter(weekAgo))
        .fold(0.0, (sum, s) => sum + (s.totalFee ?? 0));
  }

  List<Map<String, dynamic>> hourlyTrafficToday() {
    final today = DateTime.now();
    final result = <Map<String, dynamic>>[];
    for (int h = 6; h <= 22; h++) {
      final entries = sessions.where((s) {
        return s.entryTime.day == today.day &&
            s.entryTime.month == today.month &&
            s.entryTime.year == today.year &&
            s.entryTime.hour == h;
      }).length;
      result.add({'hour': h, 'count': entries});
    }
    return result;
  }

  List<Map<String, dynamic>> dailyRevenue7Days() {
    final result = <Map<String, dynamic>>[];
    for (int d = 6; d >= 0; d--) {
      final day = DateTime.now().subtract(Duration(days: d));
      final rev = sessions
          .where((s) =>
              s.status == SessionStatus.completed &&
              s.exitTime != null &&
              s.exitTime!.day == day.day &&
              s.exitTime!.month == day.month &&
              s.exitTime!.year == day.year)
          .fold(0.0, (sum, s) => sum + (s.totalFee ?? 0));
      result.add({'day': day, 'revenue': rev});
    }
    return result;
  }

  // ─────────── Prebooking ───────────
  Prebooking createPrebooking({
    required String userId,
    required String userFullName,
    required VehicleType vehicleType,
    required String licensePlate,
    required String floorId,
    required DateTime expectedEntry,
    required DateTime expectedExit,
  }) {
    final code = 'PB-${DateTime.now().year}-${prebookings.length + 1}';
    final booking = Prebooking(
      id: _uuid.v4(),
      userId: userId,
      userFullName: userFullName,
      vehicleType: vehicleType,
      licensePlate: licensePlate,
      floorId: floorId,
      bookingTime: DateTime.now(),
      expectedEntry: expectedEntry,
      expectedExit: expectedExit,
      status: PrebookingStatus.confirmed,
      confirmationCode: code,
    );
    prebookings.add(booking);
    // Reserve a slot
    final slot = _availableSlotForFloor(floorId, vehicleType);
    if (slot != null) {
      slot.status = SlotStatus.reserved;
      booking.assignedSlotId = slot.id;
      booking.assignedSlotCode = slot.slotCode;
    }
    notifyListeners();
    return booking;
  }

  List<Prebooking> prebookingsForUser(String userId) =>
      prebookings.where((b) => b.userId == userId).toList();

  // ─────────── Feedback ───────────
  void submitFeedback({
    required String userId,
    required String userFullName,
    required FeedbackCategory category,
    required String description,
    String? sessionId,
    String? licensePlate,
  }) {
    feedbacks.add(FeedbackReport(
      id: _uuid.v4(),
      userId: userId,
      userFullName: userFullName,
      sessionId: sessionId,
      licensePlate: licensePlate,
      category: category,
      description: description,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void resolveFeedback(String feedbackId, String resolution) {
    final fb = feedbacks.where((f) => f.id == feedbackId).firstOrNull;
    if (fb == null) return;
    fb.status = FeedbackStatus.resolved;
    fb.resolution = resolution;
    fb.resolvedAt = DateTime.now();
    notifyListeners();
  }

  // ─────────── User management ───────────
  void addUser(AppUser user) {
    users.add(user);
    notifyListeners();
  }

  void toggleUserStatus(String userId) {
    final user = users.where((u) => u.id == userId).firstOrNull;
    if (user == null) return;
    user.status = user.status == UserStatus.active
        ? UserStatus.inactive
        : UserStatus.active;
    notifyListeners();
  }

  // ─────────── AI Optimization ───────────
  List<AiRecommendation> generateAiOptimization() {
    final recommendations = <AiRecommendation>[];

    // Count slots and occupancy by type
    int mbTotal = 0, mbOcc = 0;
    int carTotal = 0, carOcc = 0;

    for (final s in slots) {
      if (s.allowedType == VehicleType.motorbike) {
        mbTotal++;
        if (s.status == SlotStatus.occupied) mbOcc++;
      } else if (s.allowedType == VehicleType.car) {
        carTotal++;
        if (s.status == SlotStatus.occupied) carOcc++;
      }
    }

    final mbRate = mbTotal == 0 ? 0 : mbOcc / mbTotal;
    final carRate = carTotal == 0 ? 0 : carOcc / carTotal;

    // Rule 1: High motorbike demand, low car demand
    if (mbRate > 0.6 && carRate < 0.6) {
      // Find empty car slots to convert
      final emptyCarSlots = slots
          .where((s) =>
              s.allowedType == VehicleType.car &&
              s.status == SlotStatus.available)
          .toList();
      if (emptyCarSlots.length >= 5) {
        final toConvert = emptyCarSlots.take(5).map((s) => s.id).toList();
        recommendations.add(AiRecommendation(
          title: 'Quá tải khu vực Xe máy',
          description:
              'Tỷ lệ lấp đầy xe máy đạt ${(mbRate * 100).toStringAsFixed(1)}%, trong khi ô tô chỉ đạt ${(carRate * 100).toStringAsFixed(1)}%. Khách hàng đi xe máy đang mất nhiều thời gian tìm chỗ trống.',
          impact:
              'Gộp 5 slot ô tô trống thành 15 slot xe máy tạm thời để giảm kẹt xe và tăng tỷ lệ lấp đầy.',
          fromType: VehicleType.car,
          toType: VehicleType.motorbike,
          slotsToConvert: 5,
          targetFloorId: emptyCarSlots.first.floorId,
          targetSlotIds: toConvert,
        ));
      }
    }

    // Rule 2: High car demand, low motorbike demand
    if (carRate > 0.6 && mbRate < 0.6) {
      final emptyMbSlots = slots
          .where((s) =>
              s.allowedType == VehicleType.motorbike &&
              s.status == SlotStatus.available)
          .toList();
      if (emptyMbSlots.length >= 15) {
        final toConvert = emptyMbSlots.take(15).map((s) => s.id).toList();
        recommendations.add(AiRecommendation(
          title: 'Khu vực Ô tô sắp đầy',
          description:
              'Tỷ lệ lấp đầy ô tô đạt ${(carRate * 100).toStringAsFixed(1)}%. Khu vực xe máy còn nhiều chỗ trống (${(mbRate * 100).toStringAsFixed(1)}%).',
          impact:
              'Gộp 15 slot xe máy trống thành 5 slot ô tô. Tăng doanh thu thêm ~15% trong khung giờ cao điểm.',
          fromType: VehicleType.motorbike,
          toType: VehicleType.car,
          slotsToConvert: 15,
          targetFloorId: emptyMbSlots.first.floorId,
          targetSlotIds: toConvert,
        ));
      }
    }

    // Default if no big difference just to show the feature
    if (recommendations.isEmpty) {
      final emptyCarSlots = slots
          .where((s) =>
              s.allowedType == VehicleType.car &&
              s.status == SlotStatus.available)
          .toList();
      if (emptyCarSlots.isNotEmpty) {
        final toConvert = emptyCarSlots.take(2).map((s) => s.id).toList();
        recommendations.add(AiRecommendation(
          title: 'Tối ưu Tỷ suất lợi nhuận',
          description:
              'AI phát hiện lượng xe máy có xu hướng tăng vào giờ này. Hiện còn ${emptyCarSlots.length} slot ô tô trống ở Tầng ${emptyCarSlots.first.floorId.replaceAll('f', '')}.',
          impact:
              'Chuyển đổi linh hoạt 2 slot ô tô thành các slot xe máy giúp tận dụng tối đa không gian chờ.',
          fromType: VehicleType.car,
          toType: VehicleType.motorbike,
          slotsToConvert: 2,
          targetFloorId: emptyCarSlots.first.floorId,
          targetSlotIds: toConvert,
        ));
      }
    }

    return recommendations;
  }

  void applyAiRecommendation(AiRecommendation rec) {
    for (final id in rec.targetSlotIds) {
      final slot = slots.where((s) => s.id == id).firstOrNull;
      if (slot != null && slot.status == SlotStatus.available) {
        slot.allowedType = rec.toType;
      }
    }
    notifyListeners();
  }

  // ─────────── Building Config ───────────
  void updateBuildingConfig({
    required String name,
    required String address,
    required String open,
    required String close,
  }) {
    buildingName = name;
    buildingAddress = address;
    openTime = open;
    closeTime = close;
    notifyListeners();
  }
}
