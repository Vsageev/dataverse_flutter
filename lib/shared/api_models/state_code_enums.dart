enum StateCode { Active, Inactive }

extension Ext on StateCode {
  String name() {
    if (this == StateCode.Active) {
      return "active";
    }
    if (this == StateCode.Inactive) {
      return "inactive";
    }

    return "error";
  }
}
