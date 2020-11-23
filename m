Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4262C0BB9
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 14:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389258AbgKWN3n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 08:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730517AbgKWM2z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 07:28:55 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 586772076E;
        Mon, 23 Nov 2020 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606134534;
        bh=LdLdf+MBsAOa3UoLLBlf0hq73LFxB6baIRus/jQToiE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=2rrxJ7NSNcYWuL8Gx5bMf+NvYdZKbbjHmD83QNl+BFPnJtf+HJF9Ag+5DT7gbs/Ts
         Y8Ey3sbMcYZ7Ba1OP71RjOiBf+SZRfo91S+eh/RZIbvvNrvjeLJV8rABASvfI0fPHF
         SzEATQ1Dodo7wFGew3SSqGaSuvYQVdojjPzi4fV0=
Message-ID: <adf5a0056e11fe2575915a4d416b2f65cba02ded.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: add a new test for cross quota realms renames
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>, Eryu Guan <guan@eryu.me>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Date:   Mon, 23 Nov 2020 07:28:53 -0500
In-Reply-To: <20201123103439.27908-1-lhenriques@suse.de>
References: <87sg90s8el.fsf@suse.de>
         <20201123103439.27908-1-lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-11-23 at 10:34 +0000, Luis Henriques wrote:
> For the moment cross quota realms renames has been disabled in CephFS
> after a bug has been found while renaming files created and truncated.
> This allowed clients to easily circumvent quotas.
> 
> Link: https://tracker.ceph.com/issues/48203
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> v2: implemented Eryu review comments:
> - Added _require_test_program "rename"
> - Use _fail instead of _fatal
> 
>  tests/ceph/004     | 95 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/004.out |  2 +
>  tests/ceph/group   |  1 +
>  3 files changed, 98 insertions(+)
>  create mode 100755 tests/ceph/004
>  create mode 100644 tests/ceph/004.out
> 
> diff --git a/tests/ceph/004 b/tests/ceph/004
> new file mode 100755
> index 000000000000..53094d8dfadc
> --- /dev/null
> +++ b/tests/ceph/004
> @@ -0,0 +1,95 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test 004
> +#
> +# Tests a bug fix found in cephfs quotas handling.  Here's a simplified testcase
> +# that *should* fail:
> +#
> +#    mkdir files limit
> +#    truncate files/file -s 10G
> +#    setfattr limit -n ceph.quota.max_bytes -v 1000000
> +#    mv files limit/
> +#
> +# Because we're creating a new file and truncating it, we have Fx caps and thus
> +# the truncate operation will be cached.  This prevents the MDSs from updating
> +# the quota realms and thus the client will allow the above rename(2) to happen.
> +#

Note that it can be difficult to predict which caps you get from the
MDS. It's not _required_ to pass out anything like Fx if it doesn't want
to, but in general, it does if it can.

It's not a blocker for merging this test, but I wonder if we ought to
come up with some way to ensure that the client was given the caps we
expect when testing stuff like this.

Maybe we ought to consider adding a new ceph.caps vxattr that shows the
caps we hold for a particular file? Then we could consult that when
doing a test like this to make sure we got what we expected.

> +# The bug resulted in dropping support for cross quota-realms renames, reverting
> +# kernel commit dffdcd71458e ("ceph: allow rename operation under different
> +# quota realms").
> +#
> +# So, the above test will now fail with a -EXDEV or, in the future (when we have
> +# a proper fix), with -EDQUOT.
> +#
> +# This bug was tracker here:
> +#
> +#   https://tracker.ceph.com/issues/48203
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs ceph
> +_require_attrs
> +_require_test
> +_require_test_program "rename"
> +
> +workdir=$TEST_DIR/test-$seq
> +
> +orig1=$workdir/orig1
> +orig2=$workdir/orig2
> +file1=$orig1/file
> +file2=$orig2/file
> +dest=$workdir/dest
> +
> +rm -rf $workdir
> +mkdir $workdir
> +mkdir $orig1 $orig2 $dest
> +
> +# set quota to 1m
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v 1000000 $dest
> +# set quota to 20g
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v 20000000000 $orig2
> +
> +#
> +# The following 2 testcases shall fail with either -EXDEV or -EDQUOT
> +#
> +
> +# from 'root' realm to $dest realm
> +$XFS_IO_PROG -f -c "truncate 10G" $file1
> +$here/src/rename $orig1 $dest/new1 >> $seqres.full 2>&1
> +[ $? -ne 1 ] && _fail "cross quota realms rename succeeded"
> +
> +# from $orig2 realm to $dest realm
> +$XFS_IO_PROG -f -c "truncate 10G" $file2
> +$here/src/rename $orig2 $dest/new2 >> $seqres.full 2>&1
> +[ $? -ne 1 ] && _fail "cross quota realms rename succeeded"
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/ceph/004.out b/tests/ceph/004.out
> new file mode 100644
> index 000000000000..af8614ae45ac
> --- /dev/null
> +++ b/tests/ceph/004.out
> @@ -0,0 +1,2 @@
> +QA output created by 004
> +Silence is golden
> diff --git a/tests/ceph/group b/tests/ceph/group
> index adbf61547766..47903d21966c 100644
> --- a/tests/ceph/group
> +++ b/tests/ceph/group
> @@ -1,3 +1,4 @@
>  001 auto quick copy
>  002 auto quick copy
>  003 auto quick copy
> +004 auto quick quota

This looks good to me.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

