Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F57C2C0E0D
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 15:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgKWOnA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 23 Nov 2020 09:43:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:47718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgKWOnA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 09:43:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 71ABAAC23;
        Mon, 23 Nov 2020 14:42:58 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 50fdd2a0;
        Mon, 23 Nov 2020 14:43:14 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Eryu Guan <guan@eryu.me>, fstests@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph: add a new test for cross quota realms renames
References: <87sg90s8el.fsf@suse.de>
        <20201123103439.27908-1-lhenriques@suse.de>
        <adf5a0056e11fe2575915a4d416b2f65cba02ded.camel@kernel.org>
Date:   Mon, 23 Nov 2020 14:43:14 +0000
In-Reply-To: <adf5a0056e11fe2575915a4d416b2f65cba02ded.camel@kernel.org> (Jeff
        Layton's message of "Mon, 23 Nov 2020 07:28:53 -0500")
Message-ID: <87im9wrv5p.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Mon, 2020-11-23 at 10:34 +0000, Luis Henriques wrote:
>> For the moment cross quota realms renames has been disabled in CephFS
>> after a bug has been found while renaming files created and truncated.
>> This allowed clients to easily circumvent quotas.
>> 
>> Link: https://tracker.ceph.com/issues/48203
>> Signed-off-by: Luis Henriques <lhenriques@suse.de>
>> ---
>> v2: implemented Eryu review comments:
>> - Added _require_test_program "rename"
>> - Use _fail instead of _fatal
>> 
>>  tests/ceph/004     | 95 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/ceph/004.out |  2 +
>>  tests/ceph/group   |  1 +
>>  3 files changed, 98 insertions(+)
>>  create mode 100755 tests/ceph/004
>>  create mode 100644 tests/ceph/004.out
>> 
>> diff --git a/tests/ceph/004 b/tests/ceph/004
>> new file mode 100755
>> index 000000000000..53094d8dfadc
>> --- /dev/null
>> +++ b/tests/ceph/004
>> @@ -0,0 +1,95 @@
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
>
> Note that it can be difficult to predict which caps you get from the
> MDS. It's not _required_ to pass out anything like Fx if it doesn't want
> to, but in general, it does if it can.
>
> It's not a blocker for merging this test, but I wonder if we ought to
> come up with some way to ensure that the client was given the caps we
> expect when testing stuff like this.
>
> Maybe we ought to consider adding a new ceph.caps vxattr that shows the
> caps we hold for a particular file? Then we could consult that when
> doing a test like this to make sure we got what we expected.

Sure, I can hack a patch for doing that and send it out for review.
That's actually trivial, I believe.

This test assumes the caps for the truncated file will be 'Fsxcrwb' but I
didn't confirm with the MDS which conditions are actually required for
this to happen.  Also, I guess that if the test is executed with several
clients, these caps may change pretty quickly (and maybe even with a
single very slow client with a very short caps timeout).

Obviously, ensuring the client has the caps we expect at the time we do
the actual rename is racy and they can change in the meantime.  Is it
worth the trouble?

Cheers,
-- 
Luis

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
>> +_require_test_program "rename"
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
>> +[ $? -ne 1 ] && _fail "cross quota realms rename succeeded"
>> +
>> +# from $orig2 realm to $dest realm
>> +$XFS_IO_PROG -f -c "truncate 10G" $file2
>> +$here/src/rename $orig2 $dest/new2 >> $seqres.full 2>&1
>> +[ $? -ne 1 ] && _fail "cross quota realms rename succeeded"
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
>>  001 auto quick copy
>>  002 auto quick copy
>>  003 auto quick copy
>> +004 auto quick quota
>
> This looks good to me.
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>
