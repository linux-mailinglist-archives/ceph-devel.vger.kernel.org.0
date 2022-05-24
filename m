Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6370532698
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 11:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiEXJhD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 05:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiEXJhC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 05:37:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D7B5FF36;
        Tue, 24 May 2022 02:37:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EACA721A0D;
        Tue, 24 May 2022 09:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653385019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfwiGjNM3p3HtaGKIb/6Lplo3Li0ltaC5AAPXmo1aPw=;
        b=0z9/d9BcptszSOdjmFD5ZspRf8I77Nwqmt7MSpuY8JdeGeIbutimoRjrtpO6nY8LMZUCeU
        ZYvLCcGaCQL8V04lUrNZ/C5IagR4Y/Dzo/oeC0EvgS2cu042/ZPUWFd1M4U3U6D6a7POOV
        4WV8mdhoxR5hsz3wSUHqAQsMEccsJMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653385019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfwiGjNM3p3HtaGKIb/6Lplo3Li0ltaC5AAPXmo1aPw=;
        b=WX7KvnVdudRDt6i/BxUzsIkooE4dgOKhh9XHb80slQaCKh/IwoQ1srpFUMtLUQMniIZ09Q
        XuHJAUeX9RA8pwCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ADC6413ADF;
        Tue, 24 May 2022 09:36:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BYe3JzunjGKaCAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 24 May 2022 09:36:59 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 44e5405e;
        Tue, 24 May 2022 09:37:37 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph/001: skip metrics check if no copyfrom mount
 option is used
References: <20220520105055.31520-1-lhenriques@suse.de>
        <20220524044507.m3drhwpn2orfp7my@zlang-mailbox>
        <20220524050436.qe4kc7bacm6hp54d@zlang-mailbox>
Date:   Tue, 24 May 2022 10:37:37 +0100
In-Reply-To: <20220524050436.qe4kc7bacm6hp54d@zlang-mailbox> (Zorro Lang's
        message of "Tue, 24 May 2022 13:04:36 +0800")
Message-ID: <87tu9fl19a.fsf@brahms.olymp>
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

> On Tue, May 24, 2022 at 12:45:07PM +0800, Zorro Lang wrote:
>> On Fri, May 20, 2022 at 11:50:55AM +0100, Lu=C3=ADs Henriques wrote:
>> > Checking the metrics is only valid if 'copyfrom' mount option is
>> > explicitly set, otherwise the kernel won't be doing any remote object
>> > copies.  Fix the logic to skip this metrics checking if 'copyfrom' isn=
't
>> > used.
>> >=20
>> > Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> > ---
>>=20
>> The code logic looks good to me, but I'm not familiar with cephfs, so if=
 there's
>> not review points or objection from ceph-fs, I'll merge this patch this =
week.
>>=20
>> Reviewed-by: Zorro Lang <zlang@redhat.com>
>>=20
>> Thanks,
>> Zorro
>>=20
>> >  tests/ceph/001 | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >=20
>> > diff --git a/tests/ceph/001 b/tests/ceph/001
>> > index 7970ce352bab..2e6a5e6be2d6 100755
>> > --- a/tests/ceph/001
>> > +++ b/tests/ceph/001
>> > @@ -86,11 +86,15 @@ check_copyfrom_metrics()
>> >  	local copies=3D$4
>> >  	local c1=3D$(get_copyfrom_total_copies)
>> >  	local s1=3D$(get_copyfrom_total_size)
>> > +	local hascopyfrom=3D$(_fs_options $TEST_DEV | grep "copyfrom")
>
> Oh, I forgot to metion that:
>
> I don't know what's the mount option output format at here, can't sure if
> "grep -w" is needed, or need special pattern.

I don't think there's a need for the '-w' here; the mount option is
exactly that string:

192.168.155.1:40768:/ on /mnt type ceph (rw,relatime,name=3Duser,secret=3D<=
hidden>,acl,copyfrom)

>> >  	local sum
>> >=20=20
>> >  	if [ ! -d $metrics_dir ]; then
>> >  		return # skip metrics check if debugfs isn't mounted
>> >  	fi
>> > +	if [ -z $hascopyfrom ]; then
>
> I think better to use quotes ("$hascopyfrom") at here.

I'll send v2 with that changed.  Thank you for your feedback.

Cheers,
--=20
Lu=C3=ADs

>> > +		return # ... or if we don't have copyfrom mount option
>> > +	fi
>> >=20=20
>> >  	sum=3D$(($c0+$copies))
>> >  	if [ $sum -ne $c1 ]; then
>> >=20
>

