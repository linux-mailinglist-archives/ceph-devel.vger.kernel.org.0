Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C1291702
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Oct 2020 12:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgJRKwa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Oct 2020 06:52:30 -0400
Received: from out20-14.mail.aliyun.com ([115.124.20.14]:36910 "EHLO
        out20-14.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgJRKw3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 18 Oct 2020 06:52:29 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0745764|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.115352-0.0039482-0.8807;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.Il-6bus_1603018345;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Il-6bus_1603018345)
          by smtp.aliyun-inc.com(10.147.41.178);
          Sun, 18 Oct 2020 18:52:25 +0800
Date:   Sun, 18 Oct 2020 18:52:25 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: Re: [PATCH 2/3] ceph: test combination of copy_file_range with
 truncate
Message-ID: <20201018105225.GB3853@desktop>
References: <20201007175212.16218-1-lhenriques@suse.de>
 <20201007175212.16218-3-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007175212.16218-3-lhenriques@suse.de>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 07, 2020 at 06:52:11PM +0100, Luis Henriques wrote:
> From: Luis Henriques <lhenriques@suse.com>
> 
> This test was motivated by an OSD bug found while testing copy_file_range.
> This bug was an issue with the way the OSDs handled the truncate_seq
> value, which was being copied from the original object into the
> destination object.  This test ensures the kernel client correctly handles
> fixed/non-fixed OSDs.
> 
> Link: https://tracker.ceph.com/issues/37378
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  tests/ceph/002     | 74 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/002.out |  8 +++++
>  tests/ceph/group   |  1 +
>  3 files changed, 83 insertions(+)
>  create mode 100644 tests/ceph/002
>  create mode 100644 tests/ceph/002.out
> 
> diff --git a/tests/ceph/002 b/tests/ceph/002
> new file mode 100644
> index 000000000000..a2ae6c9629f4
> --- /dev/null
> +++ b/tests/ceph/002
> @@ -0,0 +1,74 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2020 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test No. ceph/002
> +#
> +# Test bug found while testing copy_file_range.
> +#
> +# This bug was an issue with how the OSDs handled the truncate_seq, copying it
> +# from the original object into the destination object.  This test ensures the
> +# kernel client correctly handles fixed/non-fixed OSDs.
> +#
> +# https://tracker.ceph.com/issues/37378

I noticed that the bug in above issue link has been fixed, it'd be good
to reference the fix commit as well, so people will know where the fix
is when test fails.

Thanks,
Eryu

> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment
> +. common/rc
> +. common/filter
> +. common/attr
> +
> +# real QA test starts here
> +_supported_fs ceph
> +
> +_require_xfs_io_command "copy_range"
> +_require_attrs
> +_require_test
> +
> +workdir=$TEST_DIR/test-$seq
> +rm -rf $workdir
> +mkdir $workdir
> +rm -f $seqres.full
> +
> +# Use 4M object size
> +objsz=4194304
> +file="$workdir/file-$objsz"
> +dest="$workdir/dest-$objsz"
> +touch $file $dest
> +
> +# object_size has to be a multiple of stripe_unit
> +$SETFATTR_PROG -n ceph.file.layout \
> +	-v "stripe_unit=$objsz stripe_count=1 object_size=$objsz" \
> +	$file $dest
> +
> +# Create a 3 objects size files
> +$XFS_IO_PROG -c "pwrite -S 0x61 0 $objsz" $file >> $seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite -S 0x62 $objsz $objsz" $file >> $seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite -S 0x63 $(($objsz * 2)) $objsz" $file >> $seqres.full 2>&1
> +
> +$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 3))" $dest >> $seqres.full 2>&1
> +# Truncate the destination file (messing up with the truncate_seq)
> +$XFS_IO_PROG -c "truncate 0" $dest >> $seqres.full 2>&1
> +
> +# copy the whole file over
> +$XFS_IO_PROG -c "copy_range -s 0 -d 0 -l $(($objsz * 3)) $file" "$dest"
> +
> +hexdump $dest
> +
> +#success, all done
> +status=0
> +exit
> diff --git a/tests/ceph/002.out b/tests/ceph/002.out
> new file mode 100644
> index 000000000000..6f067250afff
> --- /dev/null
> +++ b/tests/ceph/002.out
> @@ -0,0 +1,8 @@
> +QA output created by 002
> +0000000 6161 6161 6161 6161 6161 6161 6161 6161
> +*
> +0400000 6262 6262 6262 6262 6262 6262 6262 6262
> +*
> +0800000 6363 6363 6363 6363 6363 6363 6363 6363
> +*
> +0c00000
> diff --git a/tests/ceph/group b/tests/ceph/group
> index 11f0b9ad03d3..c28fe473c1a4 100644
> --- a/tests/ceph/group
> +++ b/tests/ceph/group
> @@ -1 +1,2 @@
>  001 auto quick copy
> +002 auto quick copy
