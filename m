Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5770B4F9706
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Apr 2022 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiDHNla (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Apr 2022 09:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiDHNl3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Apr 2022 09:41:29 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B2731C426
        for <ceph-devel@vger.kernel.org>; Fri,  8 Apr 2022 06:39:25 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id t7so10560760qta.10
        for <ceph-devel@vger.kernel.org>; Fri, 08 Apr 2022 06:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poochiereds-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=mFU8Wubc6ldhfo+C+I/F3zTpnTIqmCA6VBzta5MgEv0=;
        b=zNgfN8l6NkTvw7RdW+zsUyHkDVpsxSsSPH6HCvb+79qRQB8wFok+U2qXTHaXg9aFhr
         9A78yz1yMB0Fry9YHToO7iat4PYRSzwmG9TsU6XaSpOIHbJZyp5b6i93btCSpoki4bXy
         1xX5KutWd6wMpEG/sRgEafgmZNK6JBuqrPaQhAIq6OthAjskrrgjx9zJiMLTA9Fe11kG
         tTJjW80XwqHlYwosmwcl5UcRsXmrZJLeha5ZT3iSCBN/HzdwAsnZGywNl6pCLY0bzyNn
         ZMbB4DhgG58vh68y4j1ILIZxDsvOWhUGwOq2mIhK2/ehvih+WJxgAt0tMKN+h9rF3bNP
         h3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mFU8Wubc6ldhfo+C+I/F3zTpnTIqmCA6VBzta5MgEv0=;
        b=6pq8iiLDrHWk47F2yynPccb58I+xPnRZNyWQ2p6zRyjkiJqVoIMlhNzWAZFWXoeRr1
         rWQQHteypXjBPslPEPFlNLmMB1DG8EtlQ/Yb28S4wdlkSqGIPFUbWCgo9EBO/WAyW61E
         iNqPk/qM+BMVgET5PDkDlrKFUG6mnnTnTO7s60r2bs1sT+uWznOshqfxMhjEfmOnQGGT
         5gMIDuo8T69yCAa7CfDGRI+Ep5cxkkkvKxYGc0zxvRSkJKOQQjUW3zuemsgogrt3Q4qh
         82nwlaDgI9ZypMq5onIAawU/bmrpjrOwqIJXuWp4VEYW07r8qeAvvX+PknAoEAq7TLmj
         xWlQ==
X-Gm-Message-State: AOAM5339uJ3Lt7UQnY70TEEDdGcaONLmCl2LSAibsO8FGIxlLYhaTh5+
        uHg59M9DM9HO64mmmJDLIGf1yQ==
X-Google-Smtp-Source: ABdhPJzeE6ZWUlj20YR85YY9Y2tdo9YYnwyAOJlvbouH+i08+fLze1e0kqi8ZesTpEfynQFz7rkvSw==
X-Received: by 2002:a05:622a:345:b0:2e1:c756:6981 with SMTP id r5-20020a05622a034500b002e1c7566981mr15842634qtw.177.1649425164108;
        Fri, 08 Apr 2022 06:39:24 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id h2-20020ac85842000000b002e1ec550506sm17697035qth.87.2022.04.08.06.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 06:39:23 -0700 (PDT)
Message-ID: <062c81be513ac37a5556366e8f5a1503a2d03a4e.camel@poochiereds.net>
Subject: Re: OSD won't start ceph_assert(r == 0)
From:   Jeff Layton <jlayton@poochiereds.net>
To:     Dominik Bracht <Bracht5@live.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Date:   Fri, 08 Apr 2022 09:39:21 -0400
In-Reply-To: <7ac30a9724e248c5a6c8bafd03502860d16ce0f3.camel@live.com>
References: <7ac30a9724e248c5a6c8bafd03502860d16ce0f3.camel@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Dominik,

This mailing list is mostly for the kernel ceph client bits these days.
You probably want to resend this to dev@ceph.io or ceph-users@ceph.io.

Cheers,
Jeff

On Fri, 2022-04-08 at 09:43 +0000, Dominik Bracht wrote:
> Hello everyone,
> 
> i have an osd that randomly just crashed and is refusing to come up
> again. I found a similar looking issue
> https://tracker.ceph.com/issues/50656 but the workaround to use the
> bitmap allocator runs into the same issue
> 
> Crash Info:
> {
>     "crash_id": "2022-04-07T19:26:44.245668Z_7516fd9f-bc84-4cb5-afcd-
> a54c64753631",
>     "timestamp": "2022-04-07T19:26:44.245668Z",
>     "process_name": "ceph-osd",
>     "entity_name": "osd.8",
>     "ceph_version": "16.2.7",
>     "utsname_hostname": "sinnoh",
>     "utsname_sysname": "Linux",
>     "utsname_release": "5.13.19-6-pve",
>     "utsname_version": "#1 SMP PVE 5.13.19-14 (Thu, 10 Mar 2022
> 16:24:52 +0100)",
>     "utsname_machine": "x86_64",
>     "os_name": "Debian GNU/Linux 11 (bullseye)",
>     "os_id": "11",
>     "os_version_id": "11",
>     "os_version": "11 (bullseye)",
>     "assert_condition": "r == 0",
>     "assert_func": "void
> BlueFS::_compact_log_async(std::unique_lock<std::mutex>&)",
>     "assert_file": "./src/os/bluestore/BlueFS.cc",
>     "assert_line": 2352,
>     "assert_thread_name": "ceph-osd",
>     "assert_msg": "./src/os/bluestore/BlueFS.cc: In function 'void
> BlueFS::_compact_log_async(std::unique_lock<std::mutex>&)' thread
> 7ffbced1af00 time 2022-04-
> 07T21:26:44.194523+0200\n./src/os/bluestore/BlueFS.cc: 2352: FAILED
> ceph_assert(r == 0)\n",
>     "backtrace": [
>         "/lib/x86_64-linux-gnu/libpthread.so.0(+0x14140)
> [0x7ffbcf372140]",
>         "gsignal()",
>         "abort()",
>         "(ceph::__ceph_assert_fail(char const*, char const*, int, char
> const*)+0x16e) [0x55716b2bfb30]",
>         "/usr/bin/ceph-osd(+0xabcc71) [0x55716b2bfc71]",
>        
> "(BlueFS::_compact_log_async(std::unique_lock<std::mutex>&)+0x1a13)
> [0x55716b9ba243]",
>         "(BlueFS::_flush(BlueFS::FileWriter*, bool,
> std::unique_lock<std::mutex>&)+0x67) [0x55716b9ba497]",
>         "(BlueRocksWritableFile::Append(rocksdb::Slice const&)+0x100)
> [0x55716b9d27d0]",
>         "(rocksdb::LegacyWritableFileWrapper::Append(rocksdb::Slice
> const&, rocksdb::IOOptions const&, rocksdb::IODebugContext*)+0x48)
> [0x55716be9924e]",
>         "(rocksdb::WritableFileWriter::WriteBuffered(char const*,
> unsigned long)+0x338) [0x55716c073d18]",
>         "(rocksdb::WritableFileWriter::Append(rocksdb::Slice
> const&)+0x5d7) [0x55716c07229b]",
>         "(rocksdb::BlockBasedTableBuilder::WriteRawBlock(rocksdb::Slice
> const&, rocksdb::CompressionType, rocksdb::BlockHandle*, bool)+0x11d)
> [0x55716c23c2d7]",
>         "(rocksdb::BlockBasedTableBuilder::WriteBlock(rocksdb::Slice
> const&, rocksdb::BlockHandle*, bool)+0x7d0) [0x55716c23c0be]",
>        
> "(rocksdb::BlockBasedTableBuilder::WriteBlock(rocksdb::BlockBuilder*,
> rocksdb::BlockHandle*, bool)+0x48) [0x55716c23b8da]",
>         "(rocksdb::BlockBasedTableBuilder::Flush()+0x9a)
> [0x55716c23b88a]",
>         "(rocksdb::BlockBasedTableBuilder::Add(rocksdb::Slice const&,
> rocksdb::Slice const&)+0x197) [0x55716c23b3bf]",
>         "(rocksdb::BuildTable(std::__cxx11::basic_string<char,
> std::char_traits<char>, std::allocator<char> > const&, rocksdb::Env*,
> rocksdb::FileSystem*, rocksdb::ImmutableCFOptions const&,
> rocksdb::MutableCFOptions const&, rocksdb::FileOptions const&,
> rocksdb::TableCache*, rocksdb::InternalIteratorBase<rocksdb::Slice>*,
> std::vector<std::unique_ptr<rocksdb::FragmentedRangeTombstoneIterator,
> std::default_delete<rocksdb::FragmentedRangeTombstoneIterator> >,
> std::allocator<std::unique_ptr<rocksdb::FragmentedRangeTombstoneIterato
> r, std::default_delete<rocksdb::FragmentedRangeTombstoneIterator> > >
> > , rocksdb::FileMetaData*, rocksdb::InternalKeyComparator const&,
> std::vector<std::unique_ptr<rocksdb::IntTblPropCollectorFactory,
> std::default_delete<rocksdb::IntTblPropCollectorFactory> >,
> std::allocator<std::unique_ptr<rocksdb::IntTblPropCollectorFactory,
> std::default_delete<rocksdb::IntTblPropCollectorFactory> > > > const*,
> unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>,
> std::allocator<char> > const&, std::vector<unsigned long,
> std::allocator<unsigned long> >, unsigned long,
> rocksdb::SnapshotChecker*, rocksdb::CompressionType, unsigned long,
> rocksdb::CompressionOptions const&, bool, rocksdb::InternalStats*,
> rocksdb::TableFileCreationReason, rocksdb::EventLogger*, int,
> rocksdb::Env::IOPriority, rocksdb::TableProperties*, int, unsigned
> long, unsigned long, rocksdb::Env::WriteLifeTimeHint, unsigned
> long)+0x782) [0x55716c1be732]",
>         "(rocksdb::DBImpl::WriteLevel0TableForRecovery(int,
> rocksdb::ColumnFamilyData*, rocksdb::MemTable*,
> rocksdb::VersionEdit*)+0x5ea) [0x55716bf37226]",
>         "(rocksdb::DBImpl::RecoverLogFiles(std::vector<unsigned long,
> std::allocator<unsigned long> > const&, unsigned long*, bool,
> bool*)+0x1ad1) [0x55716bf35e9d]",
>        
> "(rocksdb::DBImpl::Recover(std::vector<rocksdb::ColumnFamilyDescriptor,
> std::allocator<rocksdb::ColumnFamilyDescriptor> > const&, bool, bool,
> bool, unsigned long*)+0x159e) [0x55716bf333d4]",
>         "(rocksdb::DBImpl::Open(rocksdb::DBOptions const&,
> std::__cxx11::basic_string<char, std::char_traits<char>,
> std::allocator<char> > const&,
> std::vector<rocksdb::ColumnFamilyDescriptor,
> std::allocator<rocksdb::ColumnFamilyDescriptor> > const&,
> std::vector<rocksdb::ColumnFamilyHandle*,
> std::allocator<rocksdb::ColumnFamilyHandle*> >*, rocksdb::DB**, bool,
> bool)+0x677) [0x55716bf386cd]",
>         "(rocksdb::DB::Open(rocksdb::DBOptions const&,
> std::__cxx11::basic_string<char, std::char_traits<char>,
> std::allocator<char> > const&,
> std::vector<rocksdb::ColumnFamilyDescriptor,
> std::allocator<rocksdb::ColumnFamilyDescriptor> > const&,
> std::vector<rocksdb::ColumnFamilyHandle*,
> std::allocator<rocksdb::ColumnFamilyHandle*> >*, rocksdb::DB**)+0x52)
> [0x55716bf37aa4]",
>         "(RocksDBStore::do_open(std::ostream&, bool, bool,
> std::__cxx11::basic_string<char, std::char_traits<char>,
> std::allocator<char> > const&)+0x10a6) [0x55716be488b6]",
>         "(BlueStore::_open_db(bool, bool, bool)+0xa19)
> [0x55716b8c6b19]",
>         "(BlueStore::_open_db_and_around(bool, bool)+0x332)
> [0x55716b90bb92]",
>         "(BlueStore::_mount()+0x191) [0x55716b90e531]",
>         "(OSD::init()+0x58d) [0x55716b3b55ed]",
>         "main()",
>         "__libc_start_main()",
>         "_start()"
>     ]
> }

-- 
Jeff Layton <jlayton@poochiereds.net>
