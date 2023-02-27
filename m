Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1196A3F79
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 11:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjB0Kac (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Feb 2023 05:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjB0Ka3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Feb 2023 05:30:29 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58958FF38
        for <ceph-devel@vger.kernel.org>; Mon, 27 Feb 2023 02:30:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0EBD01F8D9;
        Mon, 27 Feb 2023 10:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677493827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWZg/qj/gBpZxjSz01BFGh2UVTBOKUI30Vv3Imzn1lU=;
        b=sOXPePT4Gm+0XABd/z1meeacb2sYkhgPgqGGa9TX0ebrHnK3gJUxyZVtFlTINnFwTX1loF
        6t/yz1BEdyLzJho9Xs2lnECduTy/yt0BB6sAjAvlQj/Bz6ETWN0EoDZlUUVHODnZWzuFFx
        8sKDaKaEMr4XHI7xL18J+XK4YFKq53g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677493827;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWZg/qj/gBpZxjSz01BFGh2UVTBOKUI30Vv3Imzn1lU=;
        b=YaNvFvk8Z+FWgcRtDT4pPhlG6OVs0fQ1KM66R90zkg/FwsRQfRl6J6qQDjkuE/04QiOcjR
        vFbWHhFP6tIwZdBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 92F0713A43;
        Mon, 27 Feb 2023 10:30:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GYiZIEKG/GMkdwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 27 Feb 2023 10:30:26 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 3222d43d;
        Mon, 27 Feb 2023 10:30:25 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v16 00/68] ceph+fscrypt: full support
References: <20230227032813.337906-1-xiubli@redhat.com>
        <87fsar791v.fsf@suse.de>
        <ca5b6f7e-f3e6-7f35-a9b4-23acc0ff0747@redhat.com>
Date:   Mon, 27 Feb 2023 10:30:25 +0000
In-Reply-To: <ca5b6f7e-f3e6-7f35-a9b4-23acc0ff0747@redhat.com> (Xiubo Li's
        message of "Mon, 27 Feb 2023 17:58:47 +0800")
Message-ID: <87356r764e.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> Hi Luis,
>
> On 27/02/2023 17:27, Lu=C3=ADs Henriques wrote:
>> xiubli@redhat.com writes:
>>
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> This patch series is based on Jeff Layton's previous great work and eff=
ort
>>> on this.
>>>
>>> Since v15 we have added the ceph qa teuthology test cases for this [1][=
2],
>>> which will test both the file name and contents encryption features and=
 at
>>> the same time they will also test the IO benchmarks.
>>>
>>> To support the fscrypt we also have some other work in ceph [3][4][5][6=
][7][8]:
>>>
>>> [1] https://github.com/ceph/ceph/pull/48628
>>> [2] https://github.com/ceph/ceph/pull/49934
>>> [3] https://github.com/ceph/ceph/pull/43588
>>> [4] https://github.com/ceph/ceph/pull/37297
>>> [5] https://github.com/ceph/ceph/pull/45192
>>> [6] https://github.com/ceph/ceph/pull/45312
>>> [7] https://github.com/ceph/ceph/pull/40828
>>> [8] https://github.com/ceph/ceph/pull/45224
>>> [9] https://github.com/ceph/ceph/pull/45073
>>>
>>> The [8] and [9] are still undering testing and will soon be merged after
>>> that. All the others had been merged long time ago.
>> Thanks a lot for your work on this, Xiubo (and Jeff!).  I assume this set
>> is what's on the 'testing' branch.  I've done some testing on that branch
>> recently, but I'll start having another look at v16 and run some more
>> tests.
>
> Yeah, this full fscrypt patch series has been in the 'testing' branch 2 m=
onths
> ago as we discussed in the IRC. After that I just appended the following =
two
> commits:
>
>
> =C2=A0 libceph: defer removing the req from osdc just after req->r_callba=
ck
> =C2=A0 ceph: drop the messages from MDS when unmounting
>
>
> And also 2 small other minor fixes in the commit comments and folded the
> following double free fixing patch reported by Ilya:
>
> https://patchwork.kernel.org/project/ceph-devel/patch/20230111011403.5709=
64-1-xiubli@redhat.com/

Awesome, thanks for confirming.  Just wanted to make sure there wasn't
anything new in this set.

>> Am I right assuming that this v16 patchset means we are NOT getting this
>> merged into 6.3?
>
> Yeah, not get merged yet. Because we were never able to put this to test =
since
> we had lots of infra issues with teuthology in last 2 months.
>
> Since the teuthology Labs are back to work now we are running the tests a=
nd
> after that the patches will be ready.

Yeah, I saw these infrastructure issues and all the trouble it has been
causing.  Hopefully everything will be fine for the next merge window.

Again, thanks for the update!

Cheers
--=20
Lu=C3=ADs
