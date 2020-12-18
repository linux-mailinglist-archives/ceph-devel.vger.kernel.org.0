Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF42DE794
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Dec 2020 17:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbgLRQpr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Dec 2020 11:45:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:53582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731609AbgLRQpr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 11:45:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5E962AD07;
        Fri, 18 Dec 2020 16:45:05 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 87923e61;
        Fri, 18 Dec 2020 16:45:35 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: wip-msgr2
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
        <87wnxk1iwy.fsf@suse.de>
        <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
        <87sg881epx.fsf@suse.de> <877dpjyzw2.fsf@suse.de>
        <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
        <87sg848jow.fsf@suse.de>
        <CAOi1vP8D2em7QeZNn5h21UN8AF159ZqbwGxorP7sG2msQMJwYw@mail.gmail.com>
Date:   Fri, 18 Dec 2020 16:45:35 +0000
In-Reply-To: <CAOi1vP8D2em7QeZNn5h21UN8AF159ZqbwGxorP7sG2msQMJwYw@mail.gmail.com>
        (Ilya Dryomov's message of "Thu, 17 Dec 2020 18:25:17 +0100")
Message-ID: <87lfdv83m8.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


(Ups!  Looks like this email never left my drafts maildir.)

Ilya Dryomov <idryomov@gmail.com> writes:

> On Thu, Dec 17, 2020 at 5:45 PM Luis Henriques <lhenriques@suse.de> wrote:
>>
>> Ilya Dryomov <idryomov@gmail.com> writes:
>> <snip>
>> >
>> > Ah, I disabled KASAN for some performance testing and didn't turn
>> > it back on.  This doesn't actually corrupt any memory because the
>> > 96-byte object that gets allocated is big enough.  In fact, the
>> > relevant code used to request 96 bytes independent of the connection
>> > mode until I changed it to follow the on-wire format more strictly.
>> >
>> > This frame is 68 bytes in plane mode and 96 bytes in secure mode
>> > but we are requesting 68 bytes in both modes.  The following should
>> > fix it:
>> >
>> > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>> > index 5e38c847317b..11fd47b36fc8 100644
>> > --- a/net/ceph/messenger_v2.c
>> > +++ b/net/ceph/messenger_v2.c
>> > @@ -1333,7 +1333,8 @@ static int prepare_auth_signature(struct
>> > ceph_connection *con)
>> >         void *buf;
>> >         int ret;
>> >
>> > -       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE, false));
>> > +       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE,
>> > +                                                 con_secure(con)));
>> >         if (!buf)
>> >                 return -ENOMEM;
>>
>> Looks like this fix didn't made it into your pull-request.  Did it just
>> fell through the cracks, or is this fixed somewhere else on the code?
>
> No, it didn't, it's in the testing branch:
>
>   https://github.com/ceph/ceph-client/commit/add7ad675cd1bdaf2751da1af9295fb43896da66

Cool, thanks for confirming.  Just wanted to make sure ;-)

Cheers,
-- 
Luis
