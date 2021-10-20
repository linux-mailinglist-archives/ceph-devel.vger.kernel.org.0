Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB5D434373
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 04:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJTCRx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 22:17:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhJTCRf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 22:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634696121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o1c9jOugVljX1GhFi7TCNpuiZuRmd+MXUTDJTRq8v3g=;
        b=hGDFjbNymcy06BKIGrmXUVDziot85hGiWH1Npff8IdpmILTh8uQTF2EDpyYIVFIIKQ8ZyV
        u70bOW5TJuRuhXPgiOJYq8pP1ErqMLEpOuY+q+CCmAFCu4mR8Zi3oQoVxl2aCgJ48oclRh
        OlOMHWlzbIPFJJEAQMCg/K15x/dts90=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-eokMBmR1NWqfZ1JYqjTOMw-1; Tue, 19 Oct 2021 22:15:20 -0400
X-MC-Unique: eokMBmR1NWqfZ1JYqjTOMw-1
Received: by mail-pg1-f200.google.com with SMTP id n9-20020a63f809000000b0026930ed1b24so12575854pgh.23
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 19:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o1c9jOugVljX1GhFi7TCNpuiZuRmd+MXUTDJTRq8v3g=;
        b=FB/Nb3NzFjIHIPmq7JjnpK2IanD0yN6iabLqHr37304st9JMDzPwzGFbpBoT7mmGVQ
         zsWIZ2q2tLS4jff4OdUohlCSmwLbwlGj6FnAOnfj6cKMXgQUJhgGwLgu1zXZwKqdmwzE
         Xu08N8hOs0IhPYZqfGuSTPfHKEP9Xsz7SCdewaeGal+V0812DkFdS+vTILReuRMcemVq
         qyZHyMHzsANMjPyjJoHXLPpgdTADasboxu1ms/nw9voCAFZMR9SA0BP/TyKRDS8M0cv2
         FPGd3lEPtWtoHGynec7qTMZ4QMhNzBYxeZExPP9PKodolkL+/urXRDwuEt1YMfYcjBFj
         YZSg==
X-Gm-Message-State: AOAM533WOVakiSuZ+2AiebYmxELENlDWd+EJk2zPUJeBEO7d+WsimehU
        xbd8mubHEHedi/hcTaqC2QTx6MrjV82CF/ear1t0+g7dWN88ekKSnLjtaP+gyC87JXAaZt3FfoI
        /bb3YK+Xacg9G3jcxtZaMF/U74HtGuPP3qQakM6Va0J+fUCXLXS0mbrPAoseMHVmBv+rSYZM=
X-Received: by 2002:a17:903:18c:b0:13f:255:9dca with SMTP id z12-20020a170903018c00b0013f02559dcamr37019794plg.37.1634696118515;
        Tue, 19 Oct 2021 19:15:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrSj+9CWtsOXf4nkZcKuArIxQ6tcDoJLDpHKjYsTBG8E31vKfwgrMcJajwLjVkZ7MCoysX+w==
X-Received: by 2002:a17:903:18c:b0:13f:255:9dca with SMTP id z12-20020a170903018c00b0013f02559dcamr37019766plg.37.1634696118161;
        Tue, 19 Oct 2021 19:15:18 -0700 (PDT)
Received: from [10.72.12.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u2sm491005pfi.120.2021.10.19.19.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 19:15:17 -0700 (PDT)
Subject: Re: [PATCH] ceph: return the real size readed when hit EOF
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, khiremat@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211019115138.414187-1-xiubli@redhat.com>
 <23269de451786354f33adc8a8f59a48c89748ddd.camel@kernel.org>
 <9026d15c-f238-c56d-1fa4-bf859847baec@redhat.com>
Message-ID: <9b976d29-b101-e4ec-d69d-cbe6d76716ff@redhat.com>
Date:   Wed, 20 Oct 2021 10:15:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9026d15c-f238-c56d-1fa4-bf859847baec@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/20/21 10:04 AM, Xiubo Li wrote:
>
> On 10/19/21 8:59 PM, Jeff Layton wrote:
>> On Tue, 2021-10-19 at 19:51 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> At the same time set the ki_pos to the file size.
>>>
>> It would be good to put the comments in your follow up email into the
>> patch description here, so that it explains what you're fixing and why.
> Sure.
>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/file.c | 14 +++++++++-----
>>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 91173d3aa161..1abc3b591740 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb 
>>> *iocb, struct iov_iter *to,
>>>       ssize_t ret;
>>>       u64 off = iocb->ki_pos;
>>>       u64 len = iov_iter_count(to);
>>> +    u64 i_size = i_size_read(inode);
>> Was there a reason to change where the i_size is fetched, or did you
>> just not see the point in fetching it on each loop? I wonder if we can
>> hit any races vs. truncates with this?
>
> From my reading from the code, it shouldn't.
>
> While doing the truncate it will down_write(&inode->i_rwsem). And the 
> sync read will hold down_read() it. It should be safe.
>
And also this should be safe if the truncate is in a different kclient:

When the MDS received the truncate request, it must revoke the 'Fr' caps 
from all the kclients first. So if another kclient is still reading the 
file, the truncate will be pause.


>>
>> Oh well, all of this non-buffered I/O seems somewhat racy anyway. ;)
>>
>>>       dout("sync_read on file %p %llu~%u %s\n", file, off, 
>>> (unsigned)len,
>>>            (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>> @@ -870,7 +871,6 @@ static ssize_t ceph_sync_read(struct kiocb 
>>> *iocb, struct iov_iter *to,
>>>           struct page **pages;
>>>           int num_pages;
>>>           size_t page_off;
>>> -        u64 i_size;
>>>           bool more;
>>>           int idx;
>>>           size_t left;
>>> @@ -909,7 +909,6 @@ static ssize_t ceph_sync_read(struct kiocb 
>>> *iocb, struct iov_iter *to,
>>>             ceph_osdc_put_request(req);
>>>   -        i_size = i_size_read(inode);
>>>           dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>>>                off, len, ret, i_size, (more ? " MORE" : ""));
>>>   @@ -954,10 +953,15 @@ static ssize_t ceph_sync_read(struct kiocb 
>>> *iocb, struct iov_iter *to,
>>>         if (off > iocb->ki_pos) {
>>>           if (ret >= 0 &&
>> Do we need to check ret here?
>
> It seems this check makes no sense even in the following case I 
> mentioned. Will check it more and try to remove it.
>
>
>> I think that if ret < 0, then "off" must
>> be smaller than "i_size", no?
>
> From current code, there has one case that it's no, such as if the 
> file size is 10, and the ceph may return 4K contents and then the read 
> length will be 4K too, and if it just fails in case:
>
>                         copied = copy_page_to_iter(pages[idx++],
>                                                    page_off, len, to);
>                         off += copied;
>                         left -= copied;
>                         if (copied < len) {
>                                 ret = -EFAULT;
>                                 break;
>                         }
>
> And if the "copied = 1K" for some reasons, the "off" will be larger 
> than the "i_size" but ret < 0.
>
> BRs
>
> Xiubo
>
>
>
>>
>>> -            iov_iter_count(to) > 0 && off >= i_size_read(inode))
>>> +            iov_iter_count(to) > 0 &&
>>> +            off >= i_size_read(inode)) {
>>>               *retry_op = CHECK_EOF;
>>> -        ret = off - iocb->ki_pos;
>>> -        iocb->ki_pos = off;
>>> +            ret = i_size - iocb->ki_pos;
>>> +            iocb->ki_pos = i_size;
>>> +        } else {
>>> +            ret = off - iocb->ki_pos;
>>> +            iocb->ki_pos = off;
>>> +        }
>>>       }
>>>         dout("sync_read result %zd retry_op %d\n", ret, *retry_op);

