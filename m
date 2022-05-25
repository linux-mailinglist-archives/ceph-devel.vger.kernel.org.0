Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD98533F0F
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 16:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiEYOZm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 May 2022 10:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbiEYOZm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 May 2022 10:25:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1106ABF;
        Wed, 25 May 2022 07:25:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C13951F45E;
        Wed, 25 May 2022 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653488739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcyUlkvRGFEW/ULXmTtgvKKFJcJyrBkqOjuEy8zAx28=;
        b=06KoSj8lKddJaGaN4+0+oY7wtQB+63MaXmxxtnnFGXr/ePn3gEl1kbV2vstFtLIK3UnACf
        cuIyB3uHIKNlkaM/bPsKmUb2sjig/ljmzJF8auCzz3dtdBS9AabeILrQVaxL0hL6hKXZXR
        cnDPB78x6CDQm4qTZ28mzLTYscM/r0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653488739;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcyUlkvRGFEW/ULXmTtgvKKFJcJyrBkqOjuEy8zAx28=;
        b=S1cldFVF2yAA5MrFeG9i8mtR4FZ7Du4esMvuhkF+Cs+x1OFib8TLIim13GWx3ycjenanAw
        lGtAbwtTMSTcFaAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5309313487;
        Wed, 25 May 2022 14:25:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZI1rEWM8jmI8awAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 25 May 2022 14:25:39 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 88802603;
        Wed, 25 May 2022 14:26:16 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     David Disseldorp <ddiss@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] ceph/005: verify correct statfs behaviour with quotas
References: <20220427143409.987-1-lhenriques@suse.de>
        <20220525001142.0a17a41a@suse.de> <87pmk2kn6m.fsf@brahms.olymp>
        <20220525123659.65270735@suse.de>
Date:   Wed, 25 May 2022 15:26:15 +0100
In-Reply-To: <20220525123659.65270735@suse.de> (David Disseldorp's message of
        "Wed, 25 May 2022 12:36:59 +0200")
Message-ID: <87tu9dwuwo.fsf@brahms.olymp>
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

> On Wed, 25 May 2022 09:53:53 +0100, Lu=C3=ADs Henriques wrote:
>
>> David Disseldorp <ddiss@suse.de> writes:
>>=20
>> > Hi Lu=C3=ADs,
>> >
>> > It looks like this one is still in need of review...=20=20
>>=20
>> Ah! Thanks for reminding me about it, David!
>>=20
>> >
>> > On Wed, 27 Apr 2022 15:34:09 +0100, Lu=C3=ADs Henriques wrote:
>> >=20=20
>> >> When using a directory with 'max_bytes' quota as a base for a mount,
>> >> statfs shall use that 'max_bytes' value as the total disk size.  That
>> >> value shall be used even when using subdirectory as base for the moun=
t.
>> >>=20
>> >> A bug was found where, when this subdirectory also had a 'max_files'
>> >> quota, the real filesystem size would be returned instead of the pare=
nt
>> >> 'max_bytes' quota value.  This test case verifies this bug is fixed.
>> >>=20
>> >> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> >> ---
>> >>  tests/ceph/005     | 40 ++++++++++++++++++++++++++++++++++++++++
>> >>  tests/ceph/005.out |  2 ++
>> >>  2 files changed, 42 insertions(+)
>> >>  create mode 100755 tests/ceph/005
>> >>  create mode 100644 tests/ceph/005.out
>> >>=20
>> >> diff --git a/tests/ceph/005 b/tests/ceph/005
>> >> new file mode 100755
>> >> index 000000000000..0763a235a677
>> >> --- /dev/null
>> >> +++ b/tests/ceph/005
>> >> @@ -0,0 +1,40 @@
>> >> +#! /bin/bash
>> >> +# SPDX-License-Identifier: GPL-2.0
>> >> +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
>> >> +#
>> >> +# FS QA Test 005
>> >> +#
>> >> +# Make sure statfs reports correct total size when:
>> >> +# 1. using a directory with 'max_byte' quota as base for a mount
>> >> +# 2. using a subdirectory of the above directory with 'max_files' qu=
ota
>> >> +#
>> >> +. ./common/preamble
>> >> +_begin_fstest auto quick quota
>> >> +
>> >> +_supported_fs generic
>> >> +_require_scratch
>> >> +
>> >> +_scratch_mount
>> >> +mkdir -p $SCRATCH_MNT/quota-dir/subdir
>> >> +
>> >> +# set quotas
>> >> +quota=3D$((1024*10000))
>> >> +$SETFATTR_PROG -n ceph.quota.max_bytes -v $quota $SCRATCH_MNT/quota-=
dir
>> >> +$SETFATTR_PROG -n ceph.quota.max_files -v $quota $SCRATCH_MNT/quota-=
dir/subdir
>> >> +_scratch_unmount
>> >> +
>> >> +SCRATCH_DEV=3D$SCRATCH_DEV/quota-dir _scratch_mount=20=20
>> >
>> > Aside from the standard please-quote-your-variables gripe, I'm a littl=
e=20=20
>>=20
>> Sure, I'll fix those in next iteration.
>>=20
>> > confused with the use of SCRATCH_DEV for this test. Network FSes where
>> > mkfs isn't provided don't generally use it. Is there any way that this
>> > could be run against TEST_DEV, or does the umount / mount complicate
>> > things too much?=20=20
>>=20
>> When I looked at other tests doing similar things (i.e. changing the mou=
nt
>> device during the test), they all seemed to be using SCRATCH_DEV.  I gue=
ss
>> that I could change TEST_DEV instead.  I'll revisit this and see if that
>> works.
>>=20
>> Anyway, regarding the usage of SCRATCH_DEV in cephfs, I've used several
>> different approaches:
>>=20
>> - Use 2 different filesystems created on the same cluster,
>> - Use 2 volumes on the same filesystem, or
>> - Simply use 2 directories in the same filesystem.
>
> Looking at _scratch_mkfs($FSTYP=3Dceph) there is support for scratch
> filesystem reinitialization, so I suppose this should be okay. With
> cephfs we could actually go one step further and call "ceph fs rm/new",
> but that's something for another day :-).

Right, that would require a more complex test setup, with user-space tools
on the test box/VM.  It definitely would be desirable to have such an
option for example in teuthology (the ceph testing framework), but for the
simple runs I usually do on VMs, I'd rather keep the default as-is.

Cheers,
--=20
Lu=C3=ADs
