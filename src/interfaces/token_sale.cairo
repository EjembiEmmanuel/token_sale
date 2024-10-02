#[starknet::interface]
pub trait ITokenSale<TContractState> {
    fn mint(ref self: TContractState, amount: u256);
}
