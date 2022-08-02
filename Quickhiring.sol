// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.15;

interface IQuicksort {
    function quicksort(uint256[] calldata input) external pure returns (uint256[] memory result);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

// Hiring process with a quicksort contest
//
// Objective: the most gas efficient pure sorting function
// Rules:
// - The contest lasts for `CONTEST_PERIOD`, and an additional `CHALLENGE_PERIOD` for challenge time.
// - During the contest period, anyone can use the `qualify` function to submit a new porgram.
// - There is an entrance fee of `ENTRANCE_FEE` for the qualification.
// - The program that uses less gas than the previous program is the new "top gun".
//   - There is a gas limit of `GAS_LIMIT` of how much gas the sorting function can use.
// - The test input for the program is always the same.
// - The contest starts with a baseline pure recursive succinct quicksort algorithm as the "top gun".
// - The top gun can be challenged with a counter example, to prevent spams of any non general solutions.
//   - The top gun busted will cede the top gun position to the previous top gun.
// - The challenge examples are limited to `SAMPLE_LIMIT`, so that `GAS_LIMIT` could be met.
// Result:
// - After the `CONTEST_PERIOD`, there is still a `CHALLENGE_PERIOD`.
// - After the `CHALLENGE_PERIOD`, the top gun application can collect both coins and erc20 tokens in the contract.
// Note:
// - There are myriads of view functions for testing purpose, read the source code!
contract QuicksortContest {

    // baseline quicksort
    SuccinctQuicksort public baseline = new SuccinctQuicksort();

    // to generate new sequence: `$ for i in `seq $(( 100 * 32 ))`;do printf '\\x%0x' $(( $RANDOM % 256 ));done`
    bytes public constant seq = "\x28\x2a\x4b\x86\x9b\x9e\xf0\x51\x0d\x8a\xbd\x0a\xd0\x76\x0a\xa2\x69\x57\x5e\x43\xd1\xd0\x01\x99\x23\xe0\x16\xed\xad\xf1\x51\x2b\xc1\xcc\x83\x3c\x13\x80\xcc\xf6\x5b\x1b\x00\x02\x3a\x73\xb5\xba\xe7\x56\x96\x79\xec\xb9\xad\x13\x79\xcf\x19\x45\x9c\x23\x60\xfb\xa1\x70\x65\x35\xd9\xcf\x05\xbe\xb4\xab\x9d\xbf\xa0\x6a\x11\xcd\xb6\x69\x36\xd0\xcf\x98\x90\x1c\xa3\x3f\x12\xc5\x61\x34\x84\x07\xe1\xcc\xca\x14\xe8\x76\x19\xcf\x48\x43\xc1\x23\xa6\xbb\xad\x6d\xaa\x39\xfb\xde\x70\x6d\x1e\x4a\xc7\x40\x1e\x33\x32\xb0\x63\xbd\xc4\xcc\x4d\xb9\x4c\xff\x41\xca\xf6\xdc\x3a\xf9\x79\x2d\xf2\x78\x4d\x3a\xb9\x0f\xc4\xb6\x0c\xa1\x4c\x6d\x62\x92\x6b\x48\x0e\x16\x60\xf0\x29\x5f\x6a\x55\x7a\xcd\xce\x13\xf0\xb4\x33\x76\xef\xde\x76\xce\x3f\x14\x1d\x1d\x8f\xdf\xd2\xed\xdd\x1c\x5c\x34\x08\x56\xbe\x87\x4d\x3a\x7a\x07\xe2\x1c\x79\x43\x45\x31\x83\x8b\xe4\xce\x5d\x5e\xdd\x30\x6c\x9e\x18\xc2\x1b\x9b\x8d\x4b\x80\xfe\xc1\x11\x2d\x28\x65\x0d\x23\xb6\x72\x5f\xa0\xac\x06\xe1\x80\x5b\xef\x33\xb1\x0a\xf8\x5b\xa1\x60\x94\xf7\xb6\x44\x90\x60\xe7\x08\xfa\xa0\x26\xb1\xf0\x07\xca\x7c\xc8\x1e\xaa\x71\x64\xa2\x44\x4a\xc0\x87\xce\x9b\x11\x90\xbf\xc1\x79\x2f\xdb\x1b\x06\x26\x45\x56\x56\x64\x71\xe5\xb7\x09\xa0\xe4\x58\x8d\xdf\x68\xf7\x8b\xb3\x9e\x5a\x46\x6b\xac\xcb\x6b\x17\x9a\xae\x17\x28\xc4\x23\xbb\x0f\xff\xe7\xd5\x2a\x39\xb2\xfe\x0b\x96\x95\x4e\xd2\x51\x63\x86\x9c\x30\xc9\xf8\xa7\xcc\xdf\xfb\xdd\x60\xed\xef\xdd\xb7\x74\x1e\x8a\xdf\xe1\xd2\x5e\x5a\x99\xfb\xa1\x86\xf6\x46\x58\x3c\x8b\x44\x63\xed\x8d\xf3\x1d\x10\x20\xe6\x47\xe0\xc4\xce\x7d\x55\x61\x93\x2e\x6f\xea\xa7\xc8\x94\x41\xc2\x95\x21\x9c\x44\x98\x7e\x2f\x2d\xee\x1a\x76\x85\x31\x80\x36\xe7\xa9\xe2\xeb\x5b\x89\xa2\xb3\xea\xa0\x7f\x89\x6b\x89\x53\x72\x31\xd0\x10\xf1\x93\x77\x12\xa3\x8b\x3d\x7e\xd4\x44\xb4\x74\x66\x16\xc2\xd3\x23\x21\xb6\xd8\x5c\x89\xe5\x81\x33\x4f\x98\x50\xb4\x36\x1c\x00\x6c\x6e\x4a\x2c\x20\x1e\xfa\x4c\x30\x0c\x9b\x54\x6c\x1d\x95\x57\xe8\x36\xd5\x49\x7d\xcd\x5a\x3f\x82\x8b\xad\x0f\x48\x46\x22\x48\x85\xc1\x20\x69\x88\x80\x5d\x24\xbc\x59\x2d\x1d\x58\x31\x67\x76\x57\x3e\x42\xcb\x1b\x2a\x40\xf9\x21\xe9\xdd\xb7\x38\x24\x68\x7a\x27\xee\xfc\xbf\x6a\xa6\xf0\x20\x46\xa0\x31\x11\x1e\xf8\x00\x4a\xfa\x18\xeb\x5a\xb6\x66\xa7\x2b\x36\xbf\xf8\xbf\xf9\xac\x52\xbf\x3d\xac\x65\x85\x30\xe0\x7b\x0b\xa5\x1f\xc1\x5a\x47\x94\x25\x33\xc5\x5b\x28\x82\x30\x28\x06\xc4\x22\x95\x31\xff\xe5\x59\x22\x28\x53\x6c\xe2\x74\x19\x6e\xda\xce\xa6\x59\x77\xc1\x6d\xb3\x98\x70\x9a\xe2\xe8\xe1\x8f\x61\x0d\xdd\x8c\xb9\x9c\xa7\x73\xaa\xfe\x57\x6f\xc3\xca\xbe\xfb\x10\x82\x46\xda\xda\x8d\x94\x78\x51\x7c\x94\x93\x5a\xc8\x80\x5d\xfb\x1e\x29\x3b\x41\xfc\x33\xdc\x54\xf8\x2f\x98\x11\xa3\x3a\x89\xf6\xf2\x80\x8f\x30\x34\x48\x9f\x58\x51\xb4\xd9\x76\x02\x97\x46\xd7\x20\x73\xd0\xca\xca\xdc\xd1\x24\x98\x4a\xe7\xf9\x04\xb7\x6d\xb7\xea\x9c\xf0\x99\xad\xad\xc6\x91\xdd\x51\x91\x7f\x14\xd1\xe5\x72\x4c\x78\xa7\xd2\x1a\x75\x2e\x7e\x26\x13\xf4\xdf\x59\xd9\x43\xc7\x53\xec\x5d\xa4\xea\xc3\xee\xe8\xe3\x93\xb3\x89\xcd\x48\x3d\x90\x4b\x3d\x19\x4d\x24\x5b\x21\xec\x88\x15\x26\x49\xa4\x2e\x07\x71\x67\x10\x41\x6d\x06\xe4\x11\x8a\x41\x4f\x74\x6c\x4c\x74\x66\x65\xe9\x94\xe8\x09\x15\xa4\x81\x83\xef\x2d\xb0\xdc\xb4\x92\xa3\x6f\x39\x52\x9c\x1d\x79\x3d\xf8\xa0\x55\xeb\x71\xb3\x9c\xcd\xd9\x24\x60\xe3\x92\xdd\xec\xc4\x27\x3c\x09\x35\xdc\x1e\x5a\xd9\xe9\x1c\xa1\x3c\x00\x27\xde\x66\x15\xaf\x32\x05\xb2\xf6\x1d\xa0\x60\xa1\xc0\x6d\xb0\x6b\xcd\xb9\x31\xff\x94\xa4\x9b\xee\xd7\x90\xa8\x5c\xb7\xfe\x92\x13\x51\x06\xd4\xec\x38\x42\xce\xf6\xf9\x69\x40\xda\xa6\xe8\x1d\xae\xe8\x55\xda\xf4\x97\x1e\xe1\xf1\xae\xce\xa8\xe9\x9a\x5b\x09\x52\x8b\xca\xde\x3b\x59\xf1\xbd\xe5\xfa\x99\x25\x91\x32\x8e\xa3\x82\x9d\x64\xfc\xd9\xbe\x22\x1c\x33\x9e\x2f\x0a\x6c\xce\x58\xb1\xee\x1c\x42\x84\x7b\x8c\x5c\x7b\x41\xac\xfe\xb2\x92\x72\xa2\xc4\xc3\x24\x36\xf7\x6d\x3d\x84\xc0\xe0\x86\x90\x56\xde\xee\xb9\xcf\x34\xc4\x5c\xfc\x0b\x05\x0f\x7d\xd0\xfe\xbe\x42\x10\x3e\xf2\x91\xca\xbc\x17\x5f\x7a\xbd\x6a\xe5\x18\x1d\x10\xd5\xe3\x56\x82\x08\xda\xb4\xa3\xc8\x9f\x24\xa9\x7f\xd1\x73\x8f\xd6\x37\x38\x66\x04\xb8\xba\x79\x0b\xe2\x4d\x68\xcf\x3f\xf7\x89\x1d\xd1\xd1\xfc\x2f\xb7\x2f\x6a\x6d\x41\xb4\xba\xaa\x4c\xbd\x71\x42\xe2\xfa\xe1\x4e\x08\x9d\xe8\x95\xa7\x7a\xf7\xd7\xd9\xf7\x53\xf8\x87\xaa\x3c\x89\x0e\x4f\xff\x6b\x9c\xc3\x35\xeb\x9c\x82\xf4\xbb\xca\xb8\x61\x15\xa2\x0c\x5e\xe2\xd9\xbb\x28\xab\x71\x7c\x13\x62\xac\x25\xb9\x30\xc2\x87\x50\x74\x3b\xaa\x9a\x99\x5f\xfb\xf7\xfa\x35\xf2\xd4\x11\x9a\xc9\xa4\x72\x54\xa0\x07\xde\x35\x12\x69\xd4\x53\x60\xe4\x5e\x67\x23\x1c\x68\x96\x56\x4c\x22\x89\x51\xab\x0b\x18\x9a\x0f\x1f\xb8\xd7\x08\x9f\xd8\xba\xa4\xb1\xfe\x79\xea\x4e\xf3\xa4\xc7\xae\xe1\x68\xa3\x98\xe2\x4f\xa2\x74\x25\x8c\x28\xae\x3b\xe5\xac\x07\xfd\xf0\x69\x41\xb3\x78\x11\x0f\xe2\xff\x38\xc4\x9b\x3c\x8a\x0e\x69\xc0\xd4\xf5\x54\x21\x79\x4a\x7c\x37\xd3\x46\xdb\xa7\x41\x46\xf2\x88\x6c\xe9\xbb\x68\x01\xc7\xe4\x44\x37\xee\x53\xd1\x21\x45\x68\xc4\xbf\x91\xa5\x7f\x2f\xc6\xcb\x27\x58\xee\x73\xcb\x00\xb0\x2f\xcf\x67\xec\x69\xbb\x21\x3b\xc6\x59\x6a\xbd\x8e\x51\x91\x86\x97\xb4\xee\x79\xb6\x3a\x71\x4d\x0e\x59\xcb\x33\x41\x9c\x21\xb4\x0f\x90\x8e\x3b\x64\x06\x82\x49\x3c\x15\x4e\xff\x40\xc3\x0f\x11\xf2\x94\x36\xee\xcd\xb3\xbe\x0a\xfc\x2f\x0f\x3a\x3b\x6c\x19\xfc\xc4\x94\xc0\xb0\x46\x8b\xf1\xc3\xb4\x39\x6d\xa9\x8b\xc8\xb5\xc8\xfd\x58\xba\xd2\xa0\x34\xe1\xc7\xa2\x1d\x52\x0d\x81\x5d\x38\xd0\x14\x36\x13\x4d\xb3\xcb\x85\x20\x12\xa9\xf9\x9c\xf2\xe4\x4b\x28\x73\xe9\xd7\xad\xe2\x6b\xb5\x50\x45\xf0\x9c\x49\x29\x74\xf4\x99\xdd\x43\xb6\x80\x8d\x66\x3c\x0a\x70\x37\x99\xe3\x5d\x68\x62\xf6\x27\xaa\x3e\x31\xc2\x8d\xaa\x86\xbf\x15\x4f\xb0\xf4\xfd\x8b\xb3\x10\xe3\x30\x5d\xbf\xe5\xaf\x44\x0e\xb7\x39\xf2\xe5\x68\x4f\xa3\xe1\xf4\xa4\xb3\x4d\x08\x45\x24\x16\xdf\xb1\x40\x46\xbd\xf8\x66\x46\xbe\x5e\x6e\xc1\xf8\x28\x24\xb8\xa3\x87\x39\xc9\xbd\x82\xd5\xc4\x77\xa0\x83\xe3\x59\xe5\xd3\x6a\x57\xde\xe5\x97\x9c\x51\xd1\xfb\xb5\x0c\xcc\xbe\x1c\xfc\xbe\xce\x18\x52\x8a\xae\x81\x47\x36\x05\x91\xf6\x69\xc1\xc8\x35\x75\x91\x2b\xae\x53\xfe\xb4\x58\x52\x44\xbf\x7a\xd4\x62\x1f\x35\xf7\x32\x48\xc5\x27\x03\xe5\xf6\xcd\xff\xaa\xd8\xbb\x38\x4f\x7f\x65\x86\xf6\x79\xfa\x8a\x30\xd9\x9a\x0f\x25\x77\x59\x5a\xad\xe5\xd9\xe3\x6e\x26\x57\x8f\x15\xf3\xbd\x50\xae\x7b\xf3\xb7\x37\xa6\xc4\xad\x5a\x8e\x40\xff\xd5\xe4\xa1\x96\xd0\x63\xc3\xe5\x03\xe5\x84\xea\xfe\x5b\x6b\x1a\x78\x72\x3c\xea\xe9\xc3\x91\x5e\xe8\x42\x5d\x89\x29\x75\x47\xe4\xc3\x4c\x24\xc4\x95\xd2\x5f\xc2\x2a\xb9\xcf\x23\x73\x1f\x98\xcf\xd1\x23\x9d\x99\x52\x60\x48\x38\x40\x1e\x51\x7f\x47\xc8\xc3\xcd\x84\x12\x8c\x28\x02\x58\x0e\x4a\x5a\x6a\x2e\x82\xeb\x30\x9c\xc6\xe0\x55\x6e\x47\xe9\x18\xd4\xf5\x8f\x09\x5c\x05\x80\x03\xf0\x1e\xbb\x0e\xc7\x76\x3b\xd6\x07\x6b\x71\x23\xfd\x78\x3c\xe3\x71\xe2\xa6\xd8\xe9\x38\xc0\x4b\xdf\x8f\xfc\x7e\xc6\x6d\xbd\xc1\xcf\xac\x28\x3c\xb8\x9d\x92\x20\xd1\x6a\xab\xb1\xcc\xe3\x99\xe3\xf3\xd9\x22\x3f\x2b\x56\x44\x69\xc0\x6c\x40\x1e\x19\x20\xd1\x70\xf7\xc4\xaa\x47\xd6\xa6\x50\xd1\x64\x8c\x00\xab\x64\x42\x46\x30\xec\xfc\x01\x9f\x72\x58\x0c\x7c\xc4\x81\xd5\xf7\x86\xcd\xe1\x61\xc1\x36\xeb\xc6\xa5\x09\x49\xea\xf5\x89\x22\x78\xd1\xf8\x25\xda\x6a\x1c\x81\x88\x1e\xef\xd1\x2a\x81\xe9\xdc\x2f\xb7\x1f\x28\xf8\x18\x09\x9f\x3f\xea\xe4\xa8\xdb\xe2\xf3\x37\x47\x6c\xbb\x25\xb5\xa7\xc6\x23\xe9\x0a\x98\x43\xd0\x40\x96\x58\x5b\x9e\x67\x21\x15\xf9\x16\x3f\xd8\x07\x4d\xbe\xec\x88\x84\xea\x67\x6f\xdc\xc5\x97\xfb\x58\x60\x7c\xb1\x4a\x5c\x42\xfa\xca\x0e\x3b\x2b\x1b\x2c\x55\xbe\xd5\x4d\x6e\xf1\xa4\x65\x53\xa5\x01\x11\x6d\x56\x50\x0f\x24\xae\xcf\x8e\xd2\xac\x08\x55\xf5\x7b\xfd\xa8\x97\xd7\xd3\xc6\x89\xa4\x83\xae\x9f\xfd\x83\xe5\x84\x1d\x68\xdf\x8a\x85\x38\x27\xef\x7d\x2e\xaf\x64\x9f\x61\xb0\xe1\x5b\x32\x46\x39\xd9\xc7\xf2\x02\x11\x27\xd4\x60\x8c\x51\x38\x67\x84\x47\x51\x6a\x7d\xca\x2c\x51\xea\xf4\x3a\x5b\xdb\x1c\x9f\xc8\x69\xad\xa4\xc5\x7f\x3e\xe7\xc8\x0e\x1e\x03\x41\x5c\x44\x64\xb7\x5c\xa9\xdf\x7f\xb4\xd9\x31\x5f\x8e\x2e\x8f\x12\xd1\x14\x99\x76\xd3\xb7\x57\x72\x60\xef\x65\xcf\x1f\xd3\x99\xe0\x55\x31\xa5\xfd\x03\x12\x83\xc0\x66\xa2\x41\x26\x94\x6f\x0d\x0e\xd7\xf7\x26\x6a\xa2\x10\x6e\xb9\xaf\x34\x16\x1a\x61\x91\xf1\xff\x5f\x37\xa6\x14\x19\x12\xf9\xd1\xa8\x69\xdb\xa4\xa3\x0a\xde\x9f\xec\xa7\x7e\x36\x0e\xa5\x8d\xd5\xe1\xa5\xff\xe4\xdb\xb5\x6f\x09\x0b\xf5\x4b\x93\xaa\x82\xcf\xeb\x71\x5f\x46\x95\x94\x43\xa7\xbe\x43\xf6\x8a\x36\x34\x04\xc4\x77\xe3\x3b\xbd\x98\x33\x29\x26\xb9\x28\xb9\x4c\x2d\x4a\x75\xa4\x25\x3b\xfd\x4f\x76\x7d\xa9\xef\x84\x6a\x49\x31\x79\x9f\xe8\x4a\x10\x7d\xd9\xaf\x81\x1b\x86\xb0\x0b\x2f\xe0\x75\x97\x46\x0c\x1c\xca\xd8\xf5\x80\x2e\x9f\xbc\x9f\x4a\x86\x25\x38\xd9\x89\xba\x50\xa8\x56\xff\x32\x7c\x87\xe5\xc8\x59\x44\x6b\x17\xc9\x43\xfe\x3a\xb5\x99\x49\x88\x71\x31\xf2\x10\xd3\xc9\x88\x9d\x8a\x2d\x76\x0b\xc8\x70\x78\x20\x49\x27\x4a\x2b\x1f\x5d\x9f\xdd\x8e\xee\x39\x21\x7a\x7e\xe5\xa8\xc6\xc1\x90\x74\x96\xa8\xa3\xa0\x88\xe0\x44\xf1\x31\xc8\xc1\x46\x13\xa7\x66\x32\x21\x3f\x4c\xaa\xa0\x8d\x21\x0d\x3a\x61\x3d\x91\x68\x55\xab\x5f\x3e\xe3\xdb\x2f\x15\x13\xfc\x70\xcc\x62\x77\x5f\x9a\x65\x12\x84\x4a\xf3\x50\x2c\x6e\x58\x58\xee\x11\x8d\x0e\x83\x8c\xec\x35\x99\x2f\xcc\xed\x95\x08\x85\xc5\x1f\x2a\x7b\xc9\x10\x81\xad\x26\x50\xca\xe3\x96\x94\xa6\xee\xdd\x86\x19\x37\x89\xeb\x02\xe7\x0f\xfb\xf4\x64\xe5\x2d\x8c\xe0\xc1\x90\xe0\x6a\x81\x85\x19\xe3\x39\x1f\x0a\xc8\xdf\xab\x7a\xce\xfa\x0b\xf5\xb0\x00\x24\x01\x6f\x59\x00\x9a\x8a\xa5\xa3\x81\x58\xa9\x4a\x83\x12\xec\x54\x44\x5f\x16\x08\x16\xeb\xaa\xe5\x32\x8e\xe1\xb9\x90\x24\x91\x0b\x44\xc1\x99\x69\x4f\x61\x09\xfb\x85\x9b\x91\x0a\x28\xfb\xf8\xd2\xa7\xc9\x75\x3b\xeb\x88\x6f\x04\x0b\xc9\x30\xc2\xe9\xd5\x99\x2c\x42\x75\xc7\x7a\x29\x82\xa8\xc8\xa5\x84\x6f\xed\xca\xa0\x1f\xa7\xa7\x84\x97\x18\xb5\xfa\xb0\xc8\x5a\x32\x31\xe1\x6c\x96\x7a\x55\x5d\xc7\xe4\xd7\x8c\x11\xa0\x36\x8e\x8c\x6c\x90\x08\xaa\x23\x65\xf4\x18\xa9\x4f\xa7\x47\x3b\xcf\x92\x75\x91\xa8\x02\x19\xe4\x9d\xb7\x56\xe4\xfd\xe8\x60\xcd\xf5\x38\x46\x19\xfc\x60\x4e\x3c\xc6\x21\x22\x2a\x79\x21\x6d\x09\x29\x15\xa6\x90\xdd\xda\x26\xe8\xe1\xf2\x30\x0d\xc5\x67\x04\x03\xff\xf1\xa8\x7a\xbb\x09\x98\xb1\x15\x3c\x97\x1a\x70\x88\x4e\x35\x85\x9e\xe9\x49\xff\x08\x4b\xf7\x5e\x77\xef\x3f\x67\x05\xb2\x04\x54\x5e\x3b\x36\x41\xbf\xc4\x47\x1f\x25\x3c\x50\xd3\xb0\xca\xa6\xc2\x55\x95\xef\x76\x82\xfd\x6b\xb5\x4b\x0d\xdb\x01\x5b\x48\x77\xc6\xc7\x17\xaf\x00\xbf\x4d\x47\x97\xe0\x90\xf1\x0a\x24\xba\x22\x2d\x6a\x88\xd6\x0a\xca\xaf\xa0\x2e\xa6\xa8\xf6\x76\xf3\xf2\x68\x1a\xc4\xa1\x4f\x3a\x32\xb9\xe9\x57\xf1\xa2\x84\xec\xbb\x07\x8b\xfb\x4e\xf1\x5c\x90\x09\x50\x38\xbf\xfe\x36\x89\xc2\xdf\xeb\x91\x0f\xc4\x24\x5e\x3f\xc0\x53\xa0\xd4\x94\x4d\xcb\x25\x68\xa1\x7c\x62\x12\x6a\xda\x6e\x46\xc6\x09\xaf\xa9\x5d\x6f\x35\xbd\x91\xd8\x22\xc3\xb2\xd8\xcb\x3d\xab\xbf\x8d\xfb\xae\xbb\xc0\x68\x40\x60\x0a\xfb\x1b\x0b\xc9\x99\xa7\xa2\x6a\x90\x01\x73\xce\x6b\x80\xdf\xdd\x87\x6d\xbe\x6a\x12\x56\x86\xf8\x5b\x89\x39\xf5\x2a\xab\xce\x66\x67\xb3\x4e\x17\xee\x4e\x77\x4c\x14\x7d\x14\x06\x38\xc9\x40\x46\xd6\x94\x25\xd1\x58\xfe\x8e\x38\x40\xe4\xfa\xad\x07\x36\xdb\x07\x7c\xdb\x45\x96\xf3\x13\x58\xc7\xbd\x5d\x5b\x2c\x36\x1e\x09\xac\x68\x80\x63\xea\x6f\x5b\x78\x6c\x19\xb0\x3e\x8a\xf9\x68\x22\xb5\x20\x4e\x0f\xfd\xd3\x78\xd7\x13\x56\x22\xaa\xb4\xba\xd2\x52\x82\xe5\xfe\x93\x67\xaa\xe4\xe6\x5d\x16\xcd\xac\xee\x66\x86\x85\x00\x66\xa1\x62\xa0\x72\xb1\x22\x64\x2e\x99\x85\x90\x3f\x6f\xbb\xd8\x94\xa1\x8e\x79\x12\x34\x3b\xc1\xb3\x45\x50\xe5\x78\xc7\xeb\x86\x66\x14\x8d\x3c\x9a\x23\xa7\xe3\x93\xa0\x52\xee\xd2\xf9\x3d\xaa\xcd\x75\x20\xf6\x34\x32\xcb\x98\x28\x9e\xc8\x20\x40\xfe\x9b\x4c\xef\xc2\xa6\x34\x0f\xb6\x83\x3e\xcf\x86\xbb\x8a\x00\x79\x05\x31\xe2\x70\x19\xdc\x4e\xc3\x63\x46\xee\xcb\x2b\xed\x37\x52\x96\x0f\x94\x4f\x6a\xbf\x6b\x56\xee\x7f\x51\xb8\xa0\x1a\x60\x4a\x18\xaf\xc7\x0a\x9d\x4f\x2a\xcc\xa5\x67\xb5\x4e\x8e\x8e\x8c\x9f\xb8\xba\x2e\x08\x12\x06\x00\x38\x8a\x40\x37\x27\x42\x00\x74\x8d\xca\x4c\x8d\xb0\xf4\xc8\x93\xe4\x6e\x9b\x95\xb3\x10\x30\xaf\x3a\x22\x3a\x2b\xfc\xc2\x47\xff\x42\x9d\xdf\xee\xd3\x6a\x9f\x14\x86\x6a\x7f\xa2\x1a\x9f\x09\xd7\xf2\xd7\x5e\x06\x32\x0d\x53\x4f\xf6\xe3\x02\x97\x90\xca\x18\x3f\x92\xcb\x7c\x57\x6b\x52\x44\x5e\xb7\x02\x79\x7f\x13\x92\x53\x27\xd4\xc5\x6c\x6b\xf5\x49\x6e\x93\x3c\x13\x80\xe1\xf5\xaa\xa8\x6b\x04\xfc\x3f\x70\xff\x5e\x1c\xee\x4a\x2a\x38\x0f\x01\x13\xd6\xbb\xbd\x8d\x79\x4c\x6c\x56\x2e\x5d\xc9\xc5\x8d\xd3\x96\x50\xd2\xbd\x8c\x65\x9a\xf4\x4f\x90\x58\x3f\xcf\x18\x1a\xa0\x6a\xea\xb6\x31\xae\xfd\xd6\x63\x00\x26\xd9\x75\xe1\x90\x1e\x5b\x05\x66\x38\x90\x05\xe3\xb3\xe6\x40\xbe\x4d\x3b\xd8\x3d\x4a\xca\x5e\xeb\xe4\xdc\x45\x78\x7b\xa0\xe3\xa8\xe8\x64\x7f\xa9\x0c\x83\xba\x8d\x8a\x3c\x3c\x34\x81\x21\xef\x7f\x8c\xdc\x0c\xd3\xb2\xcf\xa6\x03\x50\xed\xe9\x7b\x7a\x00\x29\x1a\x83\x50\xd7\x23\x3e\xdf\x2b\x83\x5e\x5f\xe2\xa8\x5d\xf7\x4a\x8f\x3f\x0c\xd6\x80\xfa\xf4\x0d\xc7\x81\xc4\x1c\xd3\x3b\x78\xdf\xfe\xfc\xae\x56\x0c\xfb\x8b\x84\x1c\xa7\x7b\x12\x1c\xf1\xc1\x12\x2d\x8e\xea\xdd\xd8\x43\x17\xdf\xcc\xa8\xdb\xb8\x2d\x8f\xe4\xcb\xed\x91\x62\x60\x68\xe9\x41\x0d\x66\xa1\x3f\x44\xae\xa6\xe2\xf6\xce\x80\xc2\x14\x88\x04\xcc\x3a\x34\x20\x28\x8e\xc1\x39\x6d\x23\x6c\xf0\xe6\xf8\x40";

    // if you burn more gas than this, I don't know what are you doing with your life!
    uint public constant GAS_LIMIT = 4e6;

    // let's prevent challenge from unfair difficult problems.
    uint public constant SAMPLE_LIMIT = 500;

    // no spam, bust it!
    uint public constant ENTRANCE_FEE = 10e18;

    // time is limited!
    uint public constant CONTEST_PERIOD = 2 weeks;

    // it's time to bust as many bad topguns as possible!
    uint public constant CHALLENGE_PERIOD = 1 weeks;

    // end date!
    uint public immutable END_DATE;

    constructor() {
        END_DATE = block.timestamp + CONTEST_PERIOD;
        contestants.push(Contestant({
            applicant : msg.sender,
            program: baseline,
            gasUsed: GAS_LIMIT // well, don't bother with the real number, it's less than this
        }));
    }

    struct Contestant {
        address applicant;
        IQuicksort program;
        uint256 gasUsed;
    }

    Contestant[] public contestants;

    event NewTopGun(address indexed applicant, address indexed program, uint256 gasUsed);

    event Busted(address indexed applicant, address indexed program, uint256[] counterExample);

    function numContestants() external  view returns (uint) { return contestants.length; }

    // marvelous 
    function topGun() public view returns (Contestant memory) {
        return contestants[contestants.length - 1];
    }

    // test your program before qualifying
    // - reason 0: wrong result, reason 1: out of gas
    function testWithInput(uint256[] memory input, IQuicksort program) public view
        returns (bool success, uint reason, uint gasUsed)
    {
        uint256 startGas = gasleft();
        try program.quicksort{ gas: GAS_LIMIT }(input) returns (uint256[] memory result) {
            success = _validate(input, result);
            gasUsed = startGas - gasleft();
        } catch {
            success = false;
            reason = 1;
        }
    }

    function test(IQuicksort program) public view
        returns (bool success, uint reason, uint gasUsed)
    {
        return testWithInput(getInput(), program);
    }

    // qualify your program, having a small fee to prevent spams
    function qualify(IQuicksort program) external payable {
        assert (contestants.length > 0);
        require(block.timestamp < END_DATE, "Contest ended!");
        bool success;
        uint gasUsed;
        (success, , gasUsed) = test(program);
        require(success, "Your program failed!");
        require(gasUsed < topGun().gasUsed, "Your program used more gas than the top gun!");
        contestants.push(Contestant({
            applicant: msg.sender,
            program: program,
            gasUsed: gasUsed
        }));
        emit NewTopGun(msg.sender, address(program), gasUsed);
    }

    // try to bust with random samples
    function tryBust(uint n) public view returns (uint256[] memory example, bool busted) {
        Contestant memory top = topGun();
        example = new uint256[](n);
        for (uint i = 0; i < n; ++i) example[i] = _random(i);
        bool success;
        (success,,) = testWithInput(example, top.program);
        busted = !success;
    }

    // try to bust with random samples
    function tryBust() external view returns (uint256[] memory example, bool busted) {
        // 10 to 20 elements
        uint n = _random(0) % 10 + 10;
        return tryBust(n);
    }

    // bust the current topGun with a counter case!
    function bust(uint256[] memory counterExample) public {
        require(contestants.length > 1, "Don't bust the baseline!");
        require(block.timestamp < END_DATE + CHALLENGE_PERIOD, "Challenge period ended!");
        require(counterExample.length < SAMPLE_LIMIT, "Unfair difficult challenge");
        Contestant memory top = topGun();
        (bool success,,) = testWithInput(counterExample, top.program);
        require(!success, "Not busted!");
        emit Busted(top.applicant, address(top.program), counterExample);
        contestants.pop();
        // reward for busting
        payable(msg.sender).transfer(ENTRANCE_FEE);
    }

    // bust the current topGun automatically with a counter case!
    function autoBust() external {
        // 10 to 20 elements
        uint n = _random(0) % 10 + 10;
        uint256[] memory example = new uint256[](n);
        for (uint i = 0; i < n; ++i) example[i] = _random(i);
        bust(example);
    }

    function collectNativeCoin() external {
        require(block.timestamp > END_DATE + CHALLENGE_PERIOD, "Until challenge period finishes!");
        Contestant memory top = topGun();
        require(top.applicant == msg.sender, "Don't be a bad loser!");
        payable(top.applicant).transfer(address(this).balance);
    }

    function collectERC20(IERC20 token) external {
        require(block.timestamp > END_DATE + CHALLENGE_PERIOD, "Until challenge period finishes!");
        Contestant memory top = topGun();
        require(top.applicant == msg.sender, "Don't be a bad loser!");
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function getInput() public pure returns (uint256[] memory result) {
        slice memory seqS = _toSlice(seq);
        assert(seqS._len % 32 == 0);
        result = new uint256[](seqS._len / 32);
        slice memory resultS = _toSlice(result);
        _memcpy(resultS._ptr, seqS._ptr, seqS._len);
    }

    // don't try this with remix js simulation, it will burn your browser
    function selfTest1() public view returns (uint256[] memory input, uint256[] memory result) {
        input = getInput();
        result = baseline.quicksort(input);
    }

    // try this instead of selfTest1
    function selfTest2() public view returns (uint256[] memory input, uint256[] memory result) {
        input = new uint256[](10);
        input[0] = 63;
        input[1] = 35;
        input[2] = 81;
        input[3] = 36;
        input[4] = 67;
        input[5] = 32;
        input[6] = 97;
        input[7] = 39;
        input[8] = 56;
        input[9] = 21;
        result = baseline.quicksort(input);
    }


    function _random(uint seed) private view returns (uint256) {
        uint randomHash = uint(keccak256(abi.encode(block.difficulty + block.timestamp + block.number, seed)));
        return randomHash;
    }

    function _validate(uint256[] memory input, uint256[] memory result) internal view returns (bool) {
        uint256[] memory correctRersult = baseline.quicksort(input);
        if (input.length != result.length) return false;
        for (uint i = 0; i < input.length; ++i) {
            if (correctRersult[i] != result[i]) return false;
        }
        return true;
    }

    // internal helpers
    // mostly copied from https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol
    struct slice {
        uint _len;
        uint _ptr;
    }

    function _toSlice(bytes memory self) internal pure returns (slice memory) {
        uint ptr;
        assembly {
            ptr := add(self, 0x20)
        }
        return slice(self.length, ptr);
    }

    function _toSlice(uint256[] memory self) internal pure returns (slice memory) {
        uint ptr;
        assembly {
            ptr := add(self, 0x20)
        }
        return slice(self.length * 32, ptr);
    }

    function _memcpy(uint dest, uint src, uint len) private pure {
        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = type(uint).max;
        if (len > 0) {
            mask = 256 ** (32 - len) - 1;
        }
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }
}

// no assembly no magic, pure gas burner
contract SuccinctQuicksort is IQuicksort {
    function _quicksortHelper(uint256[] memory input, uint start, uint len)
        internal pure returns (uint256[] memory result)
    {
        result = new uint256[](len); 

        // trivial cases
        if (len == 0) return result;
        if (len == 1) { result[0] = input[start]; return result; }

        // partitioning, always choose 1st element for pivoting
        uint j;
        uint k;
        uint256 pivotVal = input[start];
        for (uint i = 1; i < len; ++i) {
            if (input[i] <= pivotVal) {
                result[j++] = input[start + i];
            } else {
                result[len - 1 - k++] = input[start + i];
            }
        }

        // combining result
        result[j] = pivotVal;
        uint256[] memory smallerSorted = _quicksortHelper(result, 0, j);
        uint256[] memory biggerSorted =  _quicksortHelper(result, j + 1, k);
        for (uint i = 0; i < j; ++i) result[i] = smallerSorted[i];
        for (uint i = 0; i < k; ++i) result[j + 1 + i] = biggerSorted[i];
        return result;
    }

    function quicksort(uint256[] calldata input) public override pure returns (uint256[] memory result) {
        result = _quicksortHelper(input, 0, input.length);
    }
}
