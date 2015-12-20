@isTest
private class HolidaysTest {

	@isTest
	private static void testIsHoliday() {
		Date d = Date.newInstance(1989, 10, 21);
		insert new Holiday(Name = 'test', ActivityDate = d);

		Holidays holidays = new Holidays();
		System.assertEquals(true, holidays.isHoliday(d));
		System.assertEquals(false, holidays.isHoliday(d.addDays(1)));
	}

	@isTest
	private static void testIsHoliday_RecursDaily() {
		Date d = Date.newInstance(1989, 10, 21);
		insert new Holiday(
			Name = 'test',
			IsRecurrence = true,
			RecurrenceType = 'RecursDaily',
			RecurrenceInterval = 3,
			RecurrenceStartDate = d
		);

		Holidays holidays = new Holidays();
		System.assertEquals(true, holidays.isHoliday(d));
		System.assertEquals(false, holidays.isHoliday(d.addDays(1)));
		System.assertEquals(false, holidays.isHoliday(d.addDays(2)));
		System.assertEquals(true, holidays.isHoliday(d.addDays(3)));
	}

	@isTest
	private static void testIsHoliday_RecursWeekly() {
		Date d = Date.newInstance(1989, 10, 21); // Saturday
		insert new Holiday(
			Name = 'test',
			IsRecurrence = true,
			RecurrenceType = 'RecursWeekly',
			RecurrenceDayOfWeekMask = 65, // Sat & Sun
			RecurrenceInterval = 1,
			RecurrenceStartDate = d
		);

		Holidays holidays = new Holidays();
		System.assertEquals(false, holidays.isHoliday(d.addDays(-1)));
		System.assertEquals(true, holidays.isHoliday(d));
		System.assertEquals(true, holidays.isHoliday(d.addDays(1)));
		System.assertEquals(false, holidays.isHoliday(d.addDays(2)));
	}

	@isTest
	private static void testIsHoliday_RecursMonthly() {
		Date d = Date.newInstance(1989, 10, 21);
		insert new Holiday(
			Name = 'test',
			IsRecurrence = true,
			RecurrenceType = 'RecursMonthly',
			RecurrenceDayOfMonth = 21,
			RecurrenceInterval = 2,
			RecurrenceStartDate = d
		);

		Holidays holidays = new Holidays();
		System.assertEquals(false, holidays.isHoliday(d.addDays(-1)));
		System.assertEquals(true, holidays.isHoliday(d));
		System.assertEquals(false, holidays.isHoliday(d.addDays(1)));
		System.assertEquals(false, holidays.isHoliday(d.addMonths(1)));
		System.assertEquals(true, holidays.isHoliday(d.addMonths(2)));
		System.assertEquals(false, holidays.isHoliday(d.addMonths(3)));
	}

	@isTest
	private static void testIsHoliday_RecursYearly() {
		Date d = Date.newInstance(1989, 10, 21);
		insert new Holiday(
			Name = 'test',
			IsRecurrence = true,
			RecurrenceType = 'RecursYearly',
			RecurrenceMonthOfYear = 'October',
			RecurrenceDayOfMonth = 21,
			RecurrenceStartDate = d
		);

		Holidays holidays = new Holidays();
		System.assertEquals(false, holidays.isHoliday(d.addDays(-1)));
		System.assertEquals(true, holidays.isHoliday(d));
		System.assertEquals(false, holidays.isHoliday(d.addDays(1)));
		System.assertEquals(false, holidays.isHoliday(d.addMonths(1)));
		System.assertEquals(true, holidays.isHoliday(d.addYears(1)));
	}

	@isTest
	private static void testIsInRange() {
		Date d = Date.newInstance(1989, 10, 21);
		System.assertEquals(true, Holidays.isInRange(d, null, null));
		System.assertEquals(true, Holidays.isInRange(d, null, d));
		System.assertEquals(true, Holidays.isInRange(d, d, null));
		System.assertEquals(true, Holidays.isInRange(d, d, d));
		System.assertEquals(false, Holidays.isInRange(d, d.addDays(1), null));
		System.assertEquals(false, Holidays.isInRange(d, null, d.addDays(-1)));
	}

	@isTest
	private static void testMatchDayOfWeek() {
		Date d = Date.newInstance(1989, 10, 21); // 3rd Saturday
		Holiday h = new Holiday();
		h.RecurrenceDayOfWeekMask = 63;
		System.assertEquals(false, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceDayOfWeekMask = 64;
		System.assertEquals(true, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceDayOfWeekMask = 126;
		System.assertEquals(true, Holidays.matchDayOfWeek(h, d));
		System.assertEquals(false, Holidays.matchDayOfWeek(h, d.addDays(1)));
		h.RecurrenceInstance = 'First';
		System.assertEquals(false, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceInstance = 'Second';
		System.assertEquals(false, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceInstance = 'Third';
		System.assertEquals(true, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceInstance = 'Fourth';
		System.assertEquals(false, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceInstance = 'Fourth';
		System.assertEquals(true, Holidays.matchDayOfWeek(h, d.addDays(7)));
		h.RecurrenceInstance = 'Last';
		System.assertEquals(false, Holidays.matchDayOfWeek(h, d));
		h.RecurrenceInstance = 'Last';
		System.assertEquals(true, Holidays.matchDayOfWeek(h, d.addDays(7)));
	}

	@isTest
	private static void testMatchInterval_NthMonth() {
		Date d = Date.newInstance(1989, 10, 21);
		Holiday h = new Holiday();
		h.RecurrenceDayOfMonth = 21;
		h.RecurrenceInterval = 3;
		h.ActivityDate = d;
		System.assertEquals(true, Holidays.matchInterval(h, d));
		System.assertEquals(false, Holidays.matchInterval(h, d.addMonths(1)));
		System.assertEquals(false, Holidays.matchInterval(h, d.addMonths(2)));
		System.assertEquals(true, Holidays.matchInterval(h, d.addMonths(3)));
		System.assertEquals(false, Holidays.matchInterval(h, d.addMonths(4)));
	}

	@isTest
	private static void testMatchInterval_NthWeek() {
		Date d = Date.newInstance(1989, 10, 21); // Saturday
		Holiday h = new Holiday();
		h.RecurrenceDayOfWeekMask = 64;
		h.RecurrenceInterval = 3;
		h.ActivityDate = d;
		System.assertEquals(true, Holidays.matchInterval(h, d));
		System.assertEquals(false, Holidays.matchInterval(h, d.addDays(7)));
		System.assertEquals(false, Holidays.matchInterval(h, d.addDays(14)));
		System.assertEquals(true, Holidays.matchInterval(h, d.addDays(21)));
		System.assertEquals(false, Holidays.matchInterval(h, d.addDays(28)));
	}

	@isTest
	private static void testMatchInterval_NthDay() {
		Date d = Date.newInstance(1989, 10, 21);
		Holiday h = new Holiday();
		h.ActivityDate = d;
		System.assertEquals(true, Holidays.matchInterval(h, d));
		h.RecurrenceInterval = 3;
		System.assertEquals(true, Holidays.matchInterval(h, d));
		System.assertEquals(false, Holidays.matchInterval(h, d.addDays(1)));
		System.assertEquals(false, Holidays.matchInterval(h, d.addDays(2)));
		System.assertEquals(true, Holidays.matchInterval(h, d.addDays(3)));
		System.assertEquals(false, Holidays.matchInterval(h, d.addDays(4)));
	}
}
