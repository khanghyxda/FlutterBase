import 'package:sapp/common/component.dart';

class Answer {
  static const YES = 'YES';
  static const NO = 'NO';
}

class Constants {
  static String deleteConfirm = 'Bạn muốn xoá dữ liệu ?';

  static String insertSuccess = 'Thêm mới thành công';

  static String updateSuccess = 'Chỉnh sửa thành công';

  static String deleteSuccess = 'Xoá dữ liệu thành công';

  static String checkinSuccess = 'Nhận phòng thành công';

  static String checkoutSuccess = 'Trả phòng thành công';

  static String changeRoomSuccess = 'Đổi phòng thành công';

  static String systemError = 'Lỗi hệ thống. Ấn F5 để thử lại.';

  static String menuSelectRequired = 'Bạn chưa chọn menu nào';

  static String menuAddSuccess = 'Thêm menu thành công';

  static String startTimeBiggerThanEndTime =
      'Thời gian trả phòng cần phải lớn hơn thời gian nhận phòng';

  static String changePasswordSuccess = 'Đổi mật khẩu thành công';

  static String inventoryBalanceSuccess = 'Cân bằng kho thành công';

  static String inventoryImportCreateSuccess = 'Tạo phiếu nhập kho thành công';

  static String inventoryExportCreateSuccess = 'Tạo phiếu xuất kho thành công';

  static List<PopupMenuModel> menuTypes = [
    PopupMenuModel('Đồ ăn', 1),
    PopupMenuModel('Đồ uống',2),
    PopupMenuModel('Loại khác',3)
  ];
}

enum Mode {
  create,
  update
}
