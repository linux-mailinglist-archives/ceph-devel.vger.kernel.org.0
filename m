Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEAC55AB30
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jun 2022 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiFYPGP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 25 Jun 2022 11:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiFYPGP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 25 Jun 2022 11:06:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E878511467
        for <ceph-devel@vger.kernel.org>; Sat, 25 Jun 2022 08:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656169573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uwnr4xH9pB9UbYr2KSoRGlW4Tb//7RDSDgi/MtUGa/0=;
        b=AD8qUrnDqY9StAWYpfvD+/tEv8qR1L7TYucp8LCVISQUHUPdm0tHsY5RJa1IMCK3gDudOK
        3u72BwId2Knr0DWBHqut1l6lKEDzNHDw1pLBHV/UaZetm/tM0zbk+vXHmiJkrkfI0ivvLz
        GlUKaZq40NjrtBxMw4OGmzrGq8AbW54=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-jOTSmKNsOx2yBzvEcVmFmg-1; Sat, 25 Jun 2022 11:06:11 -0400
X-MC-Unique: jOTSmKNsOx2yBzvEcVmFmg-1
Received: by mail-qk1-f197.google.com with SMTP id w16-20020a376210000000b006af059b17b7so4936492qkb.12
        for <ceph-devel@vger.kernel.org>; Sat, 25 Jun 2022 08:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Uwnr4xH9pB9UbYr2KSoRGlW4Tb//7RDSDgi/MtUGa/0=;
        b=Kn/g2qKU5tnJVewm1aDrLKNJd7/dCJ+Anh8EYbqSdalXnQTMqhJ00vyoG088ZPkUox
         9lrmzD4mCv0V4y6kbrxUwRltc9AdGhgraf/XyqcFFg4rhZ96BwwPw9PfZCMhdqMe8b8f
         tSyyidzpp+XuRs6qVVra6FPbtuR8rLh2ZP06V7ZY0phsAJDF6jaBNg8ammvzX3t4+tZ/
         N5i5Xx8M/THVOI1cYEuVa+xaGN1bBLsOTlfqyfDbYTRbyuBbelJJb51SLAQHpu5xL01b
         K/1nD141ESZsGpa/pYpsy7mL/XXv3VEDWPxuVvXcfped4K9ZUNvlJRsm5GpAtOTl/tF2
         oIyA==
X-Gm-Message-State: AJIora9KYh2SbdYiz+ElmTN62le/NLalFX0kfxooa5bPl+lGXrcGgy+I
        3cb22t/c8UxHEteUQbFGN3YlpZFP2j0JSNW9qzTcFDalsLXkXIbxZsei1/BoIVLOTKWzD2eaYeV
        RPYH8ad/5tr6UGKHKA5eSTA==
X-Received: by 2002:a05:620a:21c5:b0:6af:f32:2f0f with SMTP id h5-20020a05620a21c500b006af0f322f0fmr1644392qka.765.1656169570641;
        Sat, 25 Jun 2022 08:06:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5dYWPtUZGBIozOeZw5u1Zzw8ZAPeyt42MMa+o9NGKXEhcul7lNwPttxIEDZE75EF3pGhp1A==
X-Received: by 2002:a05:620a:21c5:b0:6af:f32:2f0f with SMTP id h5-20020a05620a21c500b006af0f322f0fmr1644367qka.765.1656169570343;
        Sat, 25 Jun 2022 08:06:10 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a5-20020ac85b85000000b00307cb34aa8asm3822836qta.47.2022.06.25.08.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 08:06:09 -0700 (PDT)
Date:   Sat, 25 Jun 2022 23:06:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph/005: verify correct statfs behaviour with quotas
Message-ID: <20220625150602.7giyegtsf6un4y3l@zlang-mailbox>
References: <20220615151418.23805-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220615151418.23805-1-lhenriques@suse.de>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 15, 2022 at 04:14:18PM +0100, Luís Henriques wrote:
> When using a directory with 'max_bytes' quota as a base for a mount,
> statfs shall use that 'max_bytes' value as the total disk size.  That
> value shall be used even when using subdirectory as base for the mount.
> 
> A bug was found where, when this subdirectory also had a 'max_files'
> quota, the real filesystem size would be returned instead of the parent
> 'max_bytes' quota value.  This test case verifies this bug is fixed.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Finally, I've managed to come back to this test.  The major changes since
> v1 are:
>  - creation of an helper for getting total mount space using 'df'
>  - now the test sends quota size to stdout
> 
>  common/rc          | 13 +++++++++++++
>  tests/ceph/005     | 38 ++++++++++++++++++++++++++++++++++++++
>  tests/ceph/005.out |  4 ++++
>  3 files changed, 55 insertions(+)
>  create mode 100755 tests/ceph/005
>  create mode 100644 tests/ceph/005.out
> 
> diff --git a/common/rc b/common/rc
> index 2f31ca464621..72eabb7a428c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4254,6 +4254,19 @@ _get_available_space()
>  	echo $((avail_kb * 1024))
>  }
>  
> +# get the total space in bytes
> +#
> +_get_total_space()
> +{
> +	if [ -z "$1" ]; then
> +		echo "Usage: _get_total_space <mnt>"
> +		exit 1
> +	fi
> +	local total_kb;
> +	total_kb=`$DF_PROG $1 | tail -n1 | awk '{ print $3 }'`
> +	echo $(($total_kb * 1024))
> +}
> +
>  # return device size in kb
>  _get_device_size()
>  {
> diff --git a/tests/ceph/005 b/tests/ceph/005
> new file mode 100755
> index 000000000000..7eb687e8a092
> --- /dev/null
> +++ b/tests/ceph/005
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test 005
> +#
> +# Make sure statfs reports correct total size when:
> +# 1. using a directory with 'max_byte' quota as base for a mount
> +# 2. using a subdirectory of the above directory with 'max_files' quota
> +#
> +. ./common/preamble
> +_begin_fstest auto quick quota
> +
> +_supported_fs ceph
> +_require_scratch
> +
> +_scratch_mount
> +mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
> +
> +# set quota
> +quota=$((2 ** 30)) # 1G 
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v "$quota" "$SCRATCH_MNT/quota-dir"
> +$SETFATTR_PROG -n ceph.quota.max_files -v "$quota" "$SCRATCH_MNT/quota-dir/subdir"
> +_scratch_unmount
> +
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_unmount

One week past, I hope to get some reviewing points from ceph mail list, due to I
am really not familiar with cephfs, especially about the SCRATCH_DEV change as
above.

I tried to ask if we can use a directory under TEST_DIR to do that, but Luís
said he need the "SCRATCH_DEV=$SCRATCH_DEV/xxxx" things. Is it always a good
usage for cephfs?

Hope to get review from ceph forks, Thanks!

Thanks,
Zorro

> +
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_mount
> +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_unmount
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/ceph/005.out b/tests/ceph/005.out
> new file mode 100644
> index 000000000000..47798b1fcd6f
> --- /dev/null
> +++ b/tests/ceph/005.out
> @@ -0,0 +1,4 @@
> +QA output created by 005
> +ceph quota size is 1073741824 bytes
> +subdir ceph quota size is 1073741824 bytes
> +Silence is golden
> 

