Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD763DCC12
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Oct 2019 18:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502658AbfJRQ6Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 18 Oct 2019 12:58:24 -0400
Received: from oc2mail2.firstquadrant.com ([209.67.156.123]:42272 "EHLO
        oc2mail2.firstquadrant.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502282AbfJRQ6X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 12:58:23 -0400
Received: from oc2mail2.firstquadrant.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 248FDAC096
        for <ceph-devel@vger.kernel.org>; Fri, 18 Oct 2019 09:58:23 -0700 (PDT)
Received: from oc2mail2.firstquadrant.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18A30AC094
        for <ceph-devel@vger.kernel.org>; Fri, 18 Oct 2019 09:58:23 -0700 (PDT)
Received: from oc2smtpsv001.firstquadrant.com (unknown [172.16.10.78])
        by oc2mail2.firstquadrant.com (Postfix) with ESMTP
        for <ceph-devel@vger.kernel.org>; Fri, 18 Oct 2019 09:58:23 -0700 (PDT)
Received: from oc2exch16sv001.FirstQuadrant.com (oc2exch16sv001.firstquadrant.com [172.16.10.141])
        by oc2smtpsv001.firstquadrant.com (Postfix) with ESMTP id 0DB2C4002861
        for <ceph-devel@vger.kernel.org>; Fri, 18 Oct 2019 09:58:23 -0700 (PDT)
Received: from oc2exch16sv001.FirstQuadrant.com (172.16.10.141) by
 oc2exch16sv001.FirstQuadrant.com (172.16.10.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1591.10; Fri, 18 Oct 2019 09:58:22 -0700
Received: from oc2exch16sv001.FirstQuadrant.com ([fe80::752d:b7b3:ae40:7f8])
 by oc2exch16sv001.FirstQuadrant.com ([fe80::752d:b7b3:ae40:7f8%2]) with mapi
 id 15.01.1591.008; Fri, 18 Oct 2019 09:58:22 -0700
From:   Dave Cox <dcox@firstquadrant.com>
To:     "'ceph-devel@vger.kernel.org'" <ceph-devel@vger.kernel.org>
Subject: OSD assertion failure
Thread-Topic: OSD assertion failure
Thread-Index: AdWF1SNXGk4ks2CWTTqgDWaZVltp2g==
Date:   Fri, 18 Oct 2019 16:58:22 +0000
Message-ID: <52ae27d425024c7298ca4edcf08de871@firstquadrant.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.10.129]
X-TM-AS-Product-Ver: IMSVA-9.1.0.1960-8.5.0.1020-24986.001
x-tm-as-result: No-10.200000-4.000000-10
X-TMASE-MatchedRID: gOUWFN6QOF+Tf4v/jNMUQ9tuAjgC5ilXG46bWbJksZUMR2L8iw5VqgnM
        2oAwE7We+cj2iOHhSkdquFFFYvJbMcw/Nd/D2H6OltBnppfPmLrmELBDcs0dnatkcxxU6EVIhlX
        4nseMMhdjOO533RcWD4LKYpEQ68PLaUFbemqf3nitY/LInB7QgWf6wD367VgthFgfIrshqgkNxr
        ynIUXvuTM7FABT0Usx1sAsJSZL0aSA1UdczcLx7kvrB8UvzFr4+eBf9ovw8I0rCui3qC5pcxvxR
        Vr8+pWOnDcxXjSfTHo2rW8Pb51lrkZHJ9MCU4VxcMsyHQ4uKnkftukM6FmmNqdz9rNdclIuo8WM
        kQWv6iVe+zdcUQFoSVcppCzPq+1U4kYXbobxJbKl/MtrTwS4UFUDEsnpRGKtDBDSi1757LXWoGa
        Qv/zNSrb57j80J25ZCDUQSyHO5RI=
X-TM-AS-User-Approved-Sender: Yes
x-tm-as-user-blocked-sender: No
X-TMASE-Result: 10--11.008200-10.000000
X-TMASE-Version: IMSVA-9.1.0.1960-8.5.1020-24986.001
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello. I have an OSD that will crash when I attempt to restart it. Since this is an assertion failure, I'm reporting it as requested in the Troubleshooting docs. If I can provide additional information, please let me know.

The crash report is below. Thank you. Dave

ceph crash info 2019-10-18_16:08:19.435100Z_45e7fad7-2834-4b5d-8c7b-bbd43bfb04a4
{
    "crash_id": "2019-10-18_16:08:19.435100Z_45e7fad7-2834-4b5d-8c7b-bbd43bfb04a4",
    "timestamp": "2019-10-18 16:08:19.435100Z",
    "process_name": "ceph-osd",
    "entity_name": "osd.1",
    "ceph_version": "14.2.2",
    "utsname_hostname": "oc2cephsv002.firstquadrant.com",
    "utsname_sysname": "Linux",
    "utsname_release": "3.10.0-957.21.3.el7.x86_64",
    "utsname_version": "#1 SMP Fri Jun 14 02:54:29 EDT 2019",
    "utsname_machine": "x86_64",
    "os_name": "Red Hat Enterprise Linux Server",
    "os_id": "rhel",
    "os_version_id": "7.6",
    "os_version": "7.6 (Maipo)",
    "assert_condition": "(uint64_t)r == len",
    "assert_func": "virtual int KernelDevice::read(uint64_t, uint64_t, ceph::bufferlist*, IOContext*, bool)",
    "assert_file": "/home/jenkins-build/build/workspace/ceph-build/ARCH/x86_64/AVAILABLE_ARCH/x86_64/AVAILABLE_DIST/centos7/DIST/centos7/MACHINE_SIZE/huge/release/14.2.2/rpm/el7/BUILD/ceph-14.2.2/src/os/bluestore/KernelDevice.cc",
    "assert_line": 926,
    "assert_thread_name": "ceph-osd",
    "assert_msg": "/home/jenkins-build/build/workspace/ceph-build/ARCH/x86_64/AVAILABLE_ARCH/x86_64/AVAILABLE_DIST/centos7/DIST/centos7/MACHINE_SIZE/huge/release/14.2.2/rpm/el7/BUILD/ceph-14.2.2/src/os/bluestore/KernelDevice.cc: In function 'virtual int KernelDevice::read(uint64_t, uint64_t, ceph::bufferlist*, IOContext*, bool)' thread 7f9da88d1d80 time 2019-10-18 09:08:19.421599\n/home/jenkins-build/build/workspace/ceph-build/ARCH/x86_64/AVAILABLE_ARCH/x86_64/AVAILABLE_DIST/centos7/DIST/centos7/MACHINE_SIZE/huge/release/14.2.2/rpm/el7/BUILD/ceph-14.2.2/src/os/bluestore/KernelDevice.cc: 926: FAILED ceph_assert((uint64_t)r == len)\n",
    "backtrace": [
        "(()+0xf5d0) [0x7f9da551c5d0]",
        "(gsignal()+0x37) [0x7f9da43132c7]",
        "(abort()+0x148) [0x7f9da43149b8]",
        "(ceph::__ceph_assert_fail(char const*, char const*, int, char const*)+0x199) [0x56297f542d43]",
        "(ceph::__ceph_assertf_fail(char const*, char const*, int, char const*, char const*, ...)+0) [0x56297f542ec2]",
        "(KernelDevice::read(unsigned long, unsigned long, ceph::buffer::v14_2_0::list*, IOContext*, bool)+0x8ee) [0x56297fc3eaae]",
        "(BlueFS::_read(BlueFS::FileReader*, BlueFS::FileReaderBuffer*, unsigned long, unsigned long, ceph::buffer::v14_2_0::list*, char*)+0x473) [0x56297fbf8ee3]",
        "(BlueRocksSequentialFile::Read(unsigned long, rocksdb::Slice*, char*)+0x34) [0x56297fc21014]",
        "(rocksdb::SequentialFileReader::Read(unsigned long, rocksdb::Slice*, char*)+0x69) [0x56298024ffe9]",
        "(rocksdb::log::Reader::ReadMore(unsigned long*, int*)+0xd8) [0x562980150788]",
        "(rocksdb::log::Reader::ReadPhysicalRecord(rocksdb::Slice*, unsigned long*)+0x70) [0x562980150880]",
        "(rocksdb::log::Reader::ReadRecord(rocksdb::Slice*, std::string*, rocksdb::WALRecoveryMode)+0x111) [0x562980150b11]",
        "(rocksdb::DBImpl::RecoverLogFiles(std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned long*, bool)+0x145a) [0x5629800f944a]",
        "(rocksdb::DBImpl::Recover(std::vector<rocksdb::ColumnFamilyDescriptor, std::allocator<rocksdb::ColumnFamilyDescriptor> > const&, bool, bool, bool)+0x809) [0x5629800fac59]",
        "(rocksdb::DB::OpenForReadOnly(rocksdb::DBOptions const&, std::string const&, std::vector<rocksdb::ColumnFamilyDescriptor, std::allocator<rocksdb::ColumnFamilyDescriptor> > const&, std::vector<rocksdb::ColumnFamilyHandle*, std::allocator<rocksdb::ColumnFamilyHandle*> >*, rocksdb::DB**, bool)+0x1a4) [0x562980108624]",
        "(RocksDBStore::do_open(std::ostream&, bool, bool, std::vector<KeyValueDB::ColumnFamily, std::allocator<KeyValueDB::ColumnFamily> > const*)+0x214a) [0x56297fb8e4da]",
        "(BlueStore::_open_db(bool, bool, bool)+0x1f05) [0x56297fadf775]",
        "(BlueStore::_open_db_and_around(bool)+0x44) [0x56297fafbc04]",
        "(BlueStore::_mount(bool, bool)+0x6a4) [0x56297fb394a4]",
        "(OSD::init()+0x3aa) [0x56297f6ae12a]",
        "(main()+0x14fa) [0x56297f54698a]",
        "(__libc_start_main()+0xf5) [0x7f9da42ff495]",
        "(()+0x568615) [0x56297f63e615]"
    ]
}
