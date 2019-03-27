import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:codefest/src/components/containers/stateful_component.dart';
import 'package:codefest/src/components/layout/layout.dart';
import 'package:codefest/src/components/layout/navigation_type.dart';
import 'package:codefest/src/components/loader/loader.dart';
import 'package:codefest/src/components/ui/button/button.dart';
import 'package:codefest/src/components/ui/popularity_icon/popularity_icon.dart';
import 'package:codefest/src/components/ui/tabs/tabs.dart';
import 'package:codefest/src/models/lecture.dart';
import 'package:codefest/src/redux/actions/change_lecture_favorite_action.dart';
import 'package:codefest/src/redux/actions/change_lecture_like_action.dart';
import 'package:codefest/src/redux/actions/init_action.dart';
import 'package:codefest/src/redux/selectors/selectors.dart';
import 'package:codefest/src/redux/services/dispatcher.dart';
import 'package:codefest/src/redux/services/store_factory.dart';
import 'package:codefest/src/route_paths.dart';

@Component(
  selector: 'lecture-info',
  styleUrls: ['lecture_info.css'],
  templateUrl: 'lecture_info.html',
  directives: [
    NgIf,
    NgFor,
    ButtonComponent,
  ],
  exports: [
    NavigationType
  ],
  preserveWhitespace: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class LectureInfoComponent extends StatefulComponent {
  final Selectors _selectors;
  final Dispatcher _dispatcher;
  final Router _router;

  @Input()
  Lecture lecture;

  LectureInfoComponent(
      NgZone zone,
      ChangeDetectorRef cdr,
      StoreFactory storeFactory,
      this._router,
      this._selectors,
      this._dispatcher,
      ) : super(zone, cdr, storeFactory);

  bool get lectureStarted => _selectors.lectureStarted(lecture);

  String get endTime => _selectors.getEndTimeText(lecture);

  bool get isAuthorized => _selectors.isAuthorized(state);

  bool get isLikable => _selectors.isLikableLecture(lecture);

  bool get isLiked => _selectors.isLikedLecture(state, lecture);

  String get startTime => _selectors.getStartTimeText(lecture);

  void onLikeClick() {
    if (!isAuthorized) {
      _router.navigateByUrl(RoutePaths.login.toUrl());
    } else if (lectureStarted) {
      _dispatcher.dispatch(ChangeLectureLikeAction(lectureId: lecture.id, isLiked: !isLiked));
    }
  }
}