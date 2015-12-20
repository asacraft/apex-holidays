public with sharing class Holidays {
	Set<Date> allDays = new Set<Date>();

	public Holidays() {
		Holiday[] orgHolidays = [select ActivityDate, IsAllDay from Holiday];
		for (Holiday h : orgHolidays) {
			if (h.IsAllDay) {
				allDays.add(h.ActivityDate);
			}
		}
	}

	public Boolean isHoliday(Date d) {
		return allDays.contains(d);
	}
}
