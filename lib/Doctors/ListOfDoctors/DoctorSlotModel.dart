class DoctorSlot {
  final String date;
  final List<Slot> availableSlots;

  DoctorSlot({
    required this.date,
    required this.availableSlots,
  });

  factory DoctorSlot.fromJson(Map<String, dynamic> json) {
    return DoctorSlot(
      date: json['date'],
      availableSlots: List<Slot>.from(
        json['availableSlots'].map((e) => Slot.fromJson(e)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'availableSlots': availableSlots.map((e) => e.toJson()).toList(),
      };
}

class Slot {
  final String slot;
  final bool slotbooked;

  Slot({required this.slot, required this.slotbooked});

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        slot: json['slot'],
        slotbooked: json['slotbooked'],
      );

  Map<String, dynamic> toJson() => {
        'slot': slot,
        'slotbooked': slotbooked,
      };
}
