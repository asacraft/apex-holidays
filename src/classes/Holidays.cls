public with sharing class Holidays {
	List<Holiday> orgHolidays;

	public Holidays() {
		orgHolidays = [select ActivityDate from Holiday];
	}

	public Boolean isHoliday(Date d) {
		for (Holiday h : orgHolidays) {
			if (h.ActivityDate == d) {
				return true;
			}
		}
		return false;
	}
}
