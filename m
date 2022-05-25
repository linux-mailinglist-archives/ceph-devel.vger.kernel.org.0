Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD9A533F84
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 16:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbiEYOrN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 May 2022 10:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbiEYOrL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 May 2022 10:47:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9F25D5FE;
        Wed, 25 May 2022 07:47:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6EA2D219FD;
        Wed, 25 May 2022 14:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653490029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIDzkReVN+pdZ+BgwCcwddX46oH6yoiP8xzU8MKX+Sc=;
        b=eskaoy3P5ipVbP6okWkh8aCPvKIGtdRohB87QTZlq6PsFO1qJ//z2GXSyyydmjMRXyd7Ue
        uvdwPs0ggD8xEHpfuaD3tmJb1jGdnQXQ6sXVJKCCQvwyYhu3Nd0DZMGCAdVo+pJ9XRKcDF
        CwFM12OGPlL+/MOzIw4kqaQTOjyfkdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653490029;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIDzkReVN+pdZ+BgwCcwddX46oH6yoiP8xzU8MKX+Sc=;
        b=cybgz6lRxNpkpps2ih8wOMk+fPSnVVBL2mAvUUwc9atsaieedpkkVxoepyXmSV8NwE1pRJ
        WkeMGlnT6SvQ+BCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0968F13487;
        Wed, 25 May 2022 14:47:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BFEFO2xBjmKOdQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 25 May 2022 14:47:08 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 86076555;
        Wed, 25 May 2022 14:47:45 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] ceph/005: verify correct statfs behaviour with quotas
References: <20220427143409.987-1-lhenriques@suse.de>
        <20220525101932.2dnpi3ehhakhxdnp@zlang-mailbox>
Date:   Wed, 25 May 2022 15:47:45 +0100
In-Reply-To: <20220525101932.2dnpi3ehhakhxdnp@zlang-mailbox> (Zorro Lang's
        message of "Wed, 25 May 2022 18:19:32 +0800")
Message-ID: <87pmk1wtwu.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Zorro Lang <zlang@redhat.com> writes:

> On Wed, Apr 27, 2022 at 03:34:09PM +0100, Lu=C3=ADs Henriques wrote:
>> When using a directory with 'max_bytes' quota as a base for a mount,
>> statfs shall use that 'max_bytes' value as the total disk size.  That
>> value shall be used even when using subdirectory as base for the mount.
>>=20
>> A bug was found where, when this subdirectory also had a 'max_files'
>> quota, the real filesystem size would be returned instead of the parent
>> 'max_bytes' quota value.  This test case verifies this bug is fixed.
>>=20
>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> ---
>>  tests/ceph/005     | 40 ++++++++++++++++++++++++++++++++++++++++
>>  tests/ceph/005.out |  2 ++
>>  2 files changed, 42 insertions(+)
>>  create mode 100755 tests/ceph/005
>>  create mode 100644 tests/ceph/005.out
>>=20
>> diff --git a/tests/ceph/005 b/tests/ceph/005
>> new file mode 100755
>> index 000000000000..0763a235a677
>> --- /dev/null
>> +++ b/tests/ceph/005
>> @@ -0,0 +1,40 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
>> +#
>> +# FS QA Test 005
>> +#
>> +# Make sure statfs reports correct total size when:
>> +# 1. using a directory with 'max_byte' quota as base for a mount
>> +# 2. using a subdirectory of the above directory with 'max_files' quota
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick quota
>> +
>> +_supported_fs generic
>
> As this case name is ceph/005, so I suppose you'd like to support 'ceph' =
only.

Yep, my mistake, sorry.  I'll fix it in next rev.

>> +_require_scratch
>> +
>> +_scratch_mount
>> +mkdir -p $SCRATCH_MNT/quota-dir/subdir
>> +
>> +# set quotas
>> +quota=3D$((1024*10000))
>> +$SETFATTR_PROG -n ceph.quota.max_bytes -v $quota $SCRATCH_MNT/quota-dir
>> +$SETFATTR_PROG -n ceph.quota.max_files -v $quota $SCRATCH_MNT/quota-dir=
/subdir
>> +_scratch_unmount
>> +
>> +SCRATCH_DEV=3D$SCRATCH_DEV/quota-dir _scratch_mount
>
> Try to not use SCRATCH_DEV like this.

I used this because I saw other tests doing something similar.  Basically,
I need to remount a filesystem with a different base directory.  Changing
the SCRATCH_DEV looked like a simple solution.

>> +total=3D`df -kP $SCRATCH_MNT | grep -v Filesystem | awk '{print $2}'`
>           ^^ $DF_PROG
>
> As we have _get_total_inode(), _get_used_inode(), _get_used_inode_percent=
(),
> _get_free_inode() and _get_available_space() in common/rc, I don't mind a=
dd
> one more:
>
> _get_total_space()
> {
> 	if [ -z "$1" ]; then
> 		echo "Usage: _get_total_space <mnt>"
> 		exit 1
> 	fi
> 	local total_kb;
> 	total_kb=3D`$DF_PROG $1 | tail -n1 | awk '{ print $2 }'`
> 	echo $((total_kb * 1024))
> }

Right, this makes sense.

>> +SCRATCH_DEV=3D$SCRATCH_DEV/quota-dir _scratch_unmount
>> +[ $total -eq 8192 ] || _fail "Incorrect statfs for quota-dir: $total"
>                 ^^^^
> I'm not familar with ceph, I just found "quota=3D$((1024*10000))" in this=
 case,
> didn't find any place metioned 8192. So may you help to demystify why we =
expect
> "8192" at here?
>
> And if "8192" is a fixed expected number at here, then we can print it di=
rectly,
> as golden image, see below ...

Hmm... OK, I'm struggling to remember the details about this, and it was
only a month ago I wrote this test!  Which is a sign that I should have,
at least, added a comment explaining this value.

I'll need to dig into the statfs code again to explain why we're setting
quotas to 10M and 'df' shows 8M (which is the default size for 2 ceph
objects btw).  I'll revisit this test in the next few days and sort this
mystery.

Thanks a lot for your review.

Cheers
--=20
Lu=C3=ADs

>> +
>> +SCRATCH_DEV=3D$SCRATCH_DEV/quota-dir/subdir _scratch_mount
>> +total=3D`df -kP $SCRATCH_MNT | grep -v Filesystem | awk '{print $2}'`
>> +SCRATCH_DEV=3D$SCRATCH_DEV/quota-dir/subdir _scratch_unmount
>> +[ $total -eq 8192 ] || _fail "Incorrect statfs for quota-dir/subdir: $t=
otal"
>
> May below code helps?
>
> _require_test
>
> localdir=3D$TEST_DIR/ceph-quota-dir-$seq
> rm -rf $localdir
> mkdir -p ${localdir}/subdir
> ...
> $SETFATTR_PROG -n ceph.quota.max_bytes -v $quota $localdir
> $SETFATTR_PROG -n ceph.quota.max_bytes -v $quota $localdir/subdir
> ...
>
> SCRATCH_DEV=3D$localdir _scratch_mount
> echo ceph quota size is $(_get_total_space $SCRATCH_MNT)
> SCRATCH_DEV=3D$localdir _scratch_unmount
>
> SCRATCH_DEV=3D$localdir/subdir _scratch_mount
> echo subdir ceph quota size is $(_get_total_space $SCRATCH_MNT)
> SCRATCH_DEV=3D$localdir/subdir _scratch_unmount
>
> Thanks,
> Zorro
>
>> +
>> +echo "Silence is golden"
>> +
>> +# success, all done
>> +status=3D0
>> +exit
>> diff --git a/tests/ceph/005.out b/tests/ceph/005.out
>> new file mode 100644
>> index 000000000000..a5027f127cf0
>> --- /dev/null
>> +++ b/tests/ceph/005.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 005
>> +Silence is golden
>>=20
>
