import 'package:go_router/go_router.dart';
import 'package:vblogmobile/constant/route.path.dart';
import 'package:vblogmobile/screens/detail.screen.dart';
import 'package:vblogmobile/screens/home.screen.dart';


GoRouter router() {
  return GoRouter(
     // initialLocation: AppRoutes.invoiceView,
      // initialExtra:  "ccf3ba99-29d2-4b6b-8feb-58e522e92415",
      
    routes: [
      GoRoute(path: AppRoutes.home,  builder: (context, state){
        return const MyHomePage();
      }),

        GoRoute(path: AppRoutes.postDetails,  builder: (context, state){
        return PostDetails(postId: state.extra as String,);
      })
    ]
  );
}