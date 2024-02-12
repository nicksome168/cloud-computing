import React from "react";
export type InventoryProps = {
    id: string;
    name: string;
    quantity: string;
    date: string;
};
const Inventory: React.FC<{ inventoryrec: InventoryProps }> = ({ inventoryrec }) => { return (
<div
className="flex bg-white shadow-lg rounded-lg mx-2 md:mx-auto mb-5 max-w-2xl" >
<div className="flex items-start px-4 py-3">
<div className="">
<div className="inline items-center justify-between">
<p className="text-gray-700 text-sm">
<strong>ID: {inventoryrec.id}</strong> Name: {inventoryrec.name} (quantity: {inventoryrec.quantity}) </p>
<small className="text-red-700 text-sm">
Date: {inventoryrec.date.toString().substring(0,10)} </small>
</div> </div>
</div>
</div> );
};
export default Inventory;