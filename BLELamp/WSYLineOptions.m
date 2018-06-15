//
//  WSYLineOptions.m
//  BLELamp
//
//  Created by 王世勇 on 2018/5/31.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYLineOptions.h"

@implementation WSYLineOptions

+ (PYOption *)standardLineOptionWithSubtitle:(NSString *)subtitle
                               withTimeArray:(NSArray *)timeArray
                              withTotalArray:(NSArray *)totalArray
                                withEndEqual:(NSNumber *)value{
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textStyle.color = @("#ff0000"); //主标题颜色
//            title.textEqual(WSY(@"Allocated equipment status"));
            title.xEqual(@20)
            .subtextEqual(subtitle);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@60).x2Equal(@45);
            grid.yEqual(@50);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.yEqual(@60);
            legend.textStyle.fontSize = @13;
//            legend.dataEqual(@[WSY(@"Total "),WSY(@"Online "),WSY(@"Offline ")]);
        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(YES)
            .xEqual(@(kScreenWidth - 60))
            .yEqual(PYPositionTop) //PYPositionTop
            .zEqual(@90)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
                    mark.showEqual(NO);
                }])
                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
                    dataView.showEqual(NO).readOnlyEqual(NO);
                }])
                .magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
                    magicType.showEqual(NO).typeEqual(@[PYSeriesTypeLine, PYSeriesTypeBar]);
                }])
                .dataZoomEqual([PYToolboxFeatureDataZoom initPYToolboxFeatureDataZoomWithBlock:^(PYToolboxFeatureDataZoom *dataZoom){
                    dataZoom.showEqual(NO);
                }])
                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
                    restore.showEqual(NO);
                }]);
            }]);
        }])
        .dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
            dataZoom.showEqual(YES)
            .realtimeEqual(YES)
            .startEqual(@0)
            .endEqual(value);
            dataZoom.handleSize = @15;
            dataZoom.dataBackgroundColor = [PYColor colorWithHexString:@"#afafaf"];
            //            dataZoom.handleColor = [PYColor colorWithHexString:@"#80e84127"];
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            //设置x坐标系标题
            axis.typeEqual(PYAxisTypeCategory).nameEqual(@"PPFD")
            .boundaryGapEqual(@YES)
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.onGapEqual(NO);
            }])
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *spliteLine) {
                spliteLine.showEqual(NO);
            }])
            .addDataArr(timeArray);
            //设置x坐标系线和标题颜色
            axis.axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual(PYRGBA(255, 255, 255, 1));
                }]);
            }]);
            axis.axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value}");
                //设置x坐标系文字颜色
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle){
                    textStyle.colorEqual(PYRGBA(255, 255, 255, 1));
                }]);
            }]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            //设置y坐标系标题
            axis.typeEqual(PYAxisTypeValue).nameEqual(@"PPFD")
            .boundaryGapEqual(@[@0.01, @0.01])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value}");
                //设置y坐标系文字颜色
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle){
                    textStyle.colorEqual(PYRGBA(255, 255, 255, 1));
                }]);
            }]);
            //设置y坐标系线和标题颜色
            axis.axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual(PYRGBA(255, 255, 255, 1));
                }]);
            }]);
            
        }])
        .addSeries([PYSeries initPYSeriesWithBlock:^(PYSeries *series) {
            series.nameEqual(WSY(@"Total "))
            .typeEqual(PYSeriesTypeLine)
            .dataEqual(totalArray)
            .markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.addDataArr(@[@{@"type" : @"max", @"name": WSY(@"Current Value")},@{@"type" : @"min", @"name": WSY(@"Current Value")}]);
            }])
            .markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                markLine.addDataArr(@[@{@"type" : @"average", @"name": WSY(@"Average")}]);
            }]);
        }]);
    }];
}

@end
