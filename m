Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8875338D2
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiEYIxU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 May 2022 04:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiEYIxT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 May 2022 04:53:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985586EC49;
        Wed, 25 May 2022 01:53:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5828321A30;
        Wed, 25 May 2022 08:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653468796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lvI5+7nkEUAhviAN89G0g3b4xRyPUSDr30NoCxU9Vg=;
        b=CAxqpGc7pYz5m/NlN/dhvQq6DP7o3I/Mqrn4le2WAGC1zsMRRAWBa2DaUGKO+TXfZCT3w5
        3F+wkg5cNsvcaMhgRoTAxIcnoKQGcHs8HmfIleAczwThWf9qWxi+iS+ab+hquYIo3cCciz
        aQ71hwWE9fvkpeTYnP/N2sJfTtLtitI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653468796;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lvI5+7nkEUAhviAN89G0g3b4xRyPUSDr30NoCxU9Vg=;
        b=zzuNro+lQr66Xd5esa0abbtW35iJnS1BhKalSA1miuKmaeXTOoPYJTgFz5yogGByEu0Cgu
        Z5PZwLCqnbgD4sCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2B5613ADF;
        Wed, 25 May 2022 08:53:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GPaaNHvujWKNQQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 25 May 2022 08:53:15 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d9d65e37;
        Wed, 25 May 2022 08:53:53 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     David Disseldorp <ddiss@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] ceph/005: verify correct statfs behaviour with quotas
References: <20220427143409.987-1-lhenriques@suse.de>
        <20220525001142.0a17a41a@suse.de>
Date:   Wed, 25 May 2022 09:53:53 +0100
In-Reply-To: <20220525001142.0a17a41a@suse.de> (David Disseldorp's message of
        "Wed, 25 May 2022 00:11:42 +0200")
Message-ID: <87pmk2kn6m.fsf@brahms.olymp>
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

David Disseldorp <ddiss@suse.de> writes:

> Hi Lu=C3=ADs,
>
> It looks like this one is still in need of review...

Ah! Thanks for reminding me about it, David!

>
> On Wed, 27 Apr 2022 15:34:09 +0100, Lu=C3=ADs Henriques wrote:
>
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
> Aside from the standard please-quote-your-variables gripe, I'm a little

Sure, I'll fix those in next iteration.

> confused with the use of SCRATCH_DEV for this test. Network FSes where
> mkfs isn't provided don't generally use it. Is there any way that this
> could be run against TEST_DEV, or does the umount / mount complicate
> things too much?

When I looked at other tests doing similar things (i.e. changing the mount
device during the test), they all seemed to be using SCRATCH_DEV.  I guess
that I could change TEST_DEV instead.  I'll revisit this and see if that
works.

Anyway, regarding the usage of SCRATCH_DEV in cephfs, I've used several
different approaches:

- Use 2 different filesystems created on the same cluster,
- Use 2 volumes on the same filesystem, or
- Simply use 2 directories in the same filesystem.

I tend to use the later most of the times, as it's easier to setup :-)

Cheers,
--=20
Lu=C3=ADs
