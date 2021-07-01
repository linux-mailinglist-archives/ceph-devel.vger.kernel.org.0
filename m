Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EFF3B8BBC
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jul 2021 03:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbhGABUu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 21:20:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238229AbhGABUt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 21:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625102299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hv2L5zFZegU1kDHOfzLyZBnnzfOeruD11fp4ja0RqxQ=;
        b=iJ8jqupc0JWvjsQjDBrJU+YoyxrHSOOcvsCM+C0oWrcmlgUZJCmKx1XBeB7fOeALNw4b1C
        7ABtYtazqh7vMVovYJk2loI1en0C29yzrgNllhXsPVGITX+jLauuawpthuvz1cwhJngpYo
        xj1umpDSzizHff+7LYNzV6k1sUqeuHg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-LAfZGhCcMouI-UYdSei3ww-1; Wed, 30 Jun 2021 21:18:17 -0400
X-MC-Unique: LAfZGhCcMouI-UYdSei3ww-1
Received: by mail-pf1-f200.google.com with SMTP id 124-20020a6217820000b02902feebfd791eso2861966pfx.19
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 18:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hv2L5zFZegU1kDHOfzLyZBnnzfOeruD11fp4ja0RqxQ=;
        b=Tf3yPjNngXBJZs5CVVqicXCTyLEQEAbvxumFK7pqM5BQ8Hb4/PE3PzHFwhG1Sg9P2j
         5Dr+a53IrMHcFtwQxRrA4rOWxLqd/05PoiU6QLRSxsqSW8iUjgMhf04y7KkBt9rx9IVq
         GGDpUOXeCNnuQpwKisvQGxrzivw9txoX9wRd5D5JcuyM6YPqM0ik8oeIT1F7LrmgPbVe
         cCyPdBf3tGFWZ8EaoXSoM+YKEdJnJ5uqJ8EI1o2nUB9/959GEIArnHU955hRiwHe45qf
         8mf6PyYR4MsEbuZ7BpAQqAo6xa0xStF4htS5cvdDtI5kVfGaakik0mFeN8PdyoquYNv9
         TRaw==
X-Gm-Message-State: AOAM533kbKhq1GXLWzVrdJ7ZkbhAjau2YQUZh9MmfxzwmYsWzsU6YkRd
        Ot97qgEe1uwe0p+sQB7VGZPIHUipNLjjWVPCKXvfMEgdnodPmQfPo1Z5hGXC5f2s6sBhaO93ckQ
        rYKbZmRr8I2ErjtVvgn0VkBA9BeC8rfk2mTLe03z2MrXIdx6T0m0tKoXAltbzZv3zSrnei2c=
X-Received: by 2002:a17:90a:d988:: with SMTP id d8mr7059648pjv.111.1625102296526;
        Wed, 30 Jun 2021 18:18:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5e0Y9RyA3SXaIl1E+hEDalcA2bZXb4AE7gASeAm7WCN6tErMw4guM+QlmoEXElWpBJdYNAQ==
X-Received: by 2002:a17:90a:d988:: with SMTP id d8mr7059623pjv.111.1625102296234;
        Wed, 30 Jun 2021 18:18:16 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j16sm25071095pgh.69.2021.06.30.18.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 18:18:15 -0700 (PDT)
Subject: Re: [PATCH 3/5] ceph: flush mdlog before umounting
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-4-xiubli@redhat.com>
 <CAOi1vP-g4rChLzvpqr2cPrbe0sRLQwbUxOKPcdaSRcHUpcboUA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e6cf6b83-55ef-2fcf-cf5c-82500cc3fa1b@redhat.com>
Date:   Thu, 1 Jul 2021 09:18:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-g4rChLzvpqr2cPrbe0sRLQwbUxOKPcdaSRcHUpcboUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/21 8:39 PM, Ilya Dryomov wrote:
> On Tue, Jun 29, 2021 at 6:42 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         | 29 +++++++++++++++++++++++++++++
>>   fs/ceph/mds_client.h         |  1 +
>>   include/linux/ceph/ceph_fs.h |  1 +
>>   3 files changed, 31 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 96bef289f58f..2db87a5c68d4 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4689,6 +4689,34 @@ static void wait_requests(struct ceph_mds_client *mdsc)
>>          dout("wait_requests done\n");
>>   }
>>
>> +static void send_flush_mdlog(struct ceph_mds_session *s)
>> +{
>> +       u64 seq = s->s_seq;
>> +       struct ceph_msg *msg;
>> +
>> +       /*
>> +        * For the MDS daemons lower than Luminous will crash when it
>> +        * saw this unknown session request.
> "Pre-luminous MDS crashes when it sees an unknown session request"
Will fix it.
>
>> +        */
>> +       if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
>> +               return;
>> +
>> +       dout("send_flush_mdlog to mds%d (%s)s seq %lld\n",
> Should (%s)s be just (%s)?
Will fix it.
>
>> +            s->s_mds, ceph_session_state_name(s->s_state), seq);
>> +       msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG, seq);
>> +       if (!msg) {
>> +               pr_err("failed to send_flush_mdlog to mds%d (%s)s seq %lld\n",
> Same here and let's avoid function names in error messages.  Something
> like "failed to request mdlog flush ...".
Okay.
>
>> +                      s->s_mds, ceph_session_state_name(s->s_state), seq);
>> +       } else {
>> +               ceph_con_send(&s->s_con, msg);
>> +       }
>> +}
>> +
>> +void flush_mdlog(struct ceph_mds_client *mdsc)
>> +{
>> +       ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>> +}
> Is this wrapper really needed?
Yeah, I can remove it.
>
>> +
>>   /*
>>    * called before mount is ro, and before dentries are torn down.
>>    * (hmm, does this still race with new lookups?)
>> @@ -4698,6 +4726,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>          dout("pre_umount\n");
>>          mdsc->stopping = 1;
>>
>> +       flush_mdlog(mdsc);
>>          ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>>          ceph_flush_dirty_caps(mdsc);
>>          wait_requests(mdsc);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index fca2cf427eaf..79d5b8ed62bf 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -537,6 +537,7 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>                                       int (*cb)(struct inode *,
>>                                                 struct ceph_cap *, void *),
>>                                       void *arg);
>> +extern void flush_mdlog(struct ceph_mds_client *mdsc);
>>   extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>>
>>   static inline void ceph_mdsc_free_path(char *path, int len)
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index 57e5bd63fb7a..ae60696fe40b 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -300,6 +300,7 @@ enum {
>>          CEPH_SESSION_FLUSHMSG_ACK,
>>          CEPH_SESSION_FORCE_RO,
>>          CEPH_SESSION_REJECT,
>> +       CEPH_SESSION_REQUEST_FLUSH_MDLOG,
> Need to update ceph_session_op_name().

Sure.

Thanks

BRs

> Thanks,
>
>                  Ilya
>

