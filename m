Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B172C7897
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Nov 2020 11:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgK2KQw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 05:16:52 -0500
Received: from out20-63.mail.aliyun.com ([115.124.20.63]:35778 "EHLO
        out20-63.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgK2KQw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 05:16:52 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436333|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.210789-0.00355364-0.785657;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.J0az53T_1606644966;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.J0az53T_1606644966)
          by smtp.aliyun-inc.com(10.147.41.137);
          Sun, 29 Nov 2020 18:16:07 +0800
Date:   Sun, 29 Nov 2020 18:16:06 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, fstests@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3] ceph: add a new test for cross quota realms renames
Message-ID: <20201129101606.GQ3853@desktop>
References: <20201127123742.561-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127123742.561-1-lhenriques@suse.de>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Nov 27, 2020 at 12:37:42PM +0000, Luis Henriques wrote:
> For the moment cross quota realms renames has been disabled in CephFS
> after a bug has been found while renaming files created and truncated.
> This allowed clients to easily circumvent quotas.
> 
> Link: https://tracker.ceph.com/issues/48203
> Signed-off-by: Luis Henriques <lhenriques@suse.de>

Looks good to me from fstests' point of view. But I'm not familiar with
the ceph vxattr implementation. I'd like a Reviewed-by tag from ceph
folks as well. Thanks a lot!

Eryu

> ---
> v3: added file caps check, as suggested by Jeff Layton.
> This required commit "ceph: add ceph.caps vxattr" (not yet in mainline),
> which made me also introduce function _require_ceph_vxattr_caps.
> 
> v2: implemented Eryu review comments:
> - Added _require_test_program "rename"
> - Use _fail instead of _fatal
> common/ceph        |   7 +++
>  tests/ceph/004     | 119 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/004.out |   2 +
>  tests/ceph/group   |   1 +
>  4 files changed, 129 insertions(+)
>  create mode 100755 tests/ceph/004
>  create mode 100644 tests/ceph/004.out
> 
> diff --git a/common/ceph b/common/ceph
> index f80209f98b23..ca756dda8dd3 100644
> --- a/common/ceph
> +++ b/common/ceph
> @@ -21,3 +21,10 @@ _ceph_create_file_layout()
>  		-v "stripe_unit=$objsz stripe_count=1 object_size=$objsz" \
>  		$fname
>  }
> +
> +# this test requires to access file capabilities through vxattr 'ceph.caps'.
> +_require_ceph_vxattr_caps()
> +{
> +	$GETFATTR_PROG -n "ceph.caps" $TEST_DIR >/dev/null 2>&1 \
> +	  || _notrun "ceph.caps vxattr not supported"
> +}
> diff --git a/tests/ceph/004 b/tests/ceph/004
> new file mode 100755
> index 000000000000..1de19b39acb5
> --- /dev/null
> +++ b/tests/ceph/004
> @@ -0,0 +1,119 @@
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
> +_require_ceph_vxattr_caps # we need to get file capabilities
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
> +# get only the hexadecimal value of the ceph.caps vxattr, which has the
> +# following format:
> +#   ceph.caps="pAsLsXsFscr/0xd55"
> +get_ceph_caps()
> +{
> +	$GETFATTR_PROG --only-values -n "ceph.caps" $1 2>/dev/null \
> +	    | cut -d / -f2
> +}
> +
> +# check that a file has cephfs capabilities 'Fs'
> +check_Fs_caps()
> +{
> +	caps=`get_ceph_caps $1`
> +	# Fs cap is bit (1 << 8)
> +	Fs=$((1 << 8))
> +	res=$(($caps & $Fs))
> +	if [ $res -ne $Fs ]; then
> +		_fail "File $1 doesn't have Fs caps ($caps)"
> +	fi
> +}
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
> +check_Fs_caps $file1
> +$here/src/rename $orig1 $dest/new1 >> $seqres.full 2>&1
> +[ $? -ne 1 ] && _fail "cross quota realms rename succeeded"
> +
> +# from $orig2 realm to $dest realm
> +$XFS_IO_PROG -f -c "truncate 10G" $file2
> +check_Fs_caps $file2
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
>  001 auto quick copy
>  002 auto quick copy
>  003 auto quick copy
> +004 auto quick quota
