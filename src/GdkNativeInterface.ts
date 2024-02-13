// this represents the native module type
import type * as GDK from "./types"


export interface GdkNativeInterface {
  generateMnemonic12: () => string
  init: (log_level: "debug" | "none") => void
  createSession: () => void
  connect: (name: GDK.Network, userAgent: string) => void
  register: (hw_device: object, details: GDK.Credentials) => Promise<void>
  login: (hw_device: object, details: GDK.Credentials) => Promise<void>
  getSubaccounts: (details: { refresh: boolean }) => Promise<{
    subaccounts: GDK.Subaccount[]
  }>
  createSubaccount: (details: GDK.CreateSubaccountDetails) => Promise<GDK.CreateSubaccountReturnType>
  getReceiveAddress: (details: {
    subaccount: number
    is_internal: boolean
    ignore_gap_limit: boolean
  }) => Promise<GDK.ReceiveAddressType>
  addListener: GDK.NotificationHandler
  removeListener: (evt: GDK.EventType) => void
  validateMnemonic: (mnemonic: string) => boolean
  getTransactions: (details: GDK.GetTransactionsReq) => Promise<{ transactions: GDK.Transaction[] }>
  getUnspentOutputs: (details: GDK.GetSubaccountReq) => Promise<{ unspent_outputs: GDK.UnspentOutput[] }>
  getFeeEstimates: () => Promise<{ fees: number[] }>
  getPreviousAddresses: (details: { subaccount: number }) => Promise<GDK.GetPreviousAddressesRes>
  getMnemonic: (details: { password: string }) => Promise<GDK.GetMenmonicReturnType>
  setPin: (details: { pin: string, plaintext: GDK.Credentials }) => Promise<{ pin_data: GDK.PinData }>
}
