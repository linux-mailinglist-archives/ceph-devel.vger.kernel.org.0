Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2365292457
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Oct 2020 11:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgJSJH4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Oct 2020 05:07:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:44068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730142AbgJSJH4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 05:07:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D3F6B299;
        Mon, 19 Oct 2020 09:07:54 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 665c041e;
        Mon, 19 Oct 2020 09:07:58 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Eryu Guan <guan@eryu.me>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] Initial CephFS tests (take 2)
References: <20201007175212.16218-1-lhenriques@suse.de>
        <20201018104740.GZ3853@desktop>
Date:   Mon, 19 Oct 2020 10:07:57 +0100
In-Reply-To: <20201018104740.GZ3853@desktop> (Eryu Guan's message of "Sun, 18
        Oct 2020 18:47:40 +0800")
Message-ID: <87sgaa60sy.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Eryu Guan <guan@eryu.me> writes:

> On Wed, Oct 07, 2020 at 06:52:09PM +0100, Luis Henriques wrote:
>> This is my second attempt to have an initial set of ceph-specific tests
>> merged into fstests.  In this patchset I'm pushing a different set of
>> tests, focusing on the copy_file_range testing, although I *do* plan to
>> get back to the quota tests soon.
>
> I have no knowledge about cephfs, I don't have a cephfs test env either,
> so I can only comment from fstests' perspect of view. It'd be great if
> other ceph folks could help review this patchset as well.
>
> From fstests perspect of view, this patchset looks fine to me, just some
> minor comments go to individual patch.

Thank you Eryu, for taking some time to review these tests.  Much
appreciated.  I've gone through all your comments and they all make sense
to me.  I'll send out v2 shortly, addressing your concerns.

>> 
>> This syscall has a few peculiarities in ceph as it is able to use remote
>> object copies without the need to download/upload data from the OSDs.
>> However, in order to take advantage of this remote copy, the copy ranges
>> and sizes need to include at least one object.  Thus, all the currently
>> existing generic tests won't actually take advantage of this feature.
>> 
>> Let me know any comments/concerns about this patchset.  Also note that
>> currently, in order to enable copy_file_range in cephfs, the additional
>> 'copyfrom' mount parameter is required.  (Hopefully this additional param
>
> I assume '_require_xfs_io_command "copy_range"' will _notrun the test if
> there's no 'copyfrom' mount option provided, and test won't fail.

So, my cover-letter text was a bit confusing and not very clear about this
mount option.  These tests will run just fine (and won't fail) even
without the 'copyfrom' mount option.  The difference is that the copy
won't be done remotely on the OSDs but rather using a local read+write
loop (i.e. with the generic VFS copy_file_range implementation).
'copyfrom' is required only to enable the usage of the OSDs 'COPY_FROM'
operation.  I'm update the cover-letter text in v2 to clarify this.

Cheers,
-- 
Luis

>> may be dropped in the future.)
>> 
>> Luis Henriques (3):
>>   ceph: add copy_file_range (remote copy operation) testing
>>   ceph: test combination of copy_file_range with truncate
>>   ceph: test copy_file_range with infile = outfile
>> 
>>  tests/ceph/001     | 233 +++++++++++++++++++++++++++++++++++++++++++++
>>  tests/ceph/001.out | 129 +++++++++++++++++++++++++
>>  tests/ceph/002     |  74 ++++++++++++++
>>  tests/ceph/002.out |   8 ++
>>  tests/ceph/003     | 118 +++++++++++++++++++++++
>>  tests/ceph/003.out |  11 +++
>>  tests/ceph/group   |   3 +
>>  7 files changed, 576 insertions(+)
>>  create mode 100644 tests/ceph/001
>
> New test should have file mode 755, i.e. with x bit set. The 'new'
> script should have done this for you.
>
> Thanks,
> Eryu
>
>>  create mode 100644 tests/ceph/001.out
>>  create mode 100644 tests/ceph/002
>>  create mode 100644 tests/ceph/002.out
>>  create mode 100644 tests/ceph/003
>>  create mode 100644 tests/ceph/003.out
>>  create mode 100644 tests/ceph/group
