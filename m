Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F72DD574
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Dec 2020 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgLQQqU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Dec 2020 11:46:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:42030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgLQQqT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 11:46:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 226D4ACA5;
        Thu, 17 Dec 2020 16:45:38 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 44919008;
        Thu, 17 Dec 2020 16:46:08 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: wip-msgr2
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
        <87wnxk1iwy.fsf@suse.de>
        <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
        <87sg881epx.fsf@suse.de> <877dpjyzw2.fsf@suse.de>
        <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
Date:   Thu, 17 Dec 2020 16:46:07 +0000
In-Reply-To: <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
        (Ilya Dryomov's message of "Tue, 15 Dec 2020 16:30:10 +0100")
Message-ID: <87sg848jow.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> writes:
<snip>
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

Looks like this fix didn't made it into your pull-request.  Did it just
fell through the cracks, or is this fixed somewhere else on the code?

(And wow! I didn't really expect msgrv2 to hit this merge window.  Nice.)

Cheers,
-- 
Luis
