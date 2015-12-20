public with sharing class Holidays {
	Set<Date> allDays = new Set<Date>();
	Holiday[] recurs = new Holiday[] {};

	public Holidays() {
		Holiday[] orgHolidays = [
			select
				ActivityDate,
				IsRecurrence,
				RecurrenceMonthOfYear,
				RecurrenceDayOfMonth,
				RecurrenceDayOfWeekMask,
				RecurrenceInstance,
				RecurrenceInterval,
				RecurrenceStartDate,
				RecurrenceEndDateOnly
			from Holiday where IsAllDay = true
		];

		for (Holiday h : orgHolidays) {
			allDays.add(h.ActivityDate);
			if (h.IsRecurrence) {
				recurs.add(h);
			}
		}
	}

	public Boolean isHoliday(Date d) {
		if (allDays.contains(d)) {
			return true;
		}
		for (Holiday h : recurs) {
			if (matchHoliday(h, d)) {
				return true;
			}
		}
		return false;
	}

	private static Boolean matchHoliday(Holiday h, Date d) {
		if (!isInRange(d, h.RecurrenceStartDate, h.RecurrenceEndDateOnly)) {
			return false;
		}
		Integer month = MONTH_LABEL.get(h.RecurrenceMonthOfYear);
		if (month != null && month != d.month()) {
			return false;
		}
		if (h.RecurrenceDayOfMonth != null && h.RecurrenceDayOfMonth != d.day()) {
			return false;
		}
		if (!matchDayOfWeek(h, d)) {
			return false;
		}
		return matchInterval(h, d);
	}

	@TestVisible
	private static Boolean isInRange(Date d, Date startDate, Date endDate) {
		return (startDate == null || startDate <= d) && (endDate == null || d <= endDate);
	}

	@TestVisible
	private static Boolean matchDayOfWeek(Holiday h, Date d) {
		Integer weekday = Integer.valueOf(DateTime.newInstance(d.year(), d.month(), d.day()).format('u'));
		if (h.RecurrenceDayOfWeekMask != null && (h.RecurrenceDayOfWeekMask & (1 << Math.mod(weekday, 7))) == 0) {
			return false;
		}
		return h.RecurrenceInstance == null
			|| (h.RecurrenceInstance == 'Last' && (Date.daysInMonth(d.year(), d.month()) - d.day()) < 7)
			|| (INSTANCE_MAP.get(h.RecurrenceInstance) == ((d.day() - 1) / 7));
	}

	@TestVisible
	private static Boolean matchInterval(Holiday h, Date d) {
		if (h.RecurrenceInterval == null) {
			return true;
		}
		if (h.RecurrenceDayOfMonth != null || h.RecurrenceInstance != null) {
			return Math.mod(h.ActivityDate.monthsBetween(d), h.RecurrenceInterval) == 0;
		}
		if (h.RecurrenceDayOfWeekMask != null) {
			return Math.mod(h.ActivityDate.daysBetween(d) / 7, h.RecurrenceInterval) == 0;
		}
		return Math.mod(h.ActivityDate.daysBetween(d), h.RecurrenceInterval) == 0;
	}

	private static final Map<String, Integer> MONTH_LABEL = new Map<String, Integer> {
		'January' => 1,
		'February' => 2,
		'March' => 3,
		'April' => 4,
		'May' => 5,
		'June' => 6,
		'July' => 7,
		'August' => 8,
		'September' => 9,
		'October' => 10,
		'November' => 11,
		'December' => 12
	};

	private static final Map<String, Integer> INSTANCE_MAP = new Map<String, Integer> {
		'First' => 0,
		'Second' => 1,
		'Third' => 2,
		'Fourth' => 3
	};
}
