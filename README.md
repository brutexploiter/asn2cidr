# asn2cidr
asn2cidr is a bash script that utilizes WHOIS queries to extract CIDR ranges associated with Autonomous System (AS) numbers using The Routing Assets Database.

## Installation
Clone the repository:

```bash
git clone https://github.com/brutexploiter/asn2cidr.git
```
Change into the asn2cidr directory:

```bash
cd asn2cidr
```
Make the script executable:

```bash
chmod +x asn2cidr.sh
```

## Usage
```
./asn2cidr.sh [-l <input_file>] [-i <AS_number>] [-o <output_file>] [-h]

Options:
  -l <input_file>: Specify a file containing a list of AS numbers.
  -i <AS_number>: Specify an AS number directly.
  -o <output_file>: Specify the output file to save the results.
  -h: Display this help message.
```
Query AS numbers directly:
```bash
./asn2cidr.sh -i AS6262 -o output.txt
```
Query AS numbers from a file:

```bash
./asn2cidr.sh -l asn.txt -o output.txt
```
