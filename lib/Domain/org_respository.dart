import 'package:flutterdemo/Data/JSON/org_json.dart';

import 'org_entity.dart';

abstract class OrgRepository {

  //List<OrgJson> list;

  Future<List<OrgJson>> getOrgs();

}