import { WishPoolDemo } from "@/components/WishPoolDemo";

export default function Home() {
  return (
    <main className="flex flex-col max-w-screen-lg mx-auto pb-20 min-w-[850px]">
      <nav className="flex w-full px-3 md:px-0 h-fit py-10 justify-between items-center">
        <div className="flex items-center gap-4">
          <img
            alt="Zama Logo"
            width="120"
            height="120"
            src="/zama-logo.svg"
            className="object-contain"
          />
          <div>
            <h1 className="text-2xl font-bold text-gray-800">FHEVM Wish Pool</h1>
            <p className="text-sm text-gray-600">Privacy-Preserving Blockchain Wishes</p>
          </div>
        </div>
      </nav>

      <div className="flex flex-col gap-8 items-center sm:items-start w-full px-3 md:px-0">
        <WishPoolDemo />
      </div>
    </main>
  );
}
