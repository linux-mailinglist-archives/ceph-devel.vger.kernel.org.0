Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3512DB114
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Dec 2020 17:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgLOQPQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Dec 2020 11:15:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:54490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgLOQPD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 11:15:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04669ACE0;
        Tue, 15 Dec 2020 16:14:17 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 743c3531;
        Tue, 15 Dec 2020 16:14:46 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: wip-msgr2
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
        <87wnxk1iwy.fsf@suse.de>
        <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
        <87sg881epx.fsf@suse.de> <877dpjyzw2.fsf@suse.de>
        <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
Date:   Tue, 15 Dec 2020 16:14:46 +0000
In-Reply-To: <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
        (Ilya Dryomov's message of "Tue, 15 Dec 2020 16:30:10 +0100")
Message-ID: <873607yrk9.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> writes:

<snip>

>> Looks like the memset in prepare_head_secure_small() is cleaning behind
>> the base limits.  Unfortunately, I didn't really had time to dig deeper
>> into this.
>
> Ah, I disabled KASAN for some performance testing and didn't turn
> it back on.  This doesn't actually corrupt any memory because the
> 96-byte object that gets allocated is big enough.  In fact, the
> relevant code used to request 96 bytes independent of the connection
> mode until I changed it to follow the on-wire format more strictly.
>
> This frame is 68 bytes in plane mode and 96 bytes in secure mode
> but we are requesting 68 bytes in both modes.  The following should
> fix it:

Yep, it does fix it.  Thanks for the quick reply.

Cheers,
-- 
Luis

>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 5e38c847317b..11fd47b36fc8 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -1333,7 +1333,8 @@ static int prepare_auth_signature(struct
> ceph_connection *con)
>         void *buf;
>         int ret;
>
> -       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE, false));
> +       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE,
> +                                                 con_secure(con)));
>         if (!buf)
>                 return -ENOMEM;
>
> Thanks,
>
>                 Ilya

