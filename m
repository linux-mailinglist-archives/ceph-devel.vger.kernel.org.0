Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBF96FA295
	for <lists+ceph-devel@lfdr.de>; Mon,  8 May 2023 10:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjEHIuY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 04:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjEHIuX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 04:50:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37271162B
        for <ceph-devel@vger.kernel.org>; Mon,  8 May 2023 01:50:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4FA1021C3D;
        Mon,  8 May 2023 08:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683535820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VlpeXN7Q8uJBMF953IMyNctg/La3r1XLbgJhMmXwb00=;
        b=GHbt0V+pcBTSBJ1PyVGlp++nY5AIu+PrYH7pFw2Tz5yKMeA8B/aZmdO+NarxYXXsIKIUt/
        qjpX+B4gTmRs0B5xXWLn+eJDuVOmFqPttpTstrI5h/tp/YANl5bhcX/rLCMXKoKcdW/Lv4
        84mT0o4wjBNfM0wL91VLbxpheTgqDEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683535820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VlpeXN7Q8uJBMF953IMyNctg/La3r1XLbgJhMmXwb00=;
        b=PloWwzXwMjWydqA/Mk/5j3iK4dwEBupRfi57Jci6bx2/AOm040qeGoFvocpCyuZscLw6GD
        VVMtA7mJBLo+JrCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00C3F13499;
        Mon,  8 May 2023 08:50:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vjO5OMu3WGSfWwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 08 May 2023 08:50:19 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id e7224edd;
        Mon, 8 May 2023 08:50:19 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph updates for 6.4-rc1
References: <20230504182810.165185-1-idryomov@gmail.com>
        <87wn1nm2bu.fsf@brahms.olymp>
        <CAOi1vP_eqNTrQMX1jC-jXJTKZKb=GifQtFfzgrsMXQffBgQuYw@mail.gmail.com>
Date:   Mon, 08 May 2023 09:50:19 +0100
In-Reply-To: <CAOi1vP_eqNTrQMX1jC-jXJTKZKb=GifQtFfzgrsMXQffBgQuYw@mail.gmail.com>
        (Ilya Dryomov's message of "Fri, 5 May 2023 20:59:06 +0200")
Message-ID: <87sfc75hro.fsf@brahms.olymp>
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

Ilya Dryomov <idryomov@gmail.com> writes:

> On Fri, May 5, 2023 at 1:42=E2=80=AFPM Lu=C3=ADs Henriques <lhenriques@su=
se.de> wrote:
>>
>>
>> [re-arranged CC list]
>>
>> Ilya Dryomov <idryomov@gmail.com> writes:
>>
>> > Hi Linus,
>> >
>> > The following changes since commit 457391b0380335d5e9a5babdec90ac53928=
b23b4:
>> >
>> >   Linux 6.3 (2023-04-23 12:02:52 -0700)
>> >
>> > are available in the Git repository at:
>> >
>> >   https://github.com/ceph/ceph-client.git tags/ceph-for-6.4-rc1
>> >
>> > for you to fetch changes up to db2993a423e3fd0e4878f4d3ac66fe717f5f072=
e:
>> >
>> >   ceph: reorder fields in 'struct ceph_snapid_map' (2023-04-30 12:37:2=
8 +0200)
>> >
>> > ----------------------------------------------------------------
>> > A few filesystem improvements, with a rather nasty use-after-free fix
>> > from Xiubo intended for stable.
>>
>> Thank you, Ilya.  It's unfortunate that fscrypt support misses yet anoth=
er
>> merge window, but I guess there are still a few loose ends.
>>
>> Is there a public list of issues (kernel or ceph proper) still to be
>> sorted out before this feature gets merged?  Or is this just a lack of
>> confidence on the implementation stability?
>
> Hi Lu=C3=ADs,
>
> When fscrypt work got supposedly finalized it was already pretty late
> in the cycle and it just didn't help that upon pulling it I encountered
> a subtly broken patch which was NACKed before ("libceph: defer removing
> the req from osdc just after req->r_callback") and also that "optionally
> bypass content encryption" leftover.  It got addressed but too late for
> such a large change to be staged for 6.4 merge window.
>=20
> I would encourage everyone to make another pass over the entire series
> to make sure that there is nothing eyebrows-raising left there and that
> it really feels solid.

Thanks for the clarification, Ilya.  I'll definitely restart testing and
reviewing the whole series, that's something I've been doing every time
the patchset is rebased.  But yeah my eyes are already so used to look
into that code that any issues I may be able to find are probably related
with the rebase itself :-)

Cheers,
--=20
Lu=C3=ADs
