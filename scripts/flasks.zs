import crafttweaker.api.fluid.FluidIngredient;
import crafttweaker.api.fluid.IFluidStack;
import crafttweaker.api.item.IItemStack;
import mods.create.FillingManager;

class Fluid {
    public static potion(levels as int) as IFluidStack => <fluid:create:potion>.withTag({Potion: "minecraft:purified_water"}) * (27000 * levels);
    public static clean (levels as int) as IFluidStack => <fluid:dehydration:purified_water>                                  * (27000 * levels);
    public static dirty (levels as int) as IFluidStack => <fluid:minecraft:water>                                             * (27000 * levels);
}

class Purity {
    public static val clean as int = 0;
    public static val mixed as int = 1;
    public static val dirty as int = 2;
}

function withLevel(flask as IItemStack, level as int) as IItemStack {
    return flask.copy().withTag({leather_flask: level});
}

function withLevelPurity(flask as IItemStack, level as int, purity: int) as IItemStack {
    return flask.copy().withTag({leather_flask: level, purified_water: purity});
}

val caps as int[IItemStack] = {
    <item:dehydration:leather_flask>           : 2,
    <item:dehydration:iron_leather_flask>      : 3,
    <item:dehydration:golden_leather_flask>    : 4,
    <item:dehydration:diamond_leather_flask>   : 5,
    <item:dehydration:netherite_leather_flask> : 6,
};

for flask, cap in caps {
    for start in 0 .. cap {
        val name = "fill_" + flask.registryName.path + "_" + start + "_";
        val diff = cap - start;
        val levels = diff < 3 ? diff : 3;
        val fill_to = start + levels;

        if start == 0 {
            <recipetype:create:filling>.addRecipe(name + "with_potion",       withLevelPurity(flask, fill_to, Purity.clean), withLevel(flask, start),                     Fluid.potion(levels));
            <recipetype:create:filling>.addRecipe(name + "with_clean",        withLevelPurity(flask, fill_to, Purity.clean), withLevel(flask, start),                     Fluid.clean(levels));
            <recipetype:create:filling>.addRecipe(name + "with_dirty",        withLevelPurity(flask, fill_to, Purity.dirty), withLevel(flask, start),                     Fluid.dirty(levels));
        } else {
            <recipetype:create:filling>.addRecipe(name + "clean_with_potion", withLevelPurity(flask, fill_to, Purity.clean), withLevelPurity(flask, start, Purity.clean), Fluid.potion(levels));
            <recipetype:create:filling>.addRecipe(name + "clean_with_clean",  withLevelPurity(flask, fill_to, Purity.clean), withLevelPurity(flask, start, Purity.clean), Fluid.clean(levels));
            <recipetype:create:filling>.addRecipe(name + "clean_with_dirty",  withLevelPurity(flask, fill_to, Purity.mixed), withLevelPurity(flask, start, Purity.clean), Fluid.dirty(levels));

            <recipetype:create:filling>.addRecipe(name + "mixed_with_potion", withLevelPurity(flask, fill_to, Purity.mixed), withLevelPurity(flask, start, Purity.mixed), Fluid.potion(levels));
            <recipetype:create:filling>.addRecipe(name + "mixed_with_clean",  withLevelPurity(flask, fill_to, Purity.mixed), withLevelPurity(flask, start, Purity.mixed), Fluid.clean(levels));
            <recipetype:create:filling>.addRecipe(name + "mixed_with_dirty",  withLevelPurity(flask, fill_to, Purity.mixed), withLevelPurity(flask, start, Purity.mixed), Fluid.dirty(levels));

            <recipetype:create:filling>.addRecipe(name + "dirty_with_potion", withLevelPurity(flask, fill_to, Purity.mixed), withLevelPurity(flask, start, Purity.dirty), Fluid.potion(levels));
            <recipetype:create:filling>.addRecipe(name + "dirty_with_clean",  withLevelPurity(flask, fill_to, Purity.mixed), withLevelPurity(flask, start, Purity.dirty), Fluid.clean(levels));
            <recipetype:create:filling>.addRecipe(name + "dirty_with_dirty",  withLevelPurity(flask, fill_to, Purity.dirty), withLevelPurity(flask, start, Purity.dirty), Fluid.dirty(levels));
        }
    }
}

<recipetype:create:filling>.addRecipe("fill_bottle_with_purified_water", <item:minecraft:potion>.withTag({Potion: "minecraft:purified_water"}), <item:minecraft:glass_bottle>, Fluid.clean(1));
