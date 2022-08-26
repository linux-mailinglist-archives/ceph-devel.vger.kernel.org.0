Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0165A1D8C
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Aug 2022 02:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244428AbiHZAHz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 20:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243778AbiHZAHy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 20:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DCFC876D
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 17:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661472471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u1YpXpWcn19uhyPos9jDWAgrYEMdTrX2bZf1nVdIh44=;
        b=McdVbK4DjK1ugvcRNqlBBY+g97GMQtqDWTv21BKJFZauiC1rmcCN4GLOB/j5mTbE1vd9Zt
        8IF27trC96NgrxsWI31Dnmgyq5wLS7eX2h+VCrNx6gbvYof8zFp4Rff4cYxA2nl+0mjYcS
        SIpEcQElm2YhYhRVQhY1zKI7IeFlFc4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-385-Nwg1pQKXNvOTQhfnsEtFiQ-1; Thu, 25 Aug 2022 20:07:49 -0400
X-MC-Unique: Nwg1pQKXNvOTQhfnsEtFiQ-1
Received: by mail-pj1-f69.google.com with SMTP id r6-20020a17090a2e8600b001fbb51e5cc1so1692972pjd.5
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 17:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=u1YpXpWcn19uhyPos9jDWAgrYEMdTrX2bZf1nVdIh44=;
        b=XyRFCArFz+i8a3tH65cVwPlAGhYnfd75hBc0gHn1+rYXZRnSelPSeKG5+/Gm0R5FcM
         FHecmz7SjqaDJlSvLH0WzHkuVcUQdejHEfcx9C2T/xLr53RYsbdhi5NtEgaSDUBIhArf
         MEkJ2b65fxjrzJSpUF7BLukdgTRUtpRaxbmci2kYodc5X2fXfd+ggRXhFdyJahguxFjo
         9YWjasPJMVPSnJy5WckUj3XSnXhZpnIjfjJLtro3mFn9UG0eP9WgzkH6kTi7jvsWFAyK
         Lr0vMi2v1aoyX9iG/Y7lYZhbeQcl/BCY+oUW6Fm0zX0q/kCA+Po6tTRA3QyoVUm/tt/x
         K1PQ==
X-Gm-Message-State: ACgBeo0xTTrm7Mb8ZyRSA7fBaVvyOoWRQtqAwOuj8Cn05llcvqY16e5t
        HBXKgkTQknTJJPAhp4eKLJ9+Nz4OJdaHEEkGc0YwAXvufixonLyor4BRTomrKrUL0OzqZFSZn/1
        fxOlyrOzvqWbru4t9bW/Wym3xQPtXJDkoQ0WXg1TZ3oElWRWapf3kaK2w0EgT9zUYNoHeEmk=
X-Received: by 2002:a17:902:caca:b0:173:3a23:e4f7 with SMTP id y10-20020a170902caca00b001733a23e4f7mr1439677pld.113.1661472468017;
        Thu, 25 Aug 2022 17:07:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5kwsC0xsJMh6a0PInUmClwCdgCL5EcEZ5Aq8+jdEnxeAilalXlsnnvKjVEA9i3UZbg61+pBA==
X-Received: by 2002:a17:902:caca:b0:173:3a23:e4f7 with SMTP id y10-20020a170902caca00b001733a23e4f7mr1439650pld.113.1661472467647;
        Thu, 25 Aug 2022 17:07:47 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 18-20020a621412000000b0053725e331a1sm227522pfu.82.2022.08.25.17.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 17:07:47 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
References: <20220824205331.473248-1-jlayton@kernel.org>
 <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
 <9a9218cad137d07b81fa8d2c984f840098b3ae29.camel@kernel.org>
 <b40e97ec41a013f796c6df981c55e7458ae205f8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c307fdd0-0ca0-104e-0068-2c0fb2138698@redhat.com>
Date:   Fri, 26 Aug 2022 08:07:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b40e97ec41a013f796c6df981c55e7458ae205f8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/25/22 9:16 PM, Jeff Layton wrote:
> On Thu, 2022-08-25 at 06:56 -0400, Jeff Layton wrote:
>> On Thu, 2022-08-25 at 10:32 +0200, Ilya Dryomov wrote:
>>> On Wed, Aug 24, 2022 at 10:53 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> ceph_sync_write has assumed that a zero result in req->r_result means
>>>> success. Testing with a recent cluster however shows the OSD returning
>>>> a non-zero length written here. I'm not sure whether and when this
>>>> changed, but fix the code to accept either result.
>>>>
>>>> Assume a negative result means error, and anything else is a success. If
>>>> we're given a short length, then return a short write.
>>>>
>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>> ---
>>>>   fs/ceph/file.c | 10 +++++++++-
>>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 86265713a743..c0b2c8968be9 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>>>                                            req->r_end_latency, len, ret);
>>>>   out:
>>>>                  ceph_osdc_put_request(req);
>>>> -               if (ret != 0) {
>>>> +               if (ret < 0) {
>>>>                          ceph_set_error_write(ci);
>>>>                          break;
>>>>                  }
>>>>
>>>> +               /*
>>>> +                * FIXME: it's unclear whether all OSD versions return the
>>>> +                * length written on a write. For now, assume that a 0 return
>>>> +                * means that everything got written.
>>>> +                */
>>>> +               if (ret && ret < len)
>>>> +                       len = ret;
>>>> +
>>>>                  ceph_clear_error_write(ci);
>>>>                  pos += len;
>>>>                  written += len;
>>>> --
>>>> 2.37.2
>>>>
>>> Hi Jeff,
>>>
>>> AFAIK OSDs aren't allowed to return any kind of length on a write
>>> and there is no such thing as a short write.  This definitely needs
>>> deeper investigation.
>>>
>>> What is the cluster version you are testing against?
>>>
>> That's what I had thought too but I wasn't sure:
>>
>>      [ceph: root@quad1 /]# ceph --version
>>      ceph version 17.0.0-14400-gf61b38dc (f61b38dc82e94f14e7a0a5f6a5888c0c78fafa6c) quincy (dev)
>>
>> I'll see if I can confirm that this is coming from the OSD and not some
>> other layer as well.
> My mistake. This bug turns out to be a different bug in the fscrypt
> stack. We can drop this patch (and I probably should have sent it as an
> RFC in the first place). Sorry for the noise!
>
Cool, thanks Jeff.

I saw you new update about this, they look good to me and will test them.

- Xiubo

