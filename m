Return-Path: <ceph-devel+bounces-3780-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29063BB4476
	for <lists+ceph-devel@lfdr.de>; Thu, 02 Oct 2025 17:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC38A7A2502
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Oct 2025 15:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A035175D53;
	Thu,  2 Oct 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOJMTxZB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A3286342
	for <ceph-devel@vger.kernel.org>; Thu,  2 Oct 2025 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759417918; cv=none; b=BpoXfLeWfucG6ELSrbG7+AEef/BM/g/Qhw7sQuZPuoJnJWHEvdEquOAFxulxO7BQpJxcTjbeOrQ+Iony6uwMyXG1A9eOexiUAx3yv/cBGGKa4AHoLEWY/4M7Qoqe9fKZ9kagEvO4Mtjgp0UFC4TTsqKg7yGsndfPd8zNbdYouKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759417918; c=relaxed/simple;
	bh=gGB7ckyqXFa86rzwX+H8nmXRPnHiX7BecDh9NHgQNpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSdiRaDITZ6UBj2cJNdTM3/fan0nV+CnZQqADRi8xBRzawCgxiIha8JM3a48wqPYiU1k7oqA8dnIn/VxQ4Rjvix6D28PpjfyN+/vQL63CbywPvXkB1qjR4QjFnJ5VYiXl/wy6AU2lEIvyBBAGm0W439JikLx/qyvAlLhfeiAGMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gOJMTxZB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759417915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aPKN+b5RaTQYrPpBPzObIbYQCQUPU2rx+bPhErBJqgY=;
	b=gOJMTxZBa26jxo2SXnAgMX8X+Oap3IZdzNhu3JZ8OFpmJAn/K66UdHn4kF8qDvCTaQqqZW
	jrIlytgdtzZcnjXbxVX0Vv+UxDw94K+VVPb8utJ0pbydT5LeJtpyULlzVEvDFeXlCfeTOQ
	55fkA8huNrU5WOlPkwogWUaplBfoLto=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-bN1LClAHOW-9H4wxFJjEyw-1; Thu, 02 Oct 2025 11:11:54 -0400
X-MC-Unique: bN1LClAHOW-9H4wxFJjEyw-1
X-Mimecast-MFC-AGG-ID: bN1LClAHOW-9H4wxFJjEyw_1759417913
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-277f0ea6ee6so15578195ad.0
        for <ceph-devel@vger.kernel.org>; Thu, 02 Oct 2025 08:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759417913; x=1760022713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aPKN+b5RaTQYrPpBPzObIbYQCQUPU2rx+bPhErBJqgY=;
        b=USGdEmrZollgj9GO9klf6AjulQWMCJgYp9wGPbzcvyBXMHFFQG4t9j/w8I0ce1LQTj
         p0gOYkEziMosdtNakSYZejdpwFkdMMnOSKOJG043yEHS7Ii0Lh9u2Mga0Uh2jY0SliJS
         CEjDOSOsT98sJfsP/uFUilVqKyh8kU+MpsuuFTl1RzPJ06Uod2JiYCxL4yLEfg7ucQ3s
         t4pU9QYI3xonTWipwwI58VVvDry33zuuTRwdii5PSouMogfcw45FQEFm0hrxWR0xM+ua
         SqnnYpKEN9ywJ5PeYdxW0q3NkdLHH8Y3noxdDEH/j8T/grYX3cRJawl9LZuUC1W8+Xl6
         56FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg0+QaCe98/3TNvx5V4QBkdoMmzlqFdY1rM00weLVhVzUnB4mmaumzyU9JfpbpxJyPUw/tiBnwWu/7@vger.kernel.org
X-Gm-Message-State: AOJu0YwTN8Jto1SDzOP9wWjw87Ec5Q0k87Iwd+PMCRaOCCITDNAzriO8
	hznIzhya0oWW3iR+8ENVURRzJ+kaEZq/Yi5wqV0CGXuOTGDr7kOA0WEMeaeMNYUFpnqw7fDXd+v
	TTf0qIDNUPvwfWjDa3jAp/BDwUj8IE9LXO5NAUc7CHed/aAHx6R027r7cUAO4ylM=
X-Gm-Gg: ASbGncuhQDcoVIL9r86TIXh7euqJxLuWtleRyhEF8DhCwce1t19x5bkCTyg6fWGlJb4
	jc66y8t/MPKwgaCBdaOmL5IK9IrpLIGF1j/8+rt9Bxl6bmwGoKQQth5kDlH/eLdo3nt0ZLlbayq
	JVxtWHqJE3tsb5/4hWRP0VaJsOV5skucOEBnRrRw3dCGheYDjhGta22jTfX4rSQk92m1SKOZ4e0
	vdm9Z72wWIDa+CpUtFeLFiKxZsaqCoFwdKGX8oJi1qrHPnqRdDnLOPUWSFIYDVlpkA4AY+bn6AR
	xXo7/YkVnLA9e5TqTi9N1iKSnBkzgAmGlxWeEMglhLKlOldewTKtkqEvgR0ybpLHd/lVjL+1hks
	XJZ6IWO1T+g==
X-Received: by 2002:a17:903:3847:b0:264:567b:dd92 with SMTP id d9443c01a7336-28e7f457c56mr100829115ad.52.1759417912959;
        Thu, 02 Oct 2025 08:11:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDH7Q8nGL0cm7VMMea4yG9nJOgLM7yL5VARcgRy1IlnWgysfaPV6XhBSWrX8XlXno44YRHdw==
X-Received: by 2002:a17:903:3847:b0:264:567b:dd92 with SMTP id d9443c01a7336-28e7f457c56mr100828645ad.52.1759417912336;
        Thu, 02 Oct 2025 08:11:52 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1ef43fsm24406875ad.122.2025.10.02.08.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 08:11:51 -0700 (PDT)
Date: Thu, 2 Oct 2025 23:11:47 +0800
From: Zorro Lang <zlang@redhat.com>
To: ethanwu <ethanwu@synology.com>
Cc: fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com, ethan198912@gmail.com
Subject: Re: [PATCH v2] generic/778: test snapshot data integrity after punch
 hole operations
Message-ID: <20251002151147.hcojczrc4xn7ikiz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251002083035.3274508-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002083035.3274508-1-ethanwu@synology.com>

On Thu, Oct 02, 2025 at 04:30:35PM +0800, ethanwu wrote:
> Add test to verify that snapshots preserve original file data
> when the live file is modified with punch hole operations. The test
> creates a file, takes a snapshot, punches multiple holes in the
> original file, then verifies the snapshot data remains unchanged.
> 
> Signed-off-by: ethanwu <ethanwu@synology.com>
> ---
> v1->v2: previous version is 'ceph/006: test snapshot data integrity after
> 	punch hole'.
> 	1. move it to generic and add _require_snapshot check.
> 	2. modify punch hole offset/len to be 64K aligned
> ---
>  common/rc             | 20 +++++++++++
>  tests/generic/778     | 80 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/778.out |  2 ++
>  3 files changed, 102 insertions(+)
>  create mode 100755 tests/generic/778
>  create mode 100644 tests/generic/778.out
> 
> diff --git a/common/rc b/common/rc
> index 81587dad..eec028e7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5978,6 +5978,26 @@ _require_inplace_writes()
>  	fi
>  }
>  
> +# this test requires filesystem snapshot support
> +_require_snapshot()

There's snapshot on device mapper layout, so how about change this function
name to _require_fs_snapshot() .

> +{
> +	case "$FSTYP" in
> +	ceph)
> +		local check_dir=$1
> +		[ -z "$check_dir" ] && _fail "_require_snapshot: directory argument required for ceph"
> +		local test_snapdir="$check_dir/.snap/test_snap_$$"
> +		mkdir "$test_snapdir" 2>/dev/null || _notrun "Ceph snapshots not supported (requires fs flag 'allow_snaps' and client auth capability 'snap')"
> +		rmdir "$test_snapdir"
> +		;;
> +	btrfs)
> +		# btrfs always supports snapshots, no check needed
> +		;;
> +	*)
> +		_notrun "Snapshots not supported on $FSTYP"
> +		;;
> +	esac
> +}
> +
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/generic/778 b/tests/generic/778
> new file mode 100755
> index 00000000..96a8f1c8
> --- /dev/null
> +++ b/tests/generic/778
> @@ -0,0 +1,80 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Synology All Rights Reserved.
> +#
> +# FS QA Test No. generic/778
> +#
> +# Test that snapshot data remains intact after punch hole operations
> +# on the original file.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick snapshot
> +
> +# Override the default cleanup function
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +	if [ -n "$snapdir" ]; then
> +		case "$FSTYP" in
> +		ceph)
> +			rmdir $snapdir 2>/dev/null
> +			;;
> +		btrfs)
> +			$BTRFS_UTIL_PROG subvolume delete $snapdir > /dev/null
> +			;;
> +		esac
> +	fi
> +}
> +
> +_require_test
> +_require_xfs_io_command "pwrite"
> +_require_xfs_io_command "fpunch"
> +_require_snapshot $TEST_DIR
> +_exclude_test_mount_option "test_dummy_encryption"
> +
> +# TODO: Update with final commit SHA when merged
> +[ "$FSTYP" = "ceph" ] && _fixed_by_kernel_commit 1b7b474b3a78 \
> +	"ceph: fix snapshot context missing in ceph_zero_partial_object"
> +
> +workdir=$TEST_DIR/test-$seq
> +rm -rf $workdir
> +mkdir $workdir
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
> +
> +# Create snapshot - filesystem specific
> +case "$FSTYP" in
> +ceph)
> +	snapdir=$TEST_DIR/.snap/snap1
> +	mkdir $snapdir
> +	;;
> +btrfs)
> +	snapdir=$TEST_DIR/snap1
> +	$BTRFS_UTIL_PROG subvolume snapshot ${TEST_DIR} $snapdir > /dev/null
> +	;;
> +esac

Sorry to make this test case to be more complicated, I didn't realize ".snap"
is a special directory for ceph. I think you have two choices:

1) Move this case back to be a ceph only test case.
2) Write more common snapshot related helpers, e.g:
    _require_fs_snapshot (you've written it)
    _create_fs_snapshot  (to replace above creating snapshot part)
    _destroy_fs_snapshot (for above cleanup part)

Both are good to me, depends on which one you prefer :)

...

For the ".snap" directory, as you said it can be changed by mount option,
so I'm wondering if you can get the "real" snapshot dir name at first, then
do other steps, e.g.

snapdir=$(_get_ceph_snapshot_dir)  (or whatever name you prefer:)
testdir=$TEST_DIR/$snapdir

  _require_fs_snapshot $testdir
  _create_fs_snapshot $testdir/...
  _destroy_fs_snapshot $testdir/...

or
  you only test with ceph

Thanks,
Zorro

> +
> +original_md5=$(md5sum $snapdir/test-$seq/foo | cut -d' ' -f1)
> +
> +# Punch several holes of various sizes at different offsets
> +$XFS_IO_PROG -c "fpunch 0 65536" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 131072 65536" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 262144 65536" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 393216 65536" $workdir/foo
> +
> +# Make sure we don't read from cache
> +echo 3 > /proc/sys/vm/drop_caches
> +
> +snapshot_md5=$(md5sum $snapdir/test-$seq/foo | cut -d' ' -f1)
> +
> +if [ "$original_md5" != "$snapshot_md5" ]; then
> +    echo "FAIL: Snapshot data changed after punch hole operations"
> +    echo "Original md5sum: $original_md5"
> +    echo "Snapshot md5sum: $snapshot_md5"
> +fi
> +
> +echo "Silence is golden"
> +
> +status=0
> +exit
> diff --git a/tests/generic/778.out b/tests/generic/778.out
> new file mode 100644
> index 00000000..e80f72a3
> --- /dev/null
> +++ b/tests/generic/778.out
> @@ -0,0 +1,2 @@
> +QA output created by 778
> +Silence is golden
> -- 
> 2.43.0
> 
> 
> Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
> 


