#[starknet::contract]
mod TokenSale {
    use core::num::traits::Zero;
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use starknet::{get_caller_address};

    use token_sale::interfaces::token_sale::{ITokenSale};

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let name = "TokenSale";
        let symbol = "TS";

        self.erc20.initializer(name, symbol);
    }

    #[abi(embed_v0)]
    impl TokenSaleImpl of ITokenSale<ContractState> {
        fn mint(ref self: ContractState, amount: u256) {
            let caller = get_caller_address();
            assert(caller.is_non_zero(), 'Zero address caller');

            self.erc20.mint(caller, amount);
        }
    }
}
