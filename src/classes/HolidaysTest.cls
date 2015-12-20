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
}
