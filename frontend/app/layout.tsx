import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "FHE Wish Pool",
  description: "Make encrypted wishes on the blockchain with FHEVM",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="zama-bg text-foreground antialiased">
        <div className="fixed inset-0 w-full h-full zama-bg z-[-20] min-w-[850px]"></div>
        {children}
      </body>
    </html>
  );
}
