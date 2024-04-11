import 'package:ct484_project/models/food_recipe.dart';
import 'package:ct484_project/ui/food/staggered_grid_tile.dart';
import 'package:flutter/material.dart';

class StaggeredGridView extends StatelessWidget {
  const StaggeredGridView(this.type, this.foodByTypeList, {super.key});

  final String type;
  final List<FoodRecipe> foodByTypeList;

  @override
  Widget build(BuildContext context) {

    final BoxDecoration _boxDecorationStyle = BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3) //Vị trí bóng
                              )
                            ]
                          );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(type, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0
                        )
                      )
                    ),
                    child: Text(
                      "Xem tất cả", 
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, 
                      ),
                    ),
                  ),
                  Icon(Icons.navigate_next, color: Theme.of(context).iconTheme.color,)
                ],
              ),
              onPressed: () {
                print("Xem chi tiết");
              },
            )
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foodByTypeList.length+1,
            itemBuilder: (context, index) => index==foodByTypeList.length 
            ? IconButton(onPressed: () => print("Xem tất cả"), 
              icon: Container(
                child: CircleAvatar(child: Icon(Icons.navigate_next),backgroundColor: Theme.of(context).indicatorColor,),
                decoration: _boxDecorationStyle,
              )
            ) 
            : StaggeredGridTile(foodByTypeList[index]),
            // const SizedBox(width: 200, child: const Card(color: Colors.red,child: Text("OMG")))
          ),
        ),
      ],
    );
  }
}