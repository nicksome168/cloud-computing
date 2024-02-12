import React, { ReactNode } from "react"; import Head from "next/head";
type Props = { children: ReactNode;
};
const Layout: React.FC<Props> = (props) => ( <div>
<div className="w-full text-center bg-red-800 flex flex-wrap items-center"> <div className="text-3xl w-1/2 text-white mx-2 md:mx-auto py-5">
Inventory Data </div>
</div>
<div className="layout">{props.children}</div> <style jsx global>{`
html {
box-sizing: border-box;
}
*, *:before, *:after {
box-sizing: inherit; }
body {
margin: 0;
padding: 0;
font-size: 16px;
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji",
"Segoe UI Symbol"; background: rgba(0, 0, 0, 0.05);
}
input, textarea {
font-size: 16px; }
button {
cursor: pointer;
}
`}</style> <style jsx>{`
.layout {
padding: 0 2rem;
} `}</style> </div>
);
export default Layout;