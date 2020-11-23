Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48D2C02DF
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 10:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgKWJ4v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 04:56:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:46384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728596AbgKWJ4v (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 04:56:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 84A5EAC24;
        Mon, 23 Nov 2020 09:56:49 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 3a50062e;
        Mon, 23 Nov 2020 09:57:06 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Eryu Guan <guan@eryu.me>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH] ceph: add a new test for cross quota realms renames
References: <20201119141956.6488-1-lhenriques@suse.de>
        <20201122153229.GN3853@desktop>
Date:   Mon, 23 Nov 2020 09:57:06 +0000
In-Reply-To: <20201122153229.GN3853@desktop> (Eryu Guan's message of "Sun, 22
        Nov 2020 23:32:29 +0800")
Message-ID: <87sg90s8el.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Eryu Guan <guan@eryu.me> writes:

> On Thu, Nov 19, 2020 at 02:19:56PM +0000, Luis Henriques wrote:
>> For the moment cross quota realms renames has been disabled in CephFS
>> after a bug has been found while renaming files created and truncated.
>> This allowed clients to easily circumvent quotas.
>> 
>> Link: https://tracker.ceph.com/issues/48203
>> Signed-off-by: Luis Henriques <lhenriques@suse.de>
>
> Thanks for the test! It'd be great if ceph folks could help review &
> test it as well, as I don't have a cephfs test env yet..
>
> Some minor comments below.

Thanks for your review, Eryu.  I'll send out v2 with your comments
implemented.

Cheers,
-- 
Luis

>> ---
>>  tests/ceph/004     | 94 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/ceph/004.out |  2 +
>>  tests/ceph/group   |  1 +
>>  3 files changed, 97 insertions(+)
>>  create mode 100755 tests/ceph/004
>>  create mode 100644 tests/ceph/004.out
>> 
>> diff --git a/tests/ceph/004 b/tests/ceph/004
>> new file mode 100755
>> index 000000000000..4021666b138e
>> --- /dev/null
>> +++ b/tests/ceph/004
>> @@ -0,0 +1,94 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 SUSE Linux Products GmbH. All Rights Reserved.
>> +#
>> +# FS QA Test 004
>> +#
>> +# Tests a bug fix found in cephfs quotas handling.  Here's a simplified testcase
>> +# that *should* fail:
>> +#
>> +#    mkdir files limit
>> +#    truncate files/file -s 10G
>> +#    setfattr limit -n ceph.quota.max_bytes -v 1000000
>> +#    mv files limit/
>> +#
>> +# Because we're creating a new file and truncating it, we have Fx caps and thus
>> +# the truncate operation will be cached.  This prevents the MDSs from updating
>> +# the quota realms and thus the client will allow the above rename(2) to happen.
>> +#
>> +# The bug resulted in dropping support for cross quota-realms renames, reverting
>> +# kernel commit dffdcd71458e ("ceph: allow rename operation under different
>> +# quota realms").
>> +#
>> +# So, the above test will now fail with a -EXDEV or, in the future (when we have
>> +# a proper fix), with -EDQUOT.
>> +#
>> +# This bug was tracker here:
>> +#
>> +#   https://tracker.ceph.com/issues/48203
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/attr
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs ceph
>> +_require_attrs
>> +_require_test
>
> Need '_require_test_program "rename"' as well.
>
>> +
>> +workdir=$TEST_DIR/test-$seq
>> +
>> +orig1=$workdir/orig1
>> +orig2=$workdir/orig2
>> +file1=$orig1/file
>> +file2=$orig2/file
>> +dest=$workdir/dest
>> +
>> +rm -rf $workdir
>> +mkdir $workdir
>> +mkdir $orig1 $orig2 $dest
>> +
>> +# set quota to 1m
>> +$SETFATTR_PROG -n ceph.quota.max_bytes -v 1000000 $dest
>> +# set quota to 20g
>> +$SETFATTR_PROG -n ceph.quota.max_bytes -v 20000000000 $orig2
>> +
>> +#
>> +# The following 2 testcases shall fail with either -EXDEV or -EDQUOT
>> +#
>> +
>> +# from 'root' realm to $dest realm
>> +$XFS_IO_PROG -f -c "truncate 10G" $file1
>> +$here/src/rename $orig1 $dest/new1 >> $seqres.full 2>&1
>> +[ $? -ne 1 ] && _fatal "cross quota realms rename succeeded"
>
> Use _fail instead of _fatal in test, _fatal is usually used in common
> helpers, to report internal errors such as wrong usage of helpers.
>
>> +
>> +# from $orig2 realm to $dest realm
>> +$XFS_IO_PROG -f -c "truncate 10G" $file2
>> +$here/src/rename $orig2 $dest/new2 >> $seqres.full 2>&1
>> +[ $? -ne 1 ] && _fatal "cross quota realms rename succeeded"
>
> Same here.
>
> Thanks,
> Eryu
>
>> +
>> +echo "Silence is golden"
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/ceph/004.out b/tests/ceph/004.out
>> new file mode 100644
>> index 000000000000..af8614ae45ac
>> --- /dev/null
>> +++ b/tests/ceph/004.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 004
>> +Silence is golden
>> diff --git a/tests/ceph/group b/tests/ceph/group
>> index adbf61547766..47903d21966c 100644
>> --- a/tests/ceph/group
>> +++ b/tests/ceph/group
>> @@ -1,3 +1,4 @@
>>  001 auto quick copy
>>  002 auto quick copy
>>  003 auto quick copy
>> +004 auto quick quota
